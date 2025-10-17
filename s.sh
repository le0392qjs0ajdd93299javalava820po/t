#!/bin/bash

# LavaShell MoDroid - SSH Remote Access Manager with Welcome Message
# Fixed Host Key Persistence + SSH Welcome Message
# Created by Moein Nikchehre

set -e

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
CONFIG_DIR="$HOME/.lavashell"
CONFIG_FILE="$CONFIG_DIR/config"
DEFAULT_SSH_PORT=22
ALTERNATE_PORT=2222
CURRENT_PORT=$DEFAULT_SSH_PORT
IS_CYGWIN=false

# Global variables
CURRENT_SELECTION=0
MENU_ITEMS=()
SSH_STATUS="UNKNOWN"
PUBLIC_IP="Unknown"
LOCAL_IP="Unknown"
SSH_PID=""

# Detect environment
detect_environment() {
    if [[ $(uname -s) == CYGWIN* ]]; then
        IS_CYGWIN=true
        print_success "Cygwin environment detected"
    else
        print_error "This script is designed for Cygwin only!"
        exit 1
    fi
}

# ASCII Art
print_banner() {
    clear
    echo -e "${PURPLE}"
    cat << "BANNER"
    __                      _____ __         ____
   / /   ____ __   ______ _/ ___// /_  ___  / / /
  / /   / __ `/ | / / __ `/\__ \/ __ \/ _ \/ / / 
 / /___/ /_/ /| |/ / /_/ /___/ / / / /  __/ / /  
/_____/\__,_/ |___/\__,_//____/_/ /_/\___/_/_/   
    __  ___      ____             _     __       
   /  |/  /___  / __ \_________  (_)___/ /       
  / /|_/ / __ \/ / / / ___/ __ \/ / __  /        
 / /  / / /_/ / /_/ / /  / /_/ / / /_/ /         
/_/  /_/\____/_____/_/   \____/_/\__,_/
                                             
BANNER
    echo -e "${NC}"
    echo -e "${CYAN}┌────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${WHITE}    LavaShell MoDroid - V1 / Server ${CYAN}         │${NC}"
    echo -e "${CYAN}│${WHITE}    Moein Nikchehre - lsi.ct.ws${CYAN}              │${NC}"
    echo -e "${CYAN}└────────────────────────────────────────────────────────────┘${NC}"
    echo
}

# Utility functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo
    echo -e "${CYAN}${BOLD}$1${NC}"
    echo -e "${CYAN}──────────────────────────────────────────────────────────────${NC}"
}

print_menu_item() {
    local index=$1
    local text=$2
    local selected=$3
    
    if [ $selected -eq 1 ]; then
        echo -e " ${GREEN}❯${NC} ${BOLD}${text}${NC}"
    else
        echo -e "   ${text}"
    fi
}

