#!/bin/bash
IP="$1"

if [ -z "$IP" ]; then
  echo "Usage: $0 <target-ip>"
  exit 1
fi

echo "[*] Fast scanning all TCP ports on $IP..."
nmap --min-rate 4500 --max-rtt-timeout 1500ms -p- -Pn -oG all_ports.gnmap "$IP"

echo "[*] Extracting open TCP ports..."
TCP_PORTS=$(grep -oP '\d+/open' all_ports.gnmap | cut -d/ -f1 | paste -sd, -)
echo "$TCP_PORTS" > open_tcp_ports.txt


if [ -z "$TCP_PORTS" ]; then
  echo "[!] No open TCP ports found."
else
  echo "[*] Running detailed TCP scan on: $TCP_PORTS"
  nmap -sC -sV -T4 -Pn -p"$TCP_PORTS" -oA full_tcp "$IP"
fi

echo "[*] Scanning top 100 UDP ports..."
nmap -sU --top-ports 100 -T4 -Pn -oA top_udp "$IP"
