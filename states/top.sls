# include:
#   - mysql
#   - apache
#   - rabbitmq
#   - tftpd
#   - dnsmasq
#   - memcached
#   - keystone

base:
  'minion.ub16.salt3':
    - nettools
    - nginx
    - tftpd
    - dnsmasq
    - mysql
    - rabbitmq
    - memcached
    - keystone
    - ironic

  # 'salt.m2.ubuntu.net':
  #   - mysql
  #   - memcached
  #   - dnsmasq
  #   - rabbitmq
  #   - tftpd
  #   - ironic
  #   - nettools

  'ub16-standard':
    - memcached
    - nettools
#   - apache
    - mysql
    - rabbitmq
    - keystone
    - neutron
    - ironic
    - tftpd
#    - dnsmasq
