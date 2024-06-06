#!/bin/bash

set -e
jq -n --arg host $(hostname) \
      --arg os_name $(lsb_release -d | awk '{print $2}') \
      --arg os_version $(lsb_release -r | awk '{print $2}') \
      --arg public_ip $(curl -s ifconfig.me) \
      --arg dev $(ip a | grep global | grep -v '10.0.2.15' | awk '{print $10}' | head -1) \
      --arg ip $(ip a | grep global | grep -v '10.0.2.15' | awk '{print $2}' | cut -f1 -d '/' | head -1) \
      --arg ips $(ip a | grep global | grep -v '10.0.2.15' | awk '{print $2}' | cut -f1 -d '/' | paste -s -d, -) \
      '{"dev":$dev, "ip":$ip, "host":$host, "public_ip":$public_ip, "ips":$ips, "os_version":$os_version}'
