mysql:
  server:
    enabled: true
    version: '5.7'
    force_encoding: utf8
    admin:
      user: root
      password: password
    bind:
      address: 0.0.0.0
      port: 3306
      protocol: tcp
    database:
      ironic:
        encoding: utf8
        users:
        - name: ironic
          password: 'password'
          host: 'localhost'
          rights: 'all privileges'
      keystone:
        encoding: utf8
        users:
        - name: keystone
          password: 'password'
          host: 'localhost'
          rights: 'all privileges'
      neutron:
        encoding: utf8
        users:
        - name: neutron
          password: 'password'
          host: 'localhost'
          rights: 'all privileges'
