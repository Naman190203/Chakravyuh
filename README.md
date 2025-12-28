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
 a. Dynamic ARP Inspection (DAI)
 b. DHCP Snooping
 c. Port Security

ML Model updation 

1. for normalization of the data  used pandas and for storing numpy
2. for visualization  used seaborn and matplotlib
3. for physical layer detection ISOLATION FOREST algo is applied which gave accuracy of 90%
   on the dataset of around 2000 data which consists of features like package rate
4. for datalink layer detection DBSCAN algo is used
