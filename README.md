Install standalone ironic using salt-minion
===========================================


Assume that 'ens4' is the interface connected to the PXE network, which
will be used for provisioning, and the address 10.0.175.2/24 is already
added to this interface.

There is possible to use dnsmasq or neutron as a PXE provider.

    # Login to the node which will be used for Ironic under 'root' user

    export IRONIC_PXE_MANAGER=dnsmasq
    export IRONIC_PXE_INTERFACE_NAME=ens4
    export IRONIC_PXE_INTERFACE_ADDRESS=10.0.175.2
    export IRONIC_DHCP_POOL_START=10.0.175.100
    export IRONIC_DHCP_POOL_END=10.0.175.200
    export DNSMASQ_USE_EXTERNAL_DNS=true

    curl https://raw.githubusercontent.com/ingwarr/underpillar/master/bootstrap.sh -o ./bootstrap.sh && bash ./bootstrap.sh


Use standalone ironic to provision a cloudinit-based image without metadata server
==================================================================================

Usually, cloudinit-based images are used to spawn instances in aws, openstack
and other clouds.
For this purpose, in the cloud environment is running a metadata server that
provides additional configuration to the instance.

But there is a NoCloud datasource supported by cloudinit, that doesn't require
a metadata service.

Let's bootstrap a baremetal server as an instance with standalone ironic only.

What we need here:

- An image with ironic agent that is used to bootstrap the node and listen to the commands
- A cloudinit-based image that is used to deploy the node
- A small config-drive image with initial settings for cloudinit

- IPMI credentials to the target node and the MAC address of the node interface that will
  be used for booting with PXE.

Build ironic-agent image
------------------------

    # Clone the agent repository and switch to Newton release
    git clone https://git.openstack.org/openstack/ironic-python-agent
    sudo apt-get install docker.io gzip uuid-runtime cpio findutils grep gnupg make
    cd ironic-python-agent/imagebuild/coreos
    git checkout stable/newton

    # Build the image
    sudo service docker start
    sudo make

    # Copy the image to the /httpboot folder (default nginx document root here)
    cp ./UPLOAD/coreos_production_pxe_image-oem.cpio.gz /httpboot/
    cp ./UPLOAD/coreos_production_pxe.vmlinuz /httpboot/
    chmod a+r /httpboot/coreos_production_pxe*

Get the cloudinit-based image
-----------------------------

    wget https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img -O /httpboot/xenial-server-cloudimg-amd64.qcow2
    # md5 is required for Ironic to check the image after downloading to the target node
    export CLOUDINIT_IMAGE_MD5=`md5sum /httpboot/xenial-server-cloudimg-amd64.qcow2 | awk '{print $1}'`

Build a config-drive image
--------------------------

NoCloud datasource use a very simple structure for configdrive:

    .
    ├── meta-data
    └── user-data

There are two files in YAML format (like for EC2) in the root of configdrive.
The label of the configdrive image should be 'cidata'.

Example content for 'meta-data' file:

    instance-id: iid-local1
    local-hostname: slave01.example.local

Example content for 'user-data' file:

    #cloud-config , do not remove this!

    ssh_pwauth: True
    users:
     - name: root
       sudo: ALL=(ALL) NOPASSWD:ALL
       shell: /bin/bash
       ssh_authorized_keys:
        - ssh-rsa AAAA......

    disable_root: false
    chpasswd:
     list: |
      root:r00tme
     expire: False

    output:
      all: '| tee -a /var/log/cloud-init-output.log /dev/tty0'

    runcmd:
     - apt-get clean
     - eatmydata apt-get update && apt-get -y upgrade

     # Install common packages
     - eatmydata apt-get install -y python-pip git curl tmux byobu iputils-ping traceroute htop tree mc

For more user-data options, see http://cloudinit.readthedocs.io/en/latest/topics/examples.html

Let's generate an ISO file using 'user-data' and 'meta-data' files and place it to /httpboot/ folder.
Keep in mind that Ironic accepts configdrive image only in the gzipped and base64 format.

    apt-get install -y genisoimage
    genisoimage -output /httpboot/cloud_settings.iso -volid cidata -joliet -rock ./user-data ./meta-data
    gzip -9 -c /httpboot/cloud_settings.iso | base64 > /httpboot/cloud_settings.iso.gz.base64


