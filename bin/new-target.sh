#!/bin/bash
# Initialize a new target workspace

if [ $# -lt 1 ]; then
    echo "Usage: new-target <IP> [NAME]"
    echo "Example: new-target 192.168.50.10 DC01"
    exit 1
fi

IP="$1"
NAME="${2:-$IP}"
TARGET_DIR=~/oscp/"$NAME"

# Create directory structure
echo "[*] Creating target directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"/{nmap,web,loot}

# Write .target for script fallback (scan.sh etc.)
echo "$IP" > "$TARGET_DIR/.target"

# Write .envrc for direnv (auto-exports $IP and $TARGET_NAME on cd)
cat > "$TARGET_DIR/.envrc" << EOF
export IP="$IP"
export TARGET_NAME="$NAME"
EOF

if command -v direnv &>/dev/null; then
    direnv allow "$TARGET_DIR"
    echo "[*] direnv: \$IP and \$TARGET_NAME will auto-export on cd"
else
    echo "[!] direnv not installed — run: sudo apt install direnv"
    echo "    Until then, source shellrc-additions.sh manually or add to PROMPT_COMMAND"
fi

# Write to vClip session cache so $IP and $TARGET pre-fill automatically
VCLIP_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/vclip/vars.json"
mkdir -p "$(dirname "$VCLIP_CACHE")"
printf '{\n  "IP": "%s",\n  "TARGET": "%s"\n}\n' "$IP" "$NAME" > "$VCLIP_CACHE"
echo "[*] Updated vClip cache: \$IP=$IP, \$TARGET=$NAME"

# Create a tmux session for this target (detached)
if command -v tmux &>/dev/null; then
    if tmux has-session -t "$NAME" 2>/dev/null; then
        echo "[*] Tmux session '$NAME' already exists"
    else
        tmux new-session -d -s "$NAME" -c "$TARGET_DIR"
        echo "[+] Tmux session '$NAME' created"
    fi
    echo "    Attach with: tmux attach -t '$NAME'"
fi

echo "[+] Target initialized: $NAME ($IP)"
echo "    Directory: $TARGET_DIR"
echo "    Tip: Use ALT+SHIFT+CTRL+M in wezterm for enum/exploit/shell workspace layout"