# SSH Welcome Message Setup
setup_ssh_welcome() {
    local welcome_script="$HOME/.lavashell/ssh-welcome.sh"
    local bashrc="$HOME/.bashrc"
    local profile="$HOME/.profile"
    
    print_status "Setting up SSH welcome message..."
    
    mkdir -p "$HOME/.lavashell"
    
    # Create the welcome script
    cat > "$welcome_script" << 'EOF'
#!/bin/bash
# LavaShell MoDroid SSH Welcome - Auto-generated
# This shows when you connect via SSH (Termius, Termux, etc.)

if [ -n "$SSH_CONNECTION" ] && [ -z "$LAVASHELL_WELCOME_SHOWN" ]; then
    # Colors for welcome message
    BLUE='\033[0;34m'
    GREEN='\033[0;32m'
    WHITE='\033[1;37m'
    YELLOW='\033[1;33m'
    CYAN='\033[0;36m'
    PURPLE='\033[0;35m'
    RED='\033[0;31m'
    ORANGE='\033[0;33m'
    NC='\033[0m'
    
    # Function to show countdown
    countdown() {
        local seconds=$1
        while [ $seconds -gt 0 ]; do
            printf "\r${CYAN}Starting shell in %2d seconds...${NC}" $seconds
            sleep 1
            : $((seconds--))
        done
        printf "\r\033[K"
    }
    
    # Clear screen and show welcome
    clear
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║              Welcome to LavaShell MoDroid!                 ║"
    echo "║              Moein Nikchehre - V1 - Client                 ║"
    echo "║              Based on U3jit & ShupXQL Engine               ║"
    echo "║                   Website: lsi.ct.ws                       ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo
    
    # Loading sequence with different colors and timings
    echo -e "${YELLOW}⏳ Loading u3LIB${NC}" && sleep 0.5
    echo -e "${GREEN}  ✓ lsjit Core libraries initialized${NC}"
    
    echo -e "${YELLOW}⏳ Loading u3MOS${NC}" && sleep 1
    echo -e "${GREEN}  ✓ MoShell .bash/loaders complete${NC}"
    
    echo -e "${CYAN}⏳ Patching MoShell Element Manager for Terminal Access${NC}" && sleep 1
    echo -e "${GREEN}  ✓ MOS-Conto +10 lsPKGs applied${NC}"
    
    echo -e "${PURPLE}⏳ Hardloading Modules for Termux, if exist${NC}" && sleep 1
    echo -e "${GREEN}  ✓ TERM modules checked${NC}"
    
    echo -e "${RED}⏳ Reserving MoD USU Parameters for Cyg & mintty${NC}" && sleep 3
    echo -e "${GREEN}  ✓ USU/LOD parameters reserved${NC}"
    
    echo -e "${GREEN}⏳ Finalizing Terminal *MoDlib-xway${NC}" && sleep 0.5
    echo -e "${GREEN}  ✓ LavaXWayland compatibility loaded${NC}"
    
    echo -e "${GREEN}⏳ Finalizing Terminal *MoDlib-ossh${NC}" && sleep 0.5
    echo -e "${GREEN}  ✓ OpenSSH extensions/self-lib enabled${NC}"
    
    echo -e "${GREEN}⏳ Finalizing Terminal *MoDlib-u3${NC}" && sleep 0.5
    echo -e "${GREEN}  ✓ U3 libraries + .lsclass integrated${NC}"
    
    echo -e "${BLUE}⏳ Finalizing Terminal *S/X+Y+Z/QL PROG;${NC}" && sleep 0.5
    echo -e "${GREEN}  ✓ u3hkey & MoDusuals activated${NC}"
    
    echo -e "${WHITE}✨ Done! Welcome $(whoami)${NC}" && sleep 1.5
    echo
    
    # Countdown before clearing
    countdown 3
    
    # Clear screen completely and set flag
    clear
    export LAVASHELL_WELCOME_SHOWN=1
fi
EOF

    chmod +x "$welcome_script"
    
    # Add to bashrc if not already there
    if ! grep -q "LAVASHELL_WELCOME" "$bashrc" 2>/dev/null; then
        echo >> "$bashrc"
        echo "# LavaShell MoDroid Welcome Message" >> "$bashrc"
        echo "source \"$welcome_script\"" >> "$bashrc"
        print_success "SSH welcome message configured in .bashrc"
    else
        print_status "SSH welcome already configured in .bashrc"
    fi
    
    # Also add to .profile for other shells
    if [ -f "$profile" ] && ! grep -q "LAVASHELL_WELCOME" "$profile" 2>/dev/null; then
        echo >> "$profile"
        echo "# LavaShell MoDroid Welcome Message" >> "$profile"
        echo "source \"$welcome_script\"" >> "$profile"
        print_success "SSH welcome message configured in .profile"
    fi
}

# Check if port is available
check_port_available() {
    local port=$1
    if netstat -an 2>/dev/null | grep -q ":$port.*LISTEN"; then
        return 1  # Port is in use
    else
        return 0  # Port is available
    fi
}

# Find what's using the port
find_port_usage() {
    local port=$1
    print_status "Checking what's using port $port..."
    
    if command -v netstat >/dev/null 2>&1; then
        netstat -ano | grep ":$port.*LISTEN" | head -1
    fi
}

# Kill process using port
kill_port_process() {
    local port=$1
    print_status "Attempting to free port $port..."
    
    if command -v netstat >/dev/null 2>&1; then
        local pid=$(netstat -ano | grep ":$port.*LISTEN" | awk '{print $5}' | head -1)
        if [ -n "$pid" ] && [ "$pid" != "0" ]; then
            print_warning "Killing process $pid using port $port"
            kill -9 $pid 2>/dev/null || taskkill /PID $pid /F 2>/dev/null
            sleep 2
        fi
    fi
}

