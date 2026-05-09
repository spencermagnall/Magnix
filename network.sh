#!/bin/sh
ip link set eth0 up
udhcpc -i eth0
ip route add default via 10.0.2.2
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "Network configured"
ip addr
ip route show
