dnsmasq:
  server:
    enabled: true
    disable_dnsmasq_dns: true
    inventory_dhcp: false
    testing: false
    local_address: 10.0.175.2
    network_interface: ens7
    dnsmasq_router: 10.0.175.2
    dnsmasq_dns_servers: 8.8.8.8,8.8.4.4
    dhcp_pool_start: 10.0.175.180
    dhcp_pool_end: 10.0.175.250
    dhcp_netmask: 255.255.254.0
    dhcp_lease_time: 12h
    file_url_port: 8080
