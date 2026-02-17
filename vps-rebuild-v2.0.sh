#!/bin/bash

#####################################################################
# VPS Rebuild Script v2.0
# Features: OS Selection, Password, Basic Packages, Timezone
# Author: Auto-generated
# Date: $(date +%Y-%m-%d)
#####################################################################

set -e

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_header() {
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}=========================================${NC}"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then 
        print_error "Script ini harus dijalankan sebagai root"
        exit 1
    fi
}

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        OS_VERSION=$VERSION_ID
        OS_NAME=$PRETTY_NAME
        
        if [ "$OS" = "debian" ] || [ "$OS" = "ubuntu" ]; then
            PKG_MANAGER="apt"
            PKG_UPDATE="apt-get update -y"
            PKG_UPGRADE="apt-get upgrade -y"
            PKG_INSTALL="apt-get install -y"
        elif [ "$OS" = "centos" ] || [ "$OS" = "rhel" ] || [ "$OS" = "rocky" ] || [ "$OS" = "almalinux" ]; then
            PKG_MANAGER="yum"
            PKG_UPDATE="yum update -y"
            PKG_UPGRADE="yum upgrade -y"
            PKG_INSTALL="yum install -y"
        fi
    fi
}

generate_password() {
    tr -dc 'A-Za-z0-9!@#$%^&*()_+=' < /dev/urandom | head -c ${1:-16}
}

validate_password() {
    local password=$1
    [ ${#password} -ge 8 ] && \
    echo "$password" | grep -q '[A-Z]' && \
    echo "$password" | grep -q '[a-z]' && \
    echo "$password" | grep -q '[0-9]'
}

set_password() {
    print_header "SET PASSWORD ROOT"
    echo ""
    print_warning "Password harus: minimal 8 karakter, 1 huruf besar, 1 huruf kecil, 1 angka"
    echo ""
    echo "1. Generate password otomatis"
    echo "2. Input password manual"
    read -p "Pilihan (1/2): " pass_choice
    
    case $pass_choice in
        1)
            NEW_PASSWORD=$(generate_password 16)
            print_success "Password: ${MAGENTA}${NEW_PASSWORD}${NC}"
            echo ""
            print_warning "⚠️  SIMPAN PASSWORD INI!"
            read -p "Tekan ENTER untuk lanjut..." dummy
            ;;
        2)
            while true; do
                read -sp "Password baru: " NEW_PASSWORD
                echo ""
                read -sp "Konfirmasi password: " pass_confirm
                echo ""
                
                if [ "$NEW_PASSWORD" != "$pass_confirm" ]; then
                    print_error "Password tidak sama!"
                    continue
                fi
                
                if ! validate_password "$NEW_PASSWORD"; then
                    print_error "Password tidak memenuhi kriteria!"
                    continue
                fi
                
                print_success "Password valid!"
                break
            done
            ;;
    esac
    
    echo "root:$NEW_PASSWORD" | chpasswd
    
    # Simpan password
    PASSWORD_FILE="/root/.vps_password_$(date +%Y%m%d_%H%M%S).txt"
    cat > "$PASSWORD_FILE" <<EOF
VPS Password
Date: $(date)
IP: $(hostname -I | awk '{print $1}')
Username: root
Password: $NEW_PASSWORD
EOF
    chmod 600 "$PASSWORD_FILE"
    
    print_success "Password root berhasil diubah!"
    print_info "Password disimpan: $PASSWORD_FILE"
    echo ""
}

