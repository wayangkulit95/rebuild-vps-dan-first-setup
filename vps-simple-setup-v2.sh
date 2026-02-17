#!/bin/bash

#####################################################################
# VPS Simple Setup Script
# Features: Basic Packages, Timezone, Swap/Zram Memory, Fail2Ban
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
        else
            print_error "OS tidak didukung: $OS"
            exit 1
        fi
    else
        print_error "Tidak dapat mendeteksi OS"
        exit 1
    fi
    
    print_success "OS Terdeteksi: $OS_NAME"
}

install_basic_packages() {
    print_header "INSTALL PAKET DASAR"
    echo ""
    
    print_info "Mengupdate repository..."
    $PKG_UPDATE > /dev/null 2>&1
    
    print_info "Menginstall paket dasar..."
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        $PKG_INSTALL \
            curl wget git vim nano \
            htop net-tools unzip zip tar \
            build-essential software-properties-common \
            apt-transport-https ca-certificates \
            screen tmux ncdu tree rsync
    else
        $PKG_INSTALL \
            curl wget git vim nano \
            htop net-tools unzip zip tar \
            epel-release gcc make \
            screen tmux ncdu tree rsync
    fi
    
    echo ""
    print_success "Paket dasar berhasil diinstall!"
    echo ""
    print_info "Paket yang diinstall:"
    echo "  ✓ curl, wget - Download tools"
    echo "  ✓ git - Version control"
    echo "  ✓ vim, nano - Text editors"
    echo "  ✓ htop - Process monitor"
    echo "  ✓ net-tools - Network utilities"
    echo "  ✓ screen, tmux - Terminal multiplexer"
    echo "  ✓ ncdu, tree - Disk utilities"
    echo "  ✓ unzip, zip, tar - Archive tools"
    echo ""
}

setup_timezone() {
    print_header "SETUP TIMEZONE"
    echo ""
    
    current_tz=$(timedatectl | grep "Time zone" | awk '{print $3}')
    print_info "Timezone saat ini: $current_tz"
    echo ""
    
    echo "Pilih timezone:"
    echo "1. Asia/Jakarta (WIB - UTC+7)"
    echo "2. Asia/Makassar (WITA - UTC+8)"
    echo "3. Asia/Jayapura (WIT - UTC+9)"
    echo "4. Asia/Kuala_Lumpur (MYT - UTC+8)"
    echo "5. Asia/Singapore (SGT - UTC+8)"
    echo "6. Asia/Bangkok (ICT - UTC+7)"
    echo "7. Asia/Manila (PHT - UTC+8)"
    echo "8. Asia/Ho_Chi_Minh (ICT - UTC+7)"
    echo "9. UTC"
    echo "10. Input manual"
    echo "0. Skip"
    echo ""
    
    read -p "Pilihan (0-10): " tz_choice
    
    case $tz_choice in
        1) TZ="Asia/Jakarta" ;;
        2) TZ="Asia/Makassar" ;;
        3) TZ="Asia/Jayapura" ;;
        4) TZ="Asia/Kuala_Lumpur" ;;
        5) TZ="Asia/Singapore" ;;
        6) TZ="Asia/Bangkok" ;;
        7) TZ="Asia/Manila" ;;
        8) TZ="Asia/Ho_Chi_Minh" ;;
        9) TZ="UTC" ;;
        10)
            read -p "Masukkan timezone (contoh: Asia/Jakarta): " TZ
            ;;
        0)
            print_info "Skip setup timezone"
            return
            ;;
        *)
            print_warning "Pilihan tidak valid, skip..."
            return
            ;;
    esac
    
    print_info "Mengatur timezone ke: $TZ"
    timedatectl set-timezone "$TZ"
    
    echo ""
    print_success "Timezone berhasil diatur!"
    echo "Waktu sekarang: $(date)"
    echo ""
}

setup_memory() {
    print_header "SETUP MEMORY (SWAP/ZRAM)"
    echo ""
    
    print_info "Pilih jenis memory:"
    echo ""
    echo "1. SWAP - Menggunakan disk sebagai memory tambahan"
    echo "   ├─ Cocok untuk: Server stabil, RAM kecil"
    echo "   ├─ Kecepatan: Lambat (tergantung disk)"
    echo "   └─ I/O: Tinggi (bisa memperlambat disk)"
    echo ""
    echo "2. ZRAM - Menggunakan RAM terkompresi (storage jadi RAM)"
    echo "   ├─ Cocok untuk: Performance tinggi, RAM terbatas"
    echo "   ├─ Kecepatan: Sangat cepat (pakai RAM)"
    echo "   └─ I/O: Rendah (tidak pakai disk)"
    echo ""
    echo "3. SWAP + ZRAM - Kombinasi keduanya"
    echo "   ├─ Cocok untuk: Balanced performance"
    echo "   ├─ ZRAM untuk speed, SWAP untuk backup"
    echo "   └─ Maksimal efisiensi memory"
    echo ""
    echo "0. Skip"
    echo ""
    
    read -p "Pilihan (0-3): " memory_choice
    
    case $memory_choice in
        1)
            setup_swap
            ;;
        2)
            setup_zram
            ;;
        3)
            setup_swap
            setup_zram
            ;;
        0)
            print_info "Skip setup memory"
            ;;
        *)
            print_warning "Pilihan tidak valid, skip..."
            ;;
    esac
}

