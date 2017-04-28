dnsmasq:
  server:
    enabled: true
    disable_dnsmasq_dns: ==DNSMASQ_DONT_USE_EXTERNAL_DNS==
    inventory_dhcp: false
    testing: false
    local_address: ==IRONIC_PXE_INTERFACE_ADDRESS==
    network_interface: ==IRONIC_PXE_INTERFACE_NAME==
    dnsmasq_router: ==IRONIC_PXE_INTERFACE_ADDRESS==
    dnsmasq_dns_servers: 8.8.8.8,8.8.4.4
    dhcp_pool_start: ==IRONIC_DHCP_POOL_START==
    dhcp_pool_end: ==IRONIC_DHCP_POOL_END==
    dhcp_netmask: ==IRONIC_DHCP_POOL_NETMASK==
    dhcp_lease_time: 12h
    file_url_port: 8080
