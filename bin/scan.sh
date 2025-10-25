#!/bin/bash
# Fast enumeration workflow - logs commands as they run

IP=${IP:-$(cat .target 2>/dev/null)}

if [ -z "$IP" ]; then
    echo "[!] Error: No \$IP set and no .target file found"
    exit 1
fi

echo "[*] Target: $IP"
echo ""

CMD="nmap --min-rate 4500 --max-rtt-timeout 1500ms -p- -Pn $IP -oG nmap/all_ports.gnmap"
echo "[>] Running: $CMD"
eval $CMD

echo ""
CMD="autorecon $IP --only-scans-dir"
echo "[>] Running: $CMD"
eval $CMD

echo ""
echo "[+] Enumeration started for $IP"