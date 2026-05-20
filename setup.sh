#!/bin/bash

# Raspberry Pi Router Setup Script
# Converts Raspberry Pi into a WiFi router/AP
# SSID: Chakravyuh
# Password: raspberry123

set -e

echo "========================================="
echo " Raspberry Pi Router Setup Starting..."
echo "========================================="

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Please run this script as root:"
   echo "sudo bash setup-router.sh"
   exit 1
fi

echo "[1/13] Updating packages..."
apt update -y

echo "[2/13] Installing required packages..."
apt install -y hostapd dnsmasq iptables-persistent

echo "[3/13] Enabling required services..."
systemctl unmask hostapd
systemctl enable hostapd
systemctl enable dnsmasq
systemctl enable systemd-networkd
systemctl start systemd-networkd

echo "[4/13] Configuring hostapd..."

cat > /etc/hostapd/hostapd.conf <<EOF
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

echo "[5/13] Linking hostapd configuration..."
sed -i 's|#DAEMON_CONF=""|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd

echo "[6/13] Configuring dnsmasq..."

# Backup original config if not already backed up
if [ ! -f /etc/dnsmasq.conf.orig ]; then
    mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
fi

cat > /etc/dnsmasq.conf <<EOF
interface=wlan0
dhcp-range=192.168.4.10,192.168.4.50,255.255.255.0,24h
EOF

echo "[7/13] Configuring wlan0 static IP..."
mkdir -p /etc/systemd/network

cat > /etc/systemd/network/12-wlan0.network <<EOF
[Match]
Name=wlan0

[Network]
Address=192.168.4.1/24
DHCPServer=no
EOF

echo "[8/13] Enabling IP forwarding..."
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-ipforward.conf
sysctl --system

echo "[9/13] Configuring iptables NAT..."

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

echo "[10/13] Saving iptables rules..."
sh -c "iptables-save > /etc/iptables/rules.v4"

echo "[11/13] Enabling WiFi interface..."
rfkill unblock wifi
ip link set wlan0 up

echo "[12/13] Restarting services..."
systemctl restart systemd-networkd
systemctl restart dnsmasq
systemctl restart hostapd

echo "[13/13] Checking service status..."

echo ""
echo "===== HOSTAPD STATUS ====="
systemctl --no-pager status hostapd | head -n 10

echo ""
echo "===== DNSMASQ STATUS ====="
systemctl --no-pager status dnsmasq | head -n 10

echo ""
echo "========================================="
echo " Raspberry Pi Router Setup Complete!"
echo "========================================="
echo ""
echo "WiFi Name (SSID): Chakravyuh"
echo "WiFi Password   : raspberry123"
echo "Router IP       : 192.168.4.1"
echo "Router IP       : 192.168.4.1:5173"
