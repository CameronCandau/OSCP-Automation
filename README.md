# OSCP Toolkit

Workflow automation for OSCP labs and exam. Handles target initialization, enumeration, and workspace management.

## Setup
```bash
git clone https://github.com/CameronCandau/OSCP-Automation ~/oscp-automation
cd ~/oscp-automation
make install
echo 'source ~/oscp-automation/config/shellrc-additions.sh' >> ~/.zshrc
source ~/.zshrc
```

## Usage

### Initialize targets
```bash
# Single target
new-target 192.168.50.10 DC01

# Batch from file
init-lab hosts.txt
```

**hosts.txt format:**
```
192.168.50.10 DC01
192.168.50.11 WEB01
192.168.50.12
```

### Enumeration
```bash
cd ~/oscp/DC01
scan          # Fast nmap + autorecon
parse-ports   # Extract open ports to markdown
```

### Environment
- `$IP` auto-loads from `.target` file in each target directory
- Each target gets its own wezterm workspace (if available)
- Directory structure: `~/oscp/<target>/{nmap,web,loot}`

## Uninstall
```bash
cd ~/oscp-automation
make uninstall
```