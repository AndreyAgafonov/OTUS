#!/usr/bin/bash
# Включаем маршрутизацию "второй сети Vagrant" через default gateway.
# Теперь можно обращаться на https://freeipa.cloud16.test (192.168.11.117) с любой машины в сети, если, конечно, настроен DNS
echo "add default gateway..."
sudo nmcli connection modify "System eth1" +ipv4.gateway "192.168.11.1" ipv4.route-metric 1
sleep 3
sudo systemctl restart network
exit 0