# Network functions
get_network_info() {
    print_status "Detecting network configuration..."
    
    # Get local IP
    if command -v ipconfig >/dev/null 2>&1; then
        LOCAL_IP=$(ipconfig 2>/dev/null | grep -i "IPv4" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | grep -v '127.0.0.1' | head -1)
    fi
    
    [ -z "$LOCAL_IP" ] && LOCAL_IP="127.0.0.1"
    
    # Get public IP
    print_status "Getting public IP address..."
    PUBLIC_IP=$(curl -s --connect-timeout 5 https://api.ipify.org 2>/dev/null || echo "Unknown")
    
    print_success "Network detection complete"
}

# SSH Service Management
check_ssh_service() {
    if [ -f /tmp/lavashell_sshd.pid ]; then
        SSH_PID=$(cat /tmp/lavashell_sshd.pid 2>/dev/null)
        if [ -n "$SSH_PID" ] && kill -0 $SSH_PID 2>/dev/null; then
            SSH_STATUS="RUNNING"
            return 0
        else
            rm -f /tmp/lavashell_sshd.pid
        fi
    fi
    
    if pgrep -x sshd >/dev/null 2>&1; then
        SSH_STATUS="RUNNING"
    else
        SSH_STATUS="STOPPED"
    fi
}

# Create SSH configuration with dynamic port
create_ssh_config() {
    local config_file="$HOME/.ssh/sshd_config"
    local port=${1:-$CURRENT_PORT}
    
    print_status "Creating SSH configuration for port $port..."
    
    mkdir -p "$HOME/.ssh"
    
    # Backup existing config
    if [ -f "$config_file" ]; then
        cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Create config with specified port
    cat > "$config_file" << EOF
# LavaShell MoDroid - SSH Configuration
Port $port
Protocol 2
HostKey $HOME/.ssh/ssh_host_rsa_key
HostKey $HOME/.ssh/ssh_host_ecdsa_key  
HostKey $HOME/.ssh/ssh_host_ed25519_key
PermitRootLogin no
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
X11Forwarding yes
PrintMotd yes
AcceptEnv LANG LC_*
Subsystem sftp /usr/sbin/sftp-server
AllowUsers $(whoami)
ListenAddress 0.0.0.0
UseDNS no
EOF

    chmod 600 "$config_file"
    print_success "SSH configuration created for port $port"
}

# Generate SSH host keys ONLY if they don't exist (FIXED)
generate_ssh_keys() {
    print_status "Checking SSH host keys..."
    
    mkdir -p "$HOME/.ssh"
    
    local keys_missing=0
    
    # Check which keys are missing
    for key_type in rsa ecdsa ed25519; do
        key_file="$HOME/.ssh/ssh_host_${key_type}_key"
        if [ ! -f "$key_file" ]; then
            keys_missing=1
            print_status "Generating $key_type host key..."
            ssh-keygen -t "$key_type" -f "$key_file" -N "" -q
            chmod 600 "$key_file"
            chmod 644 "${key_file}.pub"
            print_success "Generated $key_type host key"
        else
            print_status "$key_type host key already exists"
        fi
    done
    
    if [ $keys_missing -eq 0 ]; then
        print_success "All SSH host keys are present and ready"
    else
        print_success "Missing SSH host keys generated"
    fi
}

# Install and configure SSH server
install_ssh_server() {
    print_header "Installing OpenSSH Server"
    
    if ! command -v sshd >/dev/null 2>&1; then
        print_error "OpenSSH server not found!"
        echo
        echo -e "${YELLOW}To install OpenSSH in Cygwin:${NC}"
        echo -e "1. Run Cygwin setup.exe"
        echo -e "2. Search for 'openssh' package" 
        echo -e "3. Select openssh for installation"
        echo
        echo -e "${BOLD}After installation, run this script again.${NC}"
        echo
        read -n1 -r -p "Press any key to return to menu..."
        return 1
    fi
    
    print_success "OpenSSH Server is installed"
    
    # Configure SSH with current port
    create_ssh_config $CURRENT_PORT
    generate_ssh_keys
    
    # Setup SSH welcome message
    setup_ssh_welcome
    
    # Configure Windows Firewall for current port
    print_status "Configuring Windows Firewall for port $CURRENT_PORT..."
    netsh advfirewall firewall delete rule name="LavaShell SSH" 2>/dev/null || true
    netsh advfirewall firewall add rule name="LavaShell SSH" dir=in action=allow protocol=TCP localport=$CURRENT_PORT 2>/dev/null || print_warning "Could not configure firewall"
    
    print_success "SSH server setup completed"
    return 0
}

# Start SSH service with port management
start_ssh_service() {
    print_header "Starting SSH Service"
    
    # Stop any existing service first
    stop_ssh_service
    sleep 2
    
    # Check if default port is available
    if ! check_port_available $CURRENT_PORT; then
        print_warning "Port $CURRENT_PORT is already in use!"
        find_port_usage $CURRENT_PORT
        
        echo
        echo -e "${BOLD}Options:${NC}"
        echo -e "1. Try to free port $CURRENT_PORT"
        echo -e "2. Use alternative port $ALTERNATE_PORT"
        echo -e "3. Cancel and return to menu"
        echo
        
        read -p "Choose option (1/2/3): " choice
        case $choice in
            1)
                kill_port_process $CURRENT_PORT
                if check_port_available $CURRENT_PORT; then
                    print_success "Port $CURRENT_PORT is now free"
                else
                    print_error "Could not free port $CURRENT_PORT, using alternative port"
                    CURRENT_PORT=$ALTERNATE_PORT
                    create_ssh_config $CURRENT_PORT
                fi
                ;;
            2)
                CURRENT_PORT=$ALTERNATE_PORT
                create_ssh_config $CURRENT_PORT
                print_success "Switched to port $CURRENT_PORT"
                ;;
            3)
                return 1
                ;;
            *)
                print_error "Invalid choice, using alternative port"
                CURRENT_PORT=$ALTERNATE_PORT
                create_ssh_config $CURRENT_PORT
                ;;
        esac
    fi
    
    # Ensure keys and config are ready (DON'T regenerate keys every time)
    generate_ssh_keys  # This only generates missing keys now
    create_ssh_config $CURRENT_PORT
    
    # Test configuration
    print_status "Testing SSH configuration for port $CURRENT_PORT..."
    if /usr/sbin/sshd -t -f "$HOME/.ssh/sshd_config"; then
        print_success "SSH configuration test passed"
    else
        print_error "SSH configuration test failed"
        return 1
    fi
    
    # Start SSH daemon
    print_status "Starting SSH daemon on port $CURRENT_PORT..."
    /usr/sbin/sshd -D -f "$HOME/.ssh/sshd_config" &
    SSH_PID=$!
    
    # Wait for startup
    sleep 3
    
    if kill -0 $SSH_PID 2>/dev/null; then
        echo $SSH_PID > /tmp/lavashell_sshd.pid
        SSH_STATUS="RUNNING"
        print_success "SSH daemon started successfully (PID: $SSH_PID)"
        
        # Verify it's listening
        sleep 2
        if netstat -an 2>/dev/null | grep -q ":$CURRENT_PORT.*LISTEN"; then
            print_success "SSH server is listening on port $CURRENT_PORT"
        else
            print_warning "SSH process running but port $CURRENT_PORT not listening"
        fi
    else
        print_error "SSH daemon failed to start on port $CURRENT_PORT"
        return 1
    fi
    
    return 0
}

