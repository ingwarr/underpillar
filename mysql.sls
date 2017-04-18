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
          password: password
          host: '%'
          rights: all
        - name: ironic
          password: password
          host: 127.0.0.1
          rights: all

  client:
    enabled: true
    server:
      minion.ub16.salt2:
        admin:
          host: localhost
          port: 3306
          user: root
          password: password
          encoding: utf8
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
