#!/bin/bash

# Helper to print and run commands
run() {
  echo "+ $*"
  eval "$@"
}

IP="$1"

if [ -z "$IP" ]; then
  echo "Usage: $0 <target-ip>"
  exit 1
fi

echo "[*] Fast scanning all TCP ports on $IP..."

cmd="nmap --min-rate 4500 --max-rtt-timeout 1500ms -p- -Pn $IP -oG all_ports.gnmap"
run "$cmd"

echo "[*] Extracting open TCP ports..."
TCP_PORTS=$(grep -oP '\d+/open' all_ports.gnmap | cut -d/ -f1 | paste -sd, -)
echo "$TCP_PORTS" > open_tcp_ports.txt

if [ -z "$TCP_PORTS" ]; then
  echo "[!] No open TCP ports found."
else
  echo "[*] Running detailed TCP scan on: $TCP_PORTS"
  
  cmd="nmap -sC -sV -T4 -Pn -p$TCP_PORTS $IP -oA full_tcp"
  run "$cmd"
fi

echo "[*] Scanning top 100 UDP ports..."
cmd="nmap -sU --top-ports 100 -T4 -Pn $IP -oA top_udp"
run "$cmd"