# Stop SSH service
stop_ssh_service() {
    print_header "Stopping SSH Service"
    
    # Stop using PID file
    if [ -f /tmp/lavashell_sshd.pid ]; then
        local pid=$(cat /tmp/lavashell_sshd.pid 2>/dev/null)
        if [ -n "$pid" ] && kill -0 $pid 2>/dev/null; then
            kill $pid 2>/dev/null && print_status "Stopped SSH daemon (PID: $pid)"
        fi
        rm -f /tmp/lavashell_sshd.pid
    fi
    
    # Kill any remaining sshd processes
    pkill -x sshd 2>/dev/null && print_status "Killed remaining SSH processes"
    sleep 2
    
    check_ssh_service
    
    if [ "$SSH_STATUS" = "STOPPED" ]; then
        print_success "SSH service stopped successfully"
    else
        print_warning "SSH service may still be running"
    fi
}

# Setup Router Mode
setup_router_mode() {
    print_header "Router/Modem Mode Setup"
    
    echo -e "${BOLD}${GREEN}Router/Modem Mode Selected${NC}"
    echo
    echo -e "This mode works when you have access to router settings."
    echo
    
    # Install and start SSH
    install_ssh_server
    if [ $? -eq 0 ]; then
        start_ssh_service
    fi
    
    if [ "$SSH_STATUS" = "RUNNING" ]; then
        show_router_instructions
    fi
}

