#!/bin/bash
# Parse open ports from nmap gnmap output to markdown checklist

if [ ! -f nmap/all_ports.gnmap ]; then
    echo "[!] Error: nmap/all_ports.gnmap not found"
    echo "    Run 'scan' first or check you're in the target directory"
    exit 1
fi

echo "TCP Ports:"
grep -oP '\d+/open' nmap/all_ports.gnmap | cut -d/ -f1 | sed 's/^/- [ ] /'