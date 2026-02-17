# VPS Rebuild & Setup Scripts

**Provided by: Microtech.Store (MTS)**  
**Copyright: @2026 Microtech.Store**  
**Website: https://microtech.store**

---

## 📦 Script Collection

Kumpulan script profesional untuk rebuild dan setup VPS dengan berbagai fitur lengkap.

### **🔧 VPS Rebuild Scripts (v1.0, v2.0, v3.0)**
Script untuk rebuild VPS dengan pilihan OS dan konfigurasi otomatis.

### **⚙️ VPS Simple Setup Script**
Script untuk setup cepat VPS yang sudah ter-install.

---

## 🚀 VPS Rebuild Scripts

### **Version 1.0** - Full Features ⭐
```
✅ Pilihan 20+ OS (Debian, Ubuntu, CentOS, Rocky, AlmaLinux)
✅ Password management (auto-generate/manual)
✅ Validasi password ketat
✅ Install paket dasar lengkap
✅ Setup timezone (10+ pilihan)
✅ SWAP / ZRAM / SWAP+ZRAM (1-8GB)
✅ Fail2Ban protection
```

### **Version 2.0** - Lite Edition 🚀
```
✅ Pilihan 20+ OS (Debian, Ubuntu, CentOS, Rocky, AlmaLinux)
✅ Password management (auto-generate/manual)
✅ Validasi password ketat
✅ Install paket dasar lengkap
✅ Setup timezone (10+ pilihan)
```

### **Version 3.0** - Full Features ⭐
```
✅ Pilihan 20+ OS (Debian, Ubuntu, CentOS, Rocky, AlmaLinux)
✅ Password management (auto-generate/manual)
✅ Validasi password ketat
✅ Install paket dasar lengkap
✅ Setup timezone (10+ pilihan)
✅ SWAP / ZRAM / SWAP+ZRAM (1-8GB)
✅ Fail2Ban protection
```

---

## 📊 Perbandingan Versi

| Fitur | v1.0 | v2.0 | v3.0 |
|-------|------|------|------|
| **20+ OS Options** | ✅ | ✅ | ✅ |
| **Password Management** | ✅ | ✅ | ✅ |
| **Basic Packages** | ✅ | ✅ | ✅ |
| **Timezone Setup** | ✅ | ✅ | ✅ |
| **SWAP (1-8GB)** | ✅ | ❌ | ✅ |
| **ZRAM (1-8GB)** | ✅ 🔥 | ❌ | ✅ 🔥 |
| **SWAP + ZRAM** | ✅ 🚀 | ❌ | ✅ 🚀 |
| **Fail2Ban** | ✅ | ❌ | ✅ |
| **Setup Time** | ~10 min | ~5 min | ~10 min |
| **Best For** | Production | Dev/Test | Production |

---

## 🔥 ZRAM Technology

### **Apa itu ZRAM?**
ZRAM adalah teknologi yang mengubah **storage menjadi RAM terkompresi** dengan efisiensi 2-3x lipat!

### **Keunggulan ZRAM:**
```
✓ Speed: 10-100x lebih cepat dari SWAP biasa
✓ Compression: 2-3x efisiensi memory
✓ No Disk I/O: Tidak memperlambat disk
✓ Perfect for: Database, cache, high-performance apps
```

### **Pilihan Memory di v1.0 & v3.0:**

#### **1. SWAP (Disk Memory)**
- Traditional swap di disk
- Stabil, kapasitas besar
- Cocok untuk RAM < 2GB

#### **2. ZRAM (Compressed RAM)** 🔥
- Storage jadi RAM terkompresi
- Sangat cepat, efisien 2-3x
- Cocok untuk RAM > 1GB

#### **3. SWAP + ZRAM** 🚀 **RECOMMENDED!**
- Kombinasi optimal keduanya
- ZRAM untuk speed, SWAP untuk backup
- Performa & kapasitas maksimal

### **Ukuran Tersedia:**
- 1 GB
- 2 GB (Recommended untuk RAM 1-2GB)
- 3 GB
- 4 GB (Recommended untuk RAM 2-4GB)
- 8 GB (Recommended untuk RAM > 4GB)

---