# Show router instructions
show_router_instructions() {
    print_header "Router Mode Connection Instructions"
    
    echo -e "${BOLD}${GREEN}Step 1: Port Forwarding in Router${NC}"
    echo
    echo -e "Access your router admin (usually 192.168.1.1 or 192.168.0.1)"
    echo -e "Set up port forwarding:"
    echo -e "  • External Port: $CURRENT_PORT"
    echo -e "  • Internal Port: $CURRENT_PORT" 
    echo -e "  • Internal IP: ${LOCAL_IP}"
    echo -e "  • Protocol: TCP"
    echo
    
    echo -e "${BOLD}${GREEN}Step 2: Connect From Remote Device${NC}"
    echo
    if [ "$CURRENT_PORT" = "22" ]; then
        echo -e "From another computer/phone, use:"
        echo -e "  ${GREEN}ssh $(whoami)@${PUBLIC_IP}${NC}"
    else
        echo -e "From another computer/phone, use:"
        echo -e "  ${GREEN}ssh -p $CURRENT_PORT $(whoami)@${PUBLIC_IP}${NC}"
        echo -e "${YELLOW}Note: Use -p $CURRENT_PORT because we're not using default port 22${NC}"
    fi
    echo
    echo -e "Use your Windows password when prompted."
    echo
    
    echo -e "${BOLD}${GREEN}Step 3: Fix Host Key Warning (One Time)${NC}"
    echo
    echo -e "If you get 'Host key verification failed' in Termux:"
    echo -e "  ${GREEN}ssh-keygen -R $PUBLIC_IP -p $CURRENT_PORT${NC}"
    echo
    echo -e "Or to disable host key checking (less secure):"
    echo -e "  ${GREEN}ssh -o StrictHostKeyChecking=no -p $CURRENT_PORT $(whoami)@$PUBLIC_IP${NC}"
    echo
    
    echo -e "${BOLD}${YELLOW}Welcome Message:${NC}"
    echo -e "When you connect via SSH, you'll see a colorful welcome message"
    echo -e "that will automatically clear and give you terminal access."
    echo
    
    echo -e "${BOLD}${YELLOW}Troubleshooting:${NC}"
    echo -e "• If connection fails, check:"
    echo -e "  1. Port forwarding is correct for port $CURRENT_PORT"
    echo -e "  2. Windows Firewall allows port $CURRENT_PORT"
    echo -e "  3. Router restarted after changes"
    echo
}

# Test connection
test_connection() {
    print_header "Testing Connection"
    
    if [ "$SSH_STATUS" != "RUNNING" ]; then
        print_error "SSH server is not running"
        return 1
    fi
    
    print_status "Testing local connection..."
    if timeout 10s ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $CURRENT_PORT localhost "echo 'Local test successful'" 2>/dev/null; then
        print_success "Local SSH connection working on port $CURRENT_PORT"
    else
        print_warning "Local connection test failed (normal for first connection)"
    fi
    
    print_status "Checking port $CURRENT_PORT..."
    if netstat -an 2>/dev/null | grep -q ":$CURRENT_PORT.*LISTEN"; then
        print_success "Port $CURRENT_PORT is listening"
    else
        print_error "Port $CURRENT_PORT is not listening"
        return 1
    fi
    
    echo
    echo -e "${BOLD}Connection Summary:${NC}"
    echo -e "Local IP: $LOCAL_IP"
    echo -e "Public IP: $PUBLIC_IP"
    echo -e "SSH Port: $CURRENT_PORT"
    echo -e "SSH Status: $SSH_STATUS"
    echo
    
    echo -e "${GREEN}Use this command from remote:${NC}"
    if [ "$CURRENT_PORT" = "22" ]; then
        echo -e "ssh $(whoami)@$PUBLIC_IP"
    else
        echo -e "ssh -p $CURRENT_PORT $(whoami)@$PUBLIC_IP"
    fi
    
    echo
    echo -e "${YELLOW}When you connect, you'll see the LavaShell welcome message!${NC}"
    echo
}