setup_swap() {
    print_header "SETUP SWAP (DISK)"
    echo ""
    
    # Cek swap yang sudah ada
    if [ $(swapon --show | wc -l) -gt 0 ]; then
        print_warning "Swap sudah ada:"
        swapon --show
        echo ""
        read -p "Hapus dan buat ulang? (y/n): " recreate_swap
        
        if [ "$recreate_swap" = "y" ]; then
            print_info "Menonaktifkan swap lama..."
            swapoff -a
            
            # Hapus dari fstab
            sed -i '/swapfile/d' /etc/fstab
            
            # Hapus file swap lama
            if [ -f /swapfile ]; then
                rm -f /swapfile
                print_success "Swap lama dihapus"
            fi
        else
            print_info "Skip setup swap"
            return
        fi
    fi
    
    echo ""
    echo "Pilih ukuran swap:"
    echo "1. 1 GB"
    echo "2. 2 GB (Recommended untuk RAM < 2GB)"
    echo "3. 3 GB"
    echo "4. 4 GB (Recommended untuk RAM 2-4GB)"
    echo "5. 8 GB (Recommended untuk RAM > 4GB)"
    echo "0. Skip"
    echo ""
    
    read -p "Pilihan (0-5): " swap_choice
    
    case $swap_choice in
        1) swap_size=1 ;;
        2) swap_size=2 ;;
        3) swap_size=3 ;;
        4) swap_size=4 ;;
        5) swap_size=8 ;;
        0)
            print_info "Skip setup swap"
            return
            ;;
        *)
            print_warning "Pilihan tidak valid, menggunakan 2GB"
            swap_size=2
            ;;
    esac
    
    print_info "Membuat swap file ${swap_size}GB..."
    echo ""
    
    # Buat swap file
    print_info "Mengalokasikan ruang..."
    if command -v fallocate &> /dev/null; then
        fallocate -l ${swap_size}G /swapfile
    else
        dd if=/dev/zero of=/swapfile bs=1M count=$((swap_size * 1024)) status=progress
    fi
    
    # Set permission
    print_info "Mengatur permission..."
    chmod 600 /swapfile
    
    # Setup swap
    print_info "Memformat swap..."
    mkswap /swapfile
    
    print_info "Mengaktifkan swap..."
    swapon /swapfile
    
    # Make permanent
    if ! grep -q '/swapfile' /etc/fstab; then
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
        print_info "Swap ditambahkan ke /etc/fstab"
    fi
    
    # Optimize swap settings
    print_info "Mengoptimasi swap settings..."
    sysctl vm.swappiness=10
    sysctl vm.vfs_cache_pressure=50
    
    # Make permanent
    if ! grep -q 'vm.swappiness' /etc/sysctl.conf; then
        cat >> /etc/sysctl.conf <<EOF

# Swap optimization
vm.swappiness=10
vm.vfs_cache_pressure=50
EOF
    fi
    
    echo ""
    print_success "Swap ${swap_size}GB berhasil dibuat dan diaktifkan!"
    echo ""
    echo "Status memory:"
    free -h | grep -E "Mem|Swap"
    echo ""
}

