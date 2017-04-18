base:
  'minion.ub16.salt3':
    - rabbitmq
    - mysql
    - dnsmasq
    - tftpd
    - nginx
    - memcached
    - keystone
    - ironic
 
  # 'salt.m2.ubuntu.net':
  #   - mysql
  #   - memcached
  #   - rabbitmq
  #   - tftpd
  #   - dnsmasq
  #   - ironic
    

  'ub16-standard':
    - memcached
    - mysql
    - apache
    - rabbitmq
#    - dnsmasq
    - keystone
    - neutron
    - ironic
    - tftpd
