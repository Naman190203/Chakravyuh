# Chakravyuh
Final Year Project Documentation

-- Configuring Raspberry Pi as a choke point -
1. Procure 2 NICs on Pi (native + USB adapter).
2. Wire router → eth0, eth1 → switch.
3. Assign static IPs on eth0/eth1.
4. Enable net.ipv4.ip_forward=1.
5. Add iptables FORWARD rules and optional NAT (MASQUERADE).
6. Set DHCP for LAN to hand out Pi as default gateway (via dnsmasq or router config).
7. Run Snort in IDS mode on eth1 (later move to NFQUEUE for inline blocking).
8. Start tcpdump/pcap captures and verify traffic flow.
9. Harden Pi and set up remote log aggregation.



TO-DO Ideas

 1. spoofing should be captured in case of static ip is created to impersonate someone.
 2. 