setup_zram() {
    print_header "SETUP ZRAM (RAM TERKOMPRESI)"
    echo ""
    
    print_info "ZRAM menggunakan storage sebagai RAM dengan kompresi"
    print_info "Ini membuat RAM lebih efisien tanpa menggunakan disk"
    echo ""
    
    # Cek apakah zram sudah ada
    if [ -d /sys/class/block/zram0 ]; then
        print_warning "ZRAM sudah aktif:"
        zramctl
        echo ""
        read -p "Setup ulang ZRAM? (y/n): " recreate_zram
        
        if [ "$recreate_zram" != "y" ]; then
            print_info "Skip setup ZRAM"
            return
        fi
        
        # Disable zram lama
        print_info "Menonaktifkan ZRAM lama..."
        swapoff /dev/zram0 2>/dev/null || true
        rmmod zram 2>/dev/null || true
    fi
    
    echo ""
    echo "Pilih ukuran ZRAM (storage yang jadi RAM):"
    echo "1. 1 GB"
    echo "2. 2 GB (Recommended untuk RAM 1-2GB)"
    echo "3. 3 GB"
    echo "4. 4 GB (Recommended untuk RAM 2-4GB)"
    echo "5. 8 GB (Recommended untuk RAM > 4GB)"
    echo "0. Skip"
    echo ""
    
    read -p "Pilihan (0-5): " zram_choice
    
    case $zram_choice in
        1) zram_size=1 ;;
        2) zram_size=2 ;;
        3) zram_size=3 ;;
        4) zram_size=4 ;;
        5) zram_size=8 ;;
        0)
            print_info "Skip setup ZRAM"
            return
            ;;
        *)
            print_warning "Pilihan tidak valid, menggunakan 2GB"
            zram_size=2
            ;;
    esac
    
    print_info "Menginstall ZRAM tools..."
    
    # Install zram-tools atau zram-config
    if [ "$PKG_MANAGER" = "apt" ]; then
        $PKG_INSTALL zram-config 2>/dev/null || $PKG_INSTALL zram-tools || true
    else
        # Untuk CentOS/RHEL, buat manual
        print_info "Setup ZRAM manual untuk $OS..."
    fi
    
    # Load zram module
    modprobe zram num_devices=1
    
    # Set ukuran (dalam bytes)
    zram_size_bytes=$((zram_size * 1024 * 1024 * 1024))
    echo $zram_size_bytes > /sys/block/zram0/disksize
    
    # Format sebagai swap
    print_info "Memformat ZRAM..."
    mkswap /dev/zram0
    
    # Aktifkan
    print_info "Mengaktifkan ZRAM..."
    swapon -p 5 /dev/zram0
    
    # Buat systemd service untuk auto-start
    print_info "Membuat systemd service..."
    
    cat > /etc/systemd/system/zram.service <<EOF
[Unit]
Description=ZRAM Setup
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c 'modprobe zram num_devices=1 && echo ${zram_size_bytes} > /sys/block/zram0/disksize && mkswap /dev/zram0 && swapon -p 5 /dev/zram0'
ExecStop=/usr/bin/bash -c 'swapoff /dev/zram0 && rmmod zram'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable zram.service
    
    # Optimasi untuk ZRAM
    if ! grep -q 'vm.swappiness=100' /etc/sysctl.conf; then
        cat >> /etc/sysctl.conf <<EOF

# ZRAM optimization (high swappiness for compressed RAM)
vm.swappiness=100
vm.vfs_cache_pressure=50
vm.page-cluster=0
EOF
        sysctl -p > /dev/null 2>&1
    fi
    
    echo ""
    print_success "ZRAM ${zram_size}GB berhasil diaktifkan!"
    echo ""
    print_info "ZRAM Details:"
    echo "  ✓ Ukuran: ${zram_size}GB"
    echo "  ✓ Tipe: Compressed RAM"
    echo "  ✓ Priority: High (5)"
    echo "  ✓ Compression: lz4/lzo"
    echo ""
    echo "Status memory:"
    free -h | grep -E "Mem|Swap"
    echo ""
    
    # Tampilkan zram info jika ada zramctl
    if command -v zramctl &> /dev/null; then
        echo "ZRAM Info:"
        zramctl
        echo ""
    fi
}

setup_fail2ban() {
    print_header "SETUP FAIL2BAN"
    echo ""
    
    # Cek apakah fail2ban sudah terinstall
    if ! command -v fail2ban-client &> /dev/null; then
        print_info "Fail2ban belum terinstall, menginstall..."
        $PKG_INSTALL fail2ban
        print_success "Fail2ban berhasil diinstall!"
    else
        print_info "Fail2ban sudah terinstall"
    fi
    
    echo ""
    
    # Backup konfigurasi lama jika ada
    if [ -f /etc/fail2ban/jail.local ]; then
        cp /etc/fail2ban/jail.local /etc/fail2ban/jail.local.backup.$(date +%Y%m%d_%H%M%S)
        print_info "Backup konfigurasi lama dibuat"
    fi
    
    # Buat konfigurasi
    print_info "Membuat konfigurasi fail2ban..."
    
    cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
# Ban time: 1 jam (3600 detik)
bantime = 3600

# Find time: 10 menit (600 detik)
findtime = 600

# Max retry sebelum ban
maxretry = 5

# Email notification (opsional)
destemail = root@localhost
sendername = Fail2Ban
action = %(action_mwl)s

# Ignoreip: IP yang tidak akan di-ban
# ignoreip = 127.0.0.1/8 ::1

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 7200
findtime = 600
EOF
    
    # Untuk CentOS/RHEL, ganti path log
    if [ "$PKG_MANAGER" = "yum" ]; then
        sed -i 's|logpath = /var/log/auth.log|logpath = /var/log/secure|' /etc/fail2ban/jail.local
    fi
    
    print_success "Konfigurasi fail2ban dibuat!"
    
    # Restart dan enable fail2ban
    print_info "Mengaktifkan fail2ban..."
    
    systemctl restart fail2ban
    systemctl enable fail2ban
    
    echo ""
    print_success "Fail2Ban berhasil dikonfigurasi dan diaktifkan!"
    echo ""
    
    # Tampilkan status
    sleep 2
    print_info "Status Fail2Ban:"
    fail2ban-client status
    echo ""
    
    # Info konfigurasi
    print_info "Konfigurasi SSH Protection:"
    echo "  - Max retry: 3 kali"
    echo "  - Ban time: 2 jam"
    echo "  - Find time: 10 menit"
    echo ""
}

