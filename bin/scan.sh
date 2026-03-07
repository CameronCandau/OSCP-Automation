#!/bin/bash
# Fast enumeration workflow

IP=${IP:-$(cat .target 2>/dev/null)}

if [ -z "$IP" ]; then
    echo "[!] Error: No \$IP set and no .target file found"
    exit 1
fi

echo "[*] Target: $IP"
echo ""

# Fast port scan - run directly, output is visible
echo "[>] Running: nmap --min-rate 4500 --max-rtt-timeout 1500ms -p- -Pn $IP -oG nmap/all_ports.gnmap"
nmap --min-rate 4500 --max-rtt-timeout 1500ms -p- -Pn "$IP" -oG nmap/all_ports.gnmap

echo ""

# Run autorecon in a tmux window so it persists if the terminal closes
SESSION="${TARGET_NAME:-$IP}"
if command -v tmux &>/dev/null; then
    if [ -n "$TMUX" ]; then
        # Already inside tmux — open a new window for autorecon
        tmux new-window -n "autorecon" "cd '$PWD' && autorecon '$IP' --only-scans-dir; echo '[+] Done'; read -rp 'Press enter to close'"
        echo "[+] Autorecon running in new tmux window 'autorecon'"
        echo "    Switch to it with: Ctrl+B then n  (or your tmux prefix + n)"
    else
        # Not in tmux — create a detached session
        tmux new-session -d -s "${SESSION}-scan" -c "$PWD" \
            "autorecon '$IP' --only-scans-dir; echo '[+] Done'; read -rp 'Press enter to close'"
        echo "[+] Autorecon running in tmux session '${SESSION}-scan'"
        echo "    Attach with: tmux attach -t '${SESSION}-scan'"
    fi
else
    echo "[>] Running: autorecon $IP --only-scans-dir"
    autorecon "$IP" --only-scans-dir
fi

echo ""
echo "[+] Enumeration started for $IP"