Add the tagret node to the Ironic
---------------------------------

    export OS_AUTH_TOKEN=fake-token
    export IRONIC_URL=http://localhost:6385/

    # Create the node with IPMI credentials in Ironic:
    ironic node-create -d agent_ipmitool \
        -i ipmi_address=slave01-ipmi.internal.net -i ipmi_username=********** -i ipmi_password=*********** \
        -i deploy_kernel=http://${IRONIC_PXE_INTERFACE_ADDRESS}:8080/coreos_production_pxe.vmlinuz \
        -i deploy_ramdisk=http://${IRONIC_PXE_INTERFACE_ADDRESS}:8080/coreos_production_pxe_image-oem.cpio.gz

    # Get the node UUID from the output and store it into the variable for reuse in next commands, for example:
    # export IRONIC_NODE_UUID=d78186ed-28d7-401f-bd91-503d4da91ea7

    # Create the port with MAC address of the target node,
    # so the Ironic could match the node by DHCP request source:
    ironic port-create -n ${IRONIC_NODE_UUID} -a 0c:c4:aa:bb:cc:dd  # MAC address of the node PXE interface

Set the deploy image and run provisioning
-----------------------------------------

    # Add the cloudinit-based image to the node settings
    ironic node-update ${IRONIC_NODE_UUID} add \
        instance_info/root_gb=200 \
        instance_info/image_source=http://${IRONIC_PXE_INTERFACE_ADDRESS}:8080/xenial-server-cloudimg-amd64.qcow2 \
        instance_info/image_checksum=${CLOUDINIT_IMAGE_MD5}

    # Validate the node settings for any case
    ironic node-validate ${IRONIC_NODE_UUID}

    # Start deploy process
    ironic node-set-provision-state --config-drive=/httpboot/cloud_settings.iso.gz.base64 ${IRONIC_NODE_UUID} active

    # Watch for a few minutes until the node status becomes 'active' with:
    ironic node-show-states  ${IRONIC_NODE_UUID}

Troubleshooting
---------------

* Get the node status and errors. 'deploying' means the process is going, 'active' - process is finished.
  Don't be hurry, the node is rebooting after 'active' status and will not be available for few seconds.

      ironic node-show-states ${IRONIC_NODE_UUID}

* Show all node settings:

      ironic node-show ${IRONIC_NODE_UUID}

* To reinstall the already provisioned node with the same config, use 'rebuild':

      ironic node-set-provision-state ${IRONIC_NODE_UUID} rebuild

* If node stucks in wrong condition, it can be re-deployed by changing the provisioning state to 'deleted'
  and re-execute steps from ```Set the deploy image and run provisioning```.
  Wait for state changing to 'available' for several minutes because of reboot/cleaning processes.

      ironic node-set-provision-state ${IRONIC_NODE_UUID} deleted

* If Ironic don't accept changing the states (for example, if node is still in 'clean wait' status),
  the node can be removed from Ironic and re-created again:

      ironic node-set-maintenance ${IRONIC_NODE_UUID} on
      ironic node-delete ${IRONIC_NODE_UUID}

* More about Ironic node states can be found here:
  https://docs.openstack.org/developer/ironic/dev/states.html

* Automatic node cleaning can be disabled to avoid the following error while setting provision state to 'deleted':

      'Clean step failed: Error performing clean_step erase_devices:
         No HardwareManager found to handle method:
           Could not find method: erase_block_device'

  To disable automated clean, set automated_clean=false in /etc/ironic/ironic.conf .

  More about cleaning:
  https://docs.openstack.org/developer/ironic/deploy/cleaning.html

* Adoption an already deployed node as ready to use without re-deploy:

  Create node in Ironic and update it with the necessary settings.
  Use the following states instead of 'active' to set the node as
  ready-to-use instead of starting deploy process.

      ironic node-set-provision-state ${IRONIC_NODE_UUID} manage
      ironic node-set-provision-state ${IRONIC_NODE_UUID} adopt

  More about adoption and risks:
  https://docs.openstack.org/developer/ironic/deploy/adoption.html