display_info() {
    print_header "INFORMASI SISTEM"
    echo ""
    
    echo "Hostname    : $(hostname)"
    echo "IP Address  : $(hostname -I | awk '{print $1}')"
    echo "OS          : $OS_NAME"
    echo "Kernel      : $(uname -r)"
    
    # Timezone info
    current_tz=$(timedatectl | grep "Time zone" | awk '{print $3}')
    echo "Timezone    : $current_tz"
    echo "Waktu       : $(date)"
    
    # Memory info
    echo ""
    echo "Memory & Swap:"
    free -h | grep -E "Mem|Swap"
    
    # ZRAM info
    if [ -d /sys/class/block/zram0 ]; then
        echo ""
        echo "ZRAM Status : Active ✓"
        if command -v zramctl &> /dev/null; then
            zramctl 2>/dev/null | head -2
        fi
    fi
    
    # Fail2ban status
    echo ""
    if command -v fail2ban-client &> /dev/null; then
        if systemctl is-active --quiet fail2ban; then
            echo "Fail2Ban    : Active ✓"
        else
            echo "Fail2Ban    : Inactive"
        fi
    else
        echo "Fail2Ban    : Not installed"
    fi
    
    echo ""
}

main_menu() {
    while true; do
        clear
        print_header "VPS SIMPLE SETUP"
        echo ""
        display_info
        echo ""
        
        echo "MENU:"
        echo "1. Install Paket Dasar"
        echo "2. Setup Timezone"
        echo "3. Setup Memory (Swap/Zram)"
        echo "4. Setup Fail2Ban"
        echo "5. Setup Semua (All-in-One)"
        echo "6. Tampilkan Info Sistem"
        echo "0. Keluar"
        echo ""
        
        read -p "Pilihan (0-6): " menu_choice
        
        case $menu_choice in
            1)
                install_basic_packages
                ;;
            2)
                setup_timezone
                ;;
            3)
                setup_memory
                ;;
            4)
                setup_fail2ban
                ;;
            5)
                print_header "SETUP ALL-IN-ONE"
                echo ""
                print_info "Akan setup: Paket Dasar, Timezone, Memory, Fail2Ban"
                echo ""
                read -p "Lanjutkan? (y/n): " confirm
                
                if [ "$confirm" = "y" ]; then
                    install_basic_packages
                    setup_timezone
                    setup_memory
                    setup_fail2ban
                    
                    echo ""
                    print_success "========================================="
                    print_success "SETUP LENGKAP SELESAI!"
                    print_success "========================================="
                    echo ""
                fi
                ;;
            6)
                clear
                display_info
                ;;
            0)
                print_info "Keluar dari script"
                exit 0
                ;;
            *)
                print_error "Pilihan tidak valid!"
                sleep 1
                ;;
        esac
        
        if [ "$menu_choice" != "6" ] && [ "$menu_choice" != "0" ]; then
            echo ""
            read -p "Tekan ENTER untuk kembali ke menu..." dummy
        fi
    done
}

# Main function
main() {
    check_root
    detect_os
    
    echo ""
    print_info "Script ini akan setup: Paket Dasar, Timezone, Memory (Swap/Zram), Fail2Ban"
    echo ""
    read -p "Lanjutkan? (y/n): " start_confirm
    
    if [ "$start_confirm" != "y" ]; then
        print_info "Script dibatalkan"
        exit 0
    fi
    
    main_menu
}

# Trap untuk handle error
trap 'print_error "Error pada line $LINENO"' ERR

# Jalankan main function
main
