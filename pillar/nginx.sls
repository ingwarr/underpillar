nginx:
  server:
    undercloud: true
    enabled: true
    file_url_port: 8080
    extras: false
    hostname: localhost
    http_boot_folder: /httpboot
    http_boot_folder_mode: 777
    # bind:
    #   address: 127.0.0.1
    #   protocol: tcp
    # worker:
    #   limit:
    #     nofile: 30000


