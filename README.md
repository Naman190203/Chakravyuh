# Chakravyuh
Final Year Project Documentation

-- Configuring Raspberry Pi as a router ---
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install -y hostapd dnsmasq iptables-persistent
```
```
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
sudo systemctl enable systemd-networkd
sudo systemctl start systemd-networkd
```
```
sudo tee /etc/hostapd/hostapd.conf > /dev/null <<EOF
interface=wlan0
driver=nl80211
ssid=Chakravyuh
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=raspberry123
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
EOF
```
```
sudo sed -i 's|#DAEMON_CONF=""|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd
```
```
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
```

```
sudo tee /etc/dnsmasq.conf > /dev/null <<EOF
interface=wlan0
dhcp-range=192.168.4.10,192.168.4.50,255.255.255.0,24h
EOF
```

```
sudo mkdir -p /etc/systemd/network
```
```
sudo tee /etc/systemd/network/12-wlan0.network > /dev/null <<EOF
[Match]
Name=wlan0

[Network]
Address=192.168.4.1/24
DHCPServer=no
EOF
```
```
echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/99-ipforward.conf
sudo sysctl --system
```
```
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo sh -c "iptables-save > /etc/iptables/rules.v4"
```
```
sudo rfkill unblock wifi
sudo ip link set wlan0 up
```
```
sudo systemctl restart systemd-networkd
sudo systemctl restart dnsmasq
sudo systemctl restart hostapd
```


---ML Model details--- 

1. for normalization of the data  used pandas and for storing numpy
2. for visualization  used seaborn and matplotlib
3. for physical layer detection ISOLATION FOREST algo is applied which gave accuracy of 90%
   on the dataset of around 2000 data which consists of features like package rate
4. for datalink layer detection DBSCAN algo is used
