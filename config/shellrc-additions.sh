# OSCP shell additions — source this from ~/.bashrc or ~/.zshrc
#
# If direnv is installed (recommended), it handles $IP/$TARGET_NAME automatically
# on cd. This file is only needed for the tmux session hint and as a fallback
# for environments without direnv.
#
# Setup:
#   echo 'source ~/oscp/OSCP-Automation/config/shellrc-additions.sh' >> ~/.bashrc
#   # and for direnv:
#   echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

# Direnv hook (skip if already set up in .bashrc directly)
if command -v direnv &>/dev/null && [[ "$DIRENV_IN_ENVRC" != "1" ]]; then
    eval "$(direnv hook bash)" 2>/dev/null || true
fi

# Fallback: if direnv is not installed, auto-load .target on cd
# This uses PROMPT_COMMAND so it triggers on every prompt (including after cd)
_oscp_autoload_target() {
    if command -v direnv &>/dev/null; then
        return  # direnv handles this
    fi
    if [ -f .target ] && [ "${_OSCP_LAST_DIR:-}" != "$PWD" ]; then
        export IP=$(cat .target)
        export TARGET_NAME=$(basename "$PWD")
        export _OSCP_LAST_DIR="$PWD"

        # Update vClip session cache
        VCLIP_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/vclip/vars.json"
        mkdir -p "$(dirname "$VCLIP_CACHE")"
        printf '{\n  "IP": "%s",\n  "TARGET": "%s"\n}\n' "$IP" "$TARGET_NAME" > "$VCLIP_CACHE"

        echo "[*] Loaded target: $TARGET_NAME ($IP)"

        # Show tmux session hint if one exists
        if command -v tmux &>/dev/null && tmux has-session -t "$TARGET_NAME" 2>/dev/null; then
            echo "    Tmux session '$TARGET_NAME' — attach with: tmux attach -t '$TARGET_NAME'"
        fi
    fi
}

PROMPT_COMMAND="_oscp_autoload_target${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