# Show system info
show_system_info() {
    print_header "System Information"
    
    echo -e "${BOLD}Hostname:${NC} $(hostname 2>/dev/null || echo 'Unknown')"
    echo -e "${BOLD}Username:${NC} $(whoami)"
    echo -e "${BOLD}Local IP:${NC} $LOCAL_IP"
    echo -e "${BOLD}Public IP:${NC} $PUBLIC_IP"
    echo -e "${BOLD}SSH Port:${NC} $CURRENT_PORT"
    
    case "$SSH_STATUS" in
        "RUNNING") echo -e "${BOLD}SSH Status:${NC} ${GREEN}RUNNING${NC}" ;;
        "STOPPED") echo -e "${BOLD}SSH Status:${NC} ${RED}STOPPED${NC}" ;;
        *) echo -e "${BOLD}SSH Status:${NC} ${YELLOW}UNKNOWN${NC}" ;;
    esac
    
    if command -v sshd >/dev/null 2>&1; then
        echo -e "${BOLD}SSH Server:${NC} ${GREEN}Installed${NC}"
    else
        echo -e "${BOLD}SSH Server:${NC} ${RED}Not Found${NC}"
    fi
    
    if netstat -an 2>/dev/null | grep -q ":$CURRENT_PORT.*LISTEN"; then
        echo -e "${BOLD}Port $CURRENT_PORT:${NC} ${GREEN}Listening${NC}"
    else
        echo -e "${BOLD}Port $CURRENT_PORT:${NC} ${RED}Not Listening${NC}"
    fi
    
    # Show host key status
    echo
    echo -e "${BOLD}SSH Host Keys:${NC}"
    for key_type in rsa ecdsa ed25519; do
        key_file="$HOME/.ssh/ssh_host_${key_type}_key"
        if [ -f "$key_file" ]; then
            echo -e "  $key_type: ${GREEN}Exists${NC}"
        else
            echo -e "  $key_type: ${RED}Missing${NC}"
        fi
    done
    
    # Show welcome message status
    echo
    echo -e "${BOLD}Welcome Message:${NC}"
    if [ -f "$HOME/.lavashell/ssh-welcome.sh" ]; then
        echo -e "  Status: ${GREEN}Installed${NC}"
        echo -e "  Location: $HOME/.lavashell/ssh-welcome.sh"
    else
        echo -e "  Status: ${RED}Not Installed${NC}"
    fi
}

# Regenerate SSH host keys (only when needed)
regenerate_ssh_keys() {
    print_header "Regenerating SSH Host Keys"
    
    echo -e "${YELLOW}This will regenerate ALL SSH host keys.${NC}"
    echo -e "${RED}All remote clients will get 'Host key changed' warning!${NC}"
    echo
    read -p "Are you sure? (y/N): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        print_status "Removing old host keys..."
        rm -f "$HOME/.ssh/ssh_host_"* 2>/dev/null || true
        
        print_status "Generating new host keys..."
        for key_type in rsa ecdsa ed25519; do
            key_file="$HOME/.ssh/ssh_host_${key_type}_key"
            ssh-keygen -t "$key_type" -f "$key_file" -N "" -q
            chmod 600 "$key_file"
            chmod 644 "${key_file}.pub"
            print_success "Generated $key_type host key"
        done
        
        print_success "SSH host keys regenerated"
        echo
        echo -e "${YELLOW}Note: Remote clients need to remove old host key:${NC}"
        echo -e "ssh-keygen -R $PUBLIC_IP -p $CURRENT_PORT"
    else
        print_status "Key regeneration cancelled"
    fi
}