## 🎯 Rekomendasi Setup

### **RAM 512MB - 1GB:**
```bash
Version: v1.0 atau v3.0
Memory: SWAP 2GB
Reason: RAM terlalu kecil untuk ZRAM
```

### **RAM 1-2GB:**
```bash
Version: v1.0 atau v3.0
Memory: ZRAM 2GB atau SWAP 2GB + ZRAM 2GB
Result: ~5-6GB efektif memory
Perfect for: Small production servers
```

### **RAM 2-4GB:**
```bash
Version: v1.0 atau v3.0
Memory: SWAP 4GB + ZRAM 4GB
Result: ~10-12GB efektif memory
Perfect for: Medium production servers
```

### **RAM > 4GB:**
```bash
Version: v1.0 atau v3.0
Memory: ZRAM 4-8GB
Result: 8-16GB extra compressed memory
Perfect for: High-performance applications
```

### **Development/Testing:**
```bash
Version: v2.0
Memory: None (sudah cukup)
Reason: Setup cepat, minimal features
```

---

## 🚀 Cara Penggunaan

### **Method 1: Upload Script**

```bash
# Upload ke VPS
scp vps-rebuild-v1.0.sh root@YOUR-VPS-IP:/root/

# SSH ke VPS
ssh root@YOUR-VPS-IP

# Jalankan script
chmod +x vps-rebuild-v1.0.sh
./vps-rebuild-v1.0.sh
```

### **Method 2: Download Direct**

```bash
# SSH ke VPS
ssh root@YOUR-VPS-IP

# Download script
wget https://microtech.store/scripts/vps-rebuild-v1.0.sh

# Jalankan
chmod +x vps-rebuild-v1.0.sh
./vps-rebuild-v1.0.sh
```

---

## 📋 Operating Systems Supported

### **Debian Family:**
- Debian 10 (Buster)
- Debian 11 (Bullseye)
- Debian 12 (Bookworm)
- Debian 13 (Trixie)

### **Ubuntu LTS:**
- Ubuntu 20.04 LTS (Focal)
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 24.04 LTS (Noble)

### **Ubuntu Non-LTS:**
- Ubuntu 21.04, 21.10
- Ubuntu 23.04, 23.10
- Ubuntu 24.10, 25.04

### **RHEL Family:**
- CentOS 7, Stream 8, Stream 9
- Rocky Linux 8, 9
- AlmaLinux 8, 9

---

## 💡 VPS Simple Setup Script

Script untuk setup cepat VPS yang sudah ter-install (tidak rebuild OS).

### **Features:**
```
✅ Install paket dasar (curl, wget, git, vim, htop, dll)
✅ Setup timezone (10+ pilihan)
✅ Setup memory: SWAP / ZRAM / SWAP+ZRAM (1-8GB)
✅ Setup Fail2Ban security
✅ Interactive menu
```

### **Usage:**
```bash
# Upload & jalankan
scp vps-simple-setup-v2.sh root@YOUR-VPS-IP:/root/
ssh root@YOUR-VPS-IP
chmod +x vps-simple-setup-v2.sh
./vps-simple-setup-v2.sh

# Pilih dari menu:
# 1. Install Paket Dasar
# 2. Setup Timezone
# 3. Setup Memory (Swap/Zram)
# 4. Setup Fail2Ban
# 5. Setup Semua (All-in-One)
```

---

## 🔒 Security Features

### **Password Management:**
- Auto-generate 16 karakter random
- Manual input dengan validasi ketat
- Minimal: 8 karakter, 1 uppercase, 1 lowercase, 1 number
- Password tersimpan aman di `/root/.vps_password_*.txt`

### **Fail2Ban Protection (v1.0 & v3.0):**
```
SSH Brute-Force Protection:
- Max retry: 3 attempts
- Ban time: 2 hours
- Find time: 10 minutes
- Auto-enable on boot
```

---

## 📦 Installed Packages

### **Development Tools:**
- `git` - Version control
- `curl`, `wget` - Download utilities
- `build-essential` / `gcc` - Compilers

### **Editors:**
- `vim` - Advanced text editor
- `nano` - Simple text editor