show_os_menu() {
    clear
    print_header "VPS REBUILD SCRIPT v2.0"
    echo ""
    print_header "PILIH OPERATING SYSTEM"
    echo ""
    
    echo -e "${GREEN}=== DEBIAN ===${NC}"
    echo "1.  Debian 10 (Buster)"
    echo "2.  Debian 11 (Bullseye)"
    echo "3.  Debian 12 (Bookworm)"
    echo "4.  Debian 13 (Trixie)"
    echo ""
    
    echo -e "${CYAN}=== UBUNTU LTS ===${NC}"
    echo "5.  Ubuntu 20.04 LTS"
    echo "6.  Ubuntu 22.04 LTS"
    echo "7.  Ubuntu 24.04 LTS"
    echo ""
    
    echo -e "${CYAN}=== UBUNTU NON-LTS ===${NC}"
    echo "8.  Ubuntu 21.04"
    echo "9.  Ubuntu 21.10"
    echo "10. Ubuntu 23.04"
    echo "11. Ubuntu 23.10"
    echo "12. Ubuntu 24.10"
    echo "13. Ubuntu 25.04"
    echo ""
    
    echo -e "${MAGENTA}=== RHEL BASED ===${NC}"
    echo "14. CentOS 7"
    echo "15. CentOS Stream 8"
    echo "16. CentOS Stream 9"
    echo "17. Rocky Linux 8"
    echo "18. Rocky Linux 9"
    echo "19. AlmaLinux 8"
    echo "20. AlmaLinux 9"
    echo ""
    echo "0.  Keluar"
    echo ""
}

get_os_info() {
    case $1 in
        1) OS_NAME="Debian 10"; OS_CODENAME="buster"; OS_VERSION="10"; OS_TYPE="debian" ;;
        2) OS_NAME="Debian 11"; OS_CODENAME="bullseye"; OS_VERSION="11"; OS_TYPE="debian" ;;
        3) OS_NAME="Debian 12"; OS_CODENAME="bookworm"; OS_VERSION="12"; OS_TYPE="debian" ;;
        4) OS_NAME="Debian 13"; OS_CODENAME="trixie"; OS_VERSION="13"; OS_TYPE="debian" ;;
        5) OS_NAME="Ubuntu 20.04 LTS"; OS_CODENAME="focal"; OS_VERSION="20.04"; OS_TYPE="ubuntu" ;;
        6) OS_NAME="Ubuntu 22.04 LTS"; OS_CODENAME="jammy"; OS_VERSION="22.04"; OS_TYPE="ubuntu" ;;
        7) OS_NAME="Ubuntu 24.04 LTS"; OS_CODENAME="noble"; OS_VERSION="24.04"; OS_TYPE="ubuntu" ;;
        8) OS_NAME="Ubuntu 21.04"; OS_CODENAME="hirsute"; OS_VERSION="21.04"; OS_TYPE="ubuntu" ;;
        9) OS_NAME="Ubuntu 21.10"; OS_CODENAME="impish"; OS_VERSION="21.10"; OS_TYPE="ubuntu" ;;
        10) OS_NAME="Ubuntu 23.04"; OS_CODENAME="lunar"; OS_VERSION="23.04"; OS_TYPE="ubuntu" ;;
        11) OS_NAME="Ubuntu 23.10"; OS_CODENAME="mantic"; OS_VERSION="23.10"; OS_TYPE="ubuntu" ;;
        12) OS_NAME="Ubuntu 24.10"; OS_CODENAME="oracular"; OS_VERSION="24.10"; OS_TYPE="ubuntu" ;;
        13) OS_NAME="Ubuntu 25.04"; OS_CODENAME="plucky"; OS_VERSION="25.04"; OS_TYPE="ubuntu" ;;
        14) OS_NAME="CentOS 7"; OS_CODENAME="centos7"; OS_VERSION="7"; OS_TYPE="centos" ;;
        15) OS_NAME="CentOS Stream 8"; OS_CODENAME="centos8"; OS_VERSION="8"; OS_TYPE="centos" ;;
        16) OS_NAME="CentOS Stream 9"; OS_CODENAME="centos9"; OS_VERSION="9"; OS_TYPE="centos" ;;
        17) OS_NAME="Rocky Linux 8"; OS_CODENAME="rocky8"; OS_VERSION="8"; OS_TYPE="rocky" ;;
        18) OS_NAME="Rocky Linux 9"; OS_CODENAME="rocky9"; OS_VERSION="9"; OS_TYPE="rocky" ;;
        19) OS_NAME="AlmaLinux 8"; OS_CODENAME="alma8"; OS_VERSION="8"; OS_TYPE="alma" ;;
        20) OS_NAME="AlmaLinux 9"; OS_CODENAME="alma9"; OS_VERSION="9"; OS_TYPE="alma" ;;
        *) return 1 ;;
    esac
    return 0
}

