keystone:
# Server state
  server:
    enabled: true
    version: liberty
    service_name: apache2
    service_token: RANDOMSTRINGTOKEN
    service_tenant: service
    admin_tenant: admin
    admin_name: admin
    admin_password: passw0rd
    admin_email: root@localhost
    bind:
      address: 0.0.0.0
      private_address: 127.0.0.1
      private_port: 35357
      public_address: 127.0.0.1
      public_port: 5000
    region: RegionOne
    database:
      engine: mysql
      host: localhost
      name: keystone
      password: passw0rd
      user: keystone
    tokens:
      engine: cache
      expiration: 86400
      location: /etc/keystone/fernet-keys/
    notification: false
    notification_format: cadf
    #message_queue:
      #engine: rabbitmq
      #host: 127.0.0.1
      #port: 5672
      #user: openstack
      #password: password
      #virtual_host: '/openstack'
      #ha_queues: true
# Client state
  client:
    enabled: true
    server:
      identity:
        admin:
          host: localhost
          port: 35357
          token: RANDOMSTRINGTOKEN
        roles:
        - admin
        - Member
        project:
          service:
            description: "OpenStack Service tenant"
            user:
              ironic:
                is_admin: true
                password: password
                email: ironic@localhost
              neutron:
                is_admin: true
                password: password
                email: ironic@localhost
          admin:
            description: "OpenStack Admin tenant"
            user:
              admin:
                is_admin: true
                password: passw0rd
                email: admin@localhost
        service:
          keystone3:
            type: identity
            description: OpenStack Identity Service v3
            endpoints:
            - region: RegionOne
              public_address: 127.0.0.1
              public_protocol: http
              public_port: 5000
              public_path: '/v3'
              internal_address: 127.0.0.1
              internal_port: 5000
              internal_path: '/v3'
              admin_address: 127.0.0.1
              admin_port: 35357
              admin_path: '/v3'
          keystone:
            type: identity
            description: OpenStack Identity Service
            endpoints:
            - region: RegionOne
              public_address: 127.0.0.1
              public_protocol: http
              public_port: 5000
              public_path: '/v2.0'
              internal_address: 127.0.0.1
              internal_port: 5000
              internal_path: '/v2.0'
              admin_address: 127.0.0.1
              admin_port: 35357
              admin_path: '/v2.0'

        # service:
        #   user:
        #     neutron:
        #       is_admin: true
        #       password: passw0rd
        #       email: admin@localhost
        #service:
          neutron:
            type: network
            description: OpenStack Networking Service
            endpoints:
            - region: RegionOne
              public_address: 127.0.0.1
              public_port: 9696
              public_path: '/'
              internal_address: 127.0.0.1
              internal_port: 9696
              internal_path: '/'
              admin_address: 127.0.0.1
              admin_port: 9696
              admin_path: '/'

          ironic:
            type: baremetal
            description: OpenStack Baremetal Provision Service
            endpoints:
            - region: RegionOne
              public_address: 127.0.0.1
              public_port: 6385
              public_path: '/'
              internal_address: 127.0.0.1
              internal_port: 6385
              internal_path: '/'
              admin_address: 127.0.0.1
              admin_port: 6385
              admin_path: '/'

          #keystone3:
            #name: keystone3
            #type: identity
            #description: OpenStack Identity Service v3
            #endpoints:
            #- region: RegionTwo
              #public_address: 127.0.0.1
              #public_protocol: http
              #public_port: 5000
              #public_path: '/v3'
              #internal_address: 127.0.0.1
              #internal_port: 5000
              #internal_path: '/v3'
              #admin_address: 127.0.0.1
              #admin_port: 35357
              #admin_path: '/v3'
          #keystone:
            #name: keystone
            #type: identity
            #description: OpenStack Identity Service
            #endpoints:
            #- region: RegionTwo
              #public_address: 127.0.0.1
              #public_protocol: http
              #public_port: 5000
              #public_path: '/v2.0'
              #internal_address: 127.0.0.1
              #internal_port: 5000
              #internal_path: '/v2.0'
              #admin_address: 127.0.0.1
              #admin_port: 35357
              #admin_path: '/v2.0'
# CI related dependencies
apache:
  server:
    enabled: true
    default_mpm: event
    mpm:
      prefork:
        enabled: true
        servers:
          start: 5
          spare:
            min: 2
            max: 10
        max_requests: 0
        max_clients: 20
        limit: 20
    site:
      keystone:
        enabled: true
        type: keystone
        name: wsgi
        host:
          name: localhost
    pkgs:
      - apache2
    modules:
      - wsgi