### **Monitoring:**
- `htop` - Process monitor
- `ncdu` - Disk usage analyzer
- `tree` - Directory tree viewer

### **Network:**
- `net-tools` - Network utilities
- `rsync` - File synchronization

### **Terminal:**
- `screen` - Terminal multiplexer
- `tmux` - Modern terminal multiplexer

### **Archive:**
- `unzip`, `zip` - ZIP utilities
- `tar` - TAR archiver

---

## 🛠️ Troubleshooting

### **ZRAM tidak aktif:**
```bash
# Cek service
systemctl status zram.service

# Restart
systemctl restart zram.service

# Verify
zramctl
free -h
```

### **SWAP tidak aktif:**
```bash
# Cek fstab
cat /etc/fstab | grep swap

# Aktifkan
swapon -a

# Verify
swapon --show
```

### **Fail2Ban tidak jalan:**
```bash
# Status
systemctl status fail2ban

# Restart
systemctl restart fail2ban

# Cek banned IPs
fail2ban-client status sshd
```

---

## 📈 Performance Monitoring

### **Memory Usage:**
```bash
# Overall
free -h

# Per process
ps aux --sort=-%mem | head

# ZRAM stats
zramctl
cat /sys/block/zram0/mm_stat
```

### **SWAP Usage:**
```bash
# Summary
swapon --show

# Per process
for file in /proc/*/status; do 
  awk '/VmSwap|Name/{printf $2 " " $3}END{print ""}' $file
done | sort -k 2 -n -r | head
```

---

## 🔄 Maintenance

### **Update System:**
```bash
# Debian/Ubuntu
apt update && apt upgrade -y

# CentOS/Rocky/AlmaLinux
yum update -y
```

### **Monitor Resources:**
```bash
# Real-time monitoring
htop

# Disk usage
df -h
ncdu /

# Memory
free -h
```

---

## 📞 Support

**Microtech.Store (MTS)**  
Website: https://microtech.store  
Email: support@microtech.store  

### **Self-Help:**
```bash
# Check logs
journalctl -xe
tail -f /var/log/syslog

# Check services
systemctl status sshd
systemctl status fail2ban

# Check memory
free -h && zramctl && swapon --show
```

---

## 📝 Best Practices

### **For Production Servers:**
1. Use v1.0 or v3.0 (full features)
2. Enable SWAP + ZRAM for optimal performance
3. Setup Fail2Ban for security
4. Use strong passwords (auto-generate recommended)
5. Regular system updates

### **For Development:**
1. Use v2.0 (lite, fast setup)
2. Focus on speed over security
3. Manual password OK

### **Memory Recommendations:**
```
RAM < 2GB    → SWAP 2GB
RAM 1-2GB    → ZRAM 2GB or SWAP+ZRAM
RAM 2-4GB    → SWAP 2-4GB + ZRAM 4GB
RAM > 4GB    → ZRAM 4-8GB
```

---

## 🎉 Quick Commands

```bash
# Check everything
free -h && swapon --show && zramctl && fail2ban-client status

# One-liner install
wget https://microtech.store/scripts/vps-rebuild-v1.0.sh && \
chmod +x vps-rebuild-v1.0.sh && \
./vps-rebuild-v1.0.sh
```

---

## 📜 License & Copyright

**Copyright @2026 Microtech.Store (MTS)**  
All rights reserved.

These scripts are provided as-is for VPS management purposes.  
For commercial use or redistribution, please contact Microtech.Store.

---

## 🌟 Features Summary

| Script | OS Options | Password | Packages | Timezone | Memory | Security |
|--------|------------|----------|----------|----------|--------|----------|
| **v1.0** | 20+ | ✅ | ✅ | ✅ | SWAP/ZRAM/Both | ✅ Fail2Ban |
| **v2.0** | 20+ | ✅ | ✅ | ✅ | ❌ | ❌ |
| **v3.0** | 20+ | ✅ | ✅ | ✅ | SWAP/ZRAM/Both | ✅ Fail2Ban |
| **Simple** | Current | ❌ | ✅ | ✅ | SWAP/ZRAM/Both | ✅ Fail2Ban |

---

**Powered by Microtech.Store (MTS) @2026**  
🚀 Professional VPS Management Solutions