# Fix SSH issues
fix_ssh_issues() {
    print_header "Fixing SSH Issues"
    
    print_status "Stopping SSH service..."
    stop_ssh_service
    
    print_status "Checking port availability..."
    if ! check_port_available $CURRENT_PORT; then
        print_warning "Port $CURRENT_PORT is in use, switching to $ALTERNATE_PORT"
        CURRENT_PORT=$ALTERNATE_PORT
    fi
    
    print_status "Ensuring SSH keys exist..."
    generate_ssh_keys
    
    print_status "Recreating SSH config for port $CURRENT_PORT..."
    create_ssh_config $CURRENT_PORT
    
    print_status "Setting up welcome message..."
    setup_ssh_welcome
    
    print_status "Starting SSH service..."
    if start_ssh_service; then
        print_success "SSH issues fixed successfully on port $CURRENT_PORT"
    else
        print_error "Failed to fix SSH issues"
    fi
}

# Interactive menu system
show_main_menu() {
    MENU_ITEMS=(
        "Setup Router/Modem Mode"
        "Start SSH Service"
        "Stop SSH Service"
        "Test Connection"
        "Show System Info"
        "Fix SSH Issues"
        "Regenerate SSH Host Keys"
        "Exit"
    )
}

draw_menu() {
    print_banner
    
    # Show quick status
    echo -e "${BOLD}Status:${NC} SSH: $SSH_STATUS | Port: $CURRENT_PORT | Local IP: $LOCAL_IP"
    echo
    
    print_header "Main Menu"
    for i in "${!MENU_ITEMS[@]}"; do
        if [ $i -eq $CURRENT_SELECTION ]; then
            print_menu_item "$i" "${MENU_ITEMS[$i]}" 1
        else
            print_menu_item "$i" "${MENU_ITEMS[$i]}" 0
        fi
    done
    
    echo
    echo -e "${YELLOW}Use ↑↓ arrows to navigate, Enter to select, Q to exit${NC}"
}

handle_keypress() {
    while true; do
        draw_menu
        read -rsn1 key
        case "$key" in
            $'\x1b')  # Escape sequence
                read -rsn2 -t 0.1 key2
                case "$key2" in
                    '[A') # Up arrow
                        CURRENT_SELECTION=$(( (CURRENT_SELECTION - 1 + ${#MENU_ITEMS[@]}) % ${#MENU_ITEMS[@]} ))
                        ;;
                    '[B') # Down arrow  
                        CURRENT_SELECTION=$(( (CURRENT_SELECTION + 1) % ${#MENU_ITEMS[@]} ))
                        ;;
                esac
                ;;
            '') # Enter key
                execute_menu_option
                ;;
            'q'|'Q') # Q key
                echo
                print_status "Thank you for using LavaShell MoDroid!"
                exit 0
                ;;
        esac
    done
}

execute_menu_option() {
    case $CURRENT_SELECTION in
        0) # Router Mode
            setup_router_mode
            ;;
        1) # Start SSH
            start_ssh_service
            ;;
        2) # Stop SSH
            stop_ssh_service
            ;;
        3) # Test Connection
            test_connection
            ;;
        4) # System Info
            show_system_info
            ;;
        5) # Fix Issues
            fix_ssh_issues
            ;;
        6) # Regenerate Keys
            regenerate_ssh_keys
            ;;
        7) # Exit
            echo
            print_status "Thank you for using LavaShell MoDroid!"
            exit 0
            ;;
    esac
    
    echo
    read -n1 -r -p "Press any key to continue..."
}

# Check dependencies
check_dependencies() {
    if ! command -v sshd >/dev/null 2>&1; then
        print_error "OpenSSH not found. Please install via Cygwin setup."
        echo
        echo -e "Run Cygwin setup.exe and install 'openssh' package"
        exit 1
    fi
}

# Main initialization
init_system() {
    print_banner
    print_status "Initializing LavaShell MoDroid..."
    
    detect_environment
    check_dependencies
    get_network_info
    check_ssh_service
    
    # Check initial port availability
    if ! check_port_available $CURRENT_PORT; then
        print_warning "Port $CURRENT_PORT is in use, switching to $ALTERNATE_PORT"
        CURRENT_PORT=$ALTERNATE_PORT
    fi
    
    mkdir -p "$CONFIG_DIR"
    print_success "System ready - Using port $CURRENT_PORT"
    sleep 1
}

# Signal handlers
trap 'echo; print_status "Interrupted. Continuing..."; show_main_menu' SIGINT

# Main execution
main() {
    init_system
    show_main_menu
    handle_keypress
}

# Run main function
main "$@"
