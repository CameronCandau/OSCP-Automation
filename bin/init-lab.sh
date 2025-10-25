#!/bin/bash
# Batch initialize all targets from hosts.txt

if [ $# -lt 1 ]; then
    echo "Usage: init-lab <hosts-file>"
    echo "Example: init-lab hosts.txt"
    echo ""
    echo "hosts.txt format (one per line):"
    echo "  192.168.50.10"
    echo "  192.168.50.11 DC01"
    echo "  192.168.50.12 WEB01"
    exit 1
fi

HOSTS_FILE=$1

if [ ! -f "$HOSTS_FILE" ]; then
    echo "[!] Error: File not found: $HOSTS_FILE"
    exit 1
fi

echo "[*] Initializing lab from $HOSTS_FILE..."
echo ""

while read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    
    # Parse IP and optional name
    IP=$(echo $line | awk '{print $1}')
    NAME=$(echo $line | awk '{print $2}')
    
    new-target $IP $NAME
    echo ""
done < "$HOSTS_FILE"

echo "[+] Lab initialization complete"
echo "[*] Don't forget to update ~/oscp/hosts.txt for netexec"