update_system() {
    print_header "UPDATE SISTEM"
    print_info "Melakukan update..."
    $PKG_UPDATE
    $PKG_UPGRADE
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        apt-get dist-upgrade -y
        apt-get autoremove -y
        apt-get autoclean -y
    fi
    
    print_success "Update selesai!"
}

install_packages() {
    print_header "INSTALL PAKET DASAR"
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        $PKG_INSTALL curl wget git vim nano htop net-tools \
            unzip zip tar build-essential
    else
        $PKG_INSTALL curl wget git vim nano htop net-tools \
            unzip zip tar epel-release
    fi
    
    print_success "Paket dasar terinstall!"
}

setup_timezone() {
    print_header "SETUP TIMEZONE"
    echo ""
    echo "1. Asia/Jakarta (WIB - UTC+7)"
    echo "2. Asia/Makassar (WITA - UTC+8)"
    echo "3. Asia/Jayapura (WIT - UTC+9)"
    echo "4. Asia/Kuala_Lumpur (MYT - UTC+8)"
    echo "5. Asia/Singapore (SGT - UTC+8)"
    echo "6. UTC"
    echo ""
    read -p "Pilihan (1-6): " tz_choice
    
    case $tz_choice in
        1) TZ="Asia/Jakarta" ;;
        2) TZ="Asia/Makassar" ;;
        3) TZ="Asia/Jayapura" ;;
        4) TZ="Asia/Kuala_Lumpur" ;;
        5) TZ="Asia/Singapore" ;;
        6) TZ="UTC" ;;
        *) TZ="Asia/Jakarta" ;;
    esac
    
    timedatectl set-timezone "$TZ"
    print_success "Timezone: $TZ"
}

display_info() {
    print_header "INFORMASI SISTEM"
    echo ""
    echo "Hostname    : $(hostname)"
    echo "IP Address  : $(hostname -I | awk '{print $1}')"
    echo "OS          : $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
    echo "Timezone    : $(timedatectl | grep 'Time zone' | awk '{print $3}')"
    echo ""
    echo "Password root tersimpan di: /root/.vps_password_*.txt"
    echo ""
}

main() {
    check_root
    detect_os
    
    show_os_menu
    read -p "Pilih OS (0-20): " os_choice
    
    if [ "$os_choice" = "0" ]; then
        print_info "Keluar"
        exit 0
    fi
    
    if ! get_os_info "$os_choice"; then
        print_error "Pilihan tidak valid!"
        exit 1
    fi
    
    clear
    print_header "KONFIRMASI"
    echo ""
    echo -e "OS Target: ${GREEN}$OS_NAME${NC}"
    echo ""
    read -p "Lanjutkan? (y/n): " confirm
    
    if [ "$confirm" != "y" ]; then
        exit 0
    fi
    
    print_warning "PERHATIAN: Rebuild akan menghapus semua data!"
    print_info "Script ini akan setup: Password, Packages, Timezone"
    echo ""
    read -p "Ketik 'YES' untuk konfirmasi: " final_confirm
    
    if [ "$final_confirm" != "YES" ]; then
        print_error "Dibatalkan!"
        exit 0
    fi
    
    clear
    print_header "MEMULAI REBUILD VPS v2.0"
    echo ""
    
    set_password
    update_system
    install_packages
    setup_timezone
    
    echo ""
    print_success "========================================="
    print_success "REBUILD VPS v2.0 SELESAI!"
    print_success "========================================="
    echo ""
    
    display_info
    
    print_warning "PENTING: Simpan password Anda!"
    echo ""
    read -p "Reboot sekarang? (y/n): " reboot_choice
    if [ "$reboot_choice" = "y" ]; then
        print_info "Rebooting..."
        sleep 3
        reboot
    fi
}

trap 'print_error "Error pada line $LINENO"' ERR
main
