#!/bin/bash
# Initialize a new target directory and workspace

if [ $# -lt 1 ]; then
    echo "Usage: new-target <IP> [NAME]"
    echo "Example: new-target 192.168.50.10 DC01"
    exit 1
fi

IP=$1
NAME=${2:-$IP}
TARGET_DIR=~/oscp/$NAME

echo "[*] Creating target directory: $TARGET_DIR"
mkdir -p $TARGET_DIR/{nmap,web,loot}

echo "[*] Setting target IP: $IP"
echo $IP > $TARGET_DIR/.target

echo "[*] Creating wezterm workspace: $NAME"
wezterm cli spawn --new-window --workspace $NAME --cwd $TARGET_DIR 2>/dev/null || {
    echo "[!] Wezterm CLI not available, skipping workspace creation"
    echo "    Manually cd to: $TARGET_DIR"
}

echo "[+] Target initialized: $NAME ($IP)"
echo "    Directory: $TARGET_DIR"