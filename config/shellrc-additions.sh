# Auto-load target IP from .target file
if [ -f .target ]; then
    export IP=$(cat .target)
    export TARGET_NAME=$(basename "$PWD")
    echo "[*] Loaded target: $TARGET_NAME ($IP)"
fi