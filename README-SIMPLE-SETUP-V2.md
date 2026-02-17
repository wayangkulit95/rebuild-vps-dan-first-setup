# VPS Simple Setup Script v2.0

Script lengkap untuk setup VPS dengan fitur: **Paket Dasar**, **Timezone**, **Memory (Swap/ZRAM)**, dan **Fail2Ban**.

---

## 🎯 Fitur Utama

✅ **Install Paket Dasar**
- curl, wget, git
- vim, nano
- htop, net-tools
- screen, tmux
- ncdu, tree
- unzip, zip, tar, rsync

✅ **Setup Timezone**
- 10 pilihan timezone populer
- Input manual timezone
- Auto-update sistem time

✅ **Setup Memory (3 Pilihan)**
1. **SWAP** - Disk sebagai memory tambahan (1GB, 2GB, 3GB, 4GB, 8GB)
2. **ZRAM** - Storage jadi RAM terkompresi (1GB, 2GB, 3GB, 4GB, 8GB)
3. **SWAP + ZRAM** - Kombinasi untuk performa optimal

✅ **Setup Fail2Ban**
- Auto-install jika belum ada
- Proteksi SSH brute-force
- Max retry: 3 kali, Ban: 2 jam

---

## 🚀 Cara Penggunaan

### **Quick Start**

```bash
# Upload ke VPS
scp vps-simple-setup-v2.sh root@YOUR-VPS-IP:/root/

# SSH ke VPS
ssh root@YOUR-VPS-IP

# Jalankan script
chmod +x vps-simple-setup-v2.sh
./vps-simple-setup-v2.sh
```

### **Menu Interactive**

```
MENU:
1. Install Paket Dasar
2. Setup Timezone
3. Setup Memory (Swap/Zram)
4. Setup Fail2Ban
5. Setup Semua (All-in-One)  ← Recommended!
6. Tampilkan Info Sistem
0. Keluar
```

---

## 💾 Memory Options Explained

### **1. SWAP (Disk sebagai Memory)**

**Cara Kerja:**
- Menggunakan space di disk sebagai virtual RAM
- File swap disimpan di `/swapfile`

**Kelebihan:**
- ✅ Stabil dan reliable
- ✅ Bisa ukuran besar
- ✅ Tidak memakan RAM

**Kekurangan:**
- ❌ Lambat (tergantung kecepatan disk)
- ❌ Menambah I/O disk

**Cocok untuk:**
- Server dengan RAM kecil (<2GB)
- VPS dengan SSD
- Server yang butuh memory backup

**Rekomendasi Ukuran:**
```
RAM 512MB → Swap 2GB
RAM 1GB   → Swap 2GB
RAM 2GB   → Swap 2-4GB
RAM 4GB   → Swap 4GB
RAM >4GB  → Swap 4-8GB
```

---

### **2. ZRAM (Storage Jadi RAM Terkompresi)**

**Cara Kerja:**
- Menggunakan sebagian RAM untuk swap terkompresi
- Data dikompress dengan lz4/lzo
- Tidak menggunakan disk sama sekali!

**Kelebihan:**
- ✅ Sangat cepat (pakai RAM, bukan disk)
- ✅ Tidak ada I/O disk
- ✅ Efisiensi RAM 2-3x lebih baik
- ✅ Cocok untuk performa tinggi

**Kekurangan:**
- ❌ Menggunakan RAM yang ada
- ❌ Ukuran terbatas oleh RAM

**Cocok untuk:**
- VPS dengan RAM cukup (>1GB)
- Aplikasi butuh speed tinggi
- Server dengan disk lambat (HDD)
- Workload dengan data compressible

**Rekomendasi Ukuran:**
```
RAM 1GB   → ZRAM 1-2GB (compression 2x)
RAM 2GB   → ZRAM 2-4GB
RAM 4GB   → ZRAM 4-8GB
RAM >4GB  → ZRAM 8GB+
```

**Contoh Efisiensi:**
```
Physical RAM: 2GB
ZRAM: 2GB (terkompresi)
Efektif RAM: ~3-4GB (tergantung data)
```

---

### **3. SWAP + ZRAM (Best of Both Worlds)**

**Cara Kerja:**
- ZRAM untuk data hot (sering diakses)
- SWAP untuk data cold (jarang diakses)
- Priority: ZRAM > SWAP

**Kelebihan:**
- ✅ Performa maksimal
- ✅ Memory capacity maksimal
- ✅ Balanced speed & size

**Cocok untuk:**
- Production server
- Server dengan workload varied
- VPS dengan RAM 2-4GB

**Rekomendasi Setup:**
```
RAM 2GB:
- ZRAM: 2GB (untuk speed)
- SWAP: 2GB (untuk backup)
- Total efektif: ~5-6GB

RAM 4GB:
- ZRAM: 4GB (untuk speed)
- SWAP: 4GB (untuk backup)
- Total efektif: ~10-12GB
```

---

## 📊 Perbandingan SWAP vs ZRAM

| Aspek | SWAP | ZRAM | SWAP+ZRAM |
|-------|------|------|-----------|
| **Speed** | Lambat | Sangat Cepat | Fast |
| **Disk I/O** | Tinggi | Nihil | Medium |
| **RAM Usage** | 0 | Medium | Medium |
| **Capacity** | Besar | Terbatas | Maksimal |
| **Best for** | RAM < 2GB | RAM > 1GB | All cases |

---

## 🎯 Contoh Skenario

### **Skenario 1: VPS RAM 512MB**
```bash
Pilih: SWAP 2GB
Alasan: RAM terlalu kecil untuk ZRAM
Result: 512MB + 2GB = ~2.5GB total
```

### **Skenario 2: VPS RAM 1GB dengan aplikasi berat**
```bash
Pilih: ZRAM 2GB
Alasan: Butuh speed tinggi, data compressible
Result: 1GB + 2GB (compressed) = ~2-3GB efektif
```

### **Skenario 3: VPS RAM 2GB production server**
```bash
Pilih: SWAP 2GB + ZRAM 2GB
Alasan: Balanced performance & capacity
Result: 2GB + 2GB + 2GB (compressed) = ~5-6GB efektif
```

### **Skenario 4: VPS RAM 4GB database server**
```bash
Pilih: SWAP 4GB + ZRAM 4GB
Alasan: Database butuh memory besar & speed
Result: 4GB + 4GB + 4GB (compressed) = ~10-12GB efektif
```

---

## 💡 Detail Fitur Memory

### **SWAP Features:**
- ✅ File: `/swapfile`
- ✅ Auto-mount via `/etc/fstab`
- ✅ Optimized: `vm.swappiness=10`
- ✅ Ukuran: 1GB, 2GB, 3GB, 4GB, 8GB

### **ZRAM Features:**
- ✅ Device: `/dev/zram0`
- ✅ Compression: lz4/lzo
- ✅ Priority: High (5)
- ✅ Auto-start via systemd service
- ✅ Optimized: `vm.swappiness=100` (untuk compressed RAM)
- ✅ Ukuran: 1GB, 2GB, 3GB, 4GB, 8GB

---

## 📋 Paket Dasar Yang Diinstall

### **Development Tools:**
- `git` - Version control
- `build-essential` / `gcc make` - Compiler
- `curl`, `wget` - Download tools

### **Text Editors:**
- `vim` - Advanced editor
- `nano` - Simple editor

### **Monitoring:**
- `htop` - Process monitor
- `ncdu` - Disk usage analyzer
- `tree` - Directory tree viewer

### **Network:**
- `net-tools` - Network utilities
- `rsync` - File sync

### **Terminal:**
- `screen` - Terminal multiplexer
- `tmux` - Modern terminal multiplexer

### **Archive:**
- `unzip`, `zip` - ZIP tools
- `tar` - TAR archiver

---

## 🔧 Troubleshooting

### **ZRAM tidak aktif setelah reboot**

```bash
# Cek service
systemctl status zram.service

# Enable jika belum
systemctl enable zram.service

# Restart service
systemctl restart zram.service

# Cek ZRAM
zramctl
```

### **SWAP tidak muncul**

```bash
# Cek fstab
cat /etc/fstab | grep swap

# Aktifkan manual
swapon -a

# Cek status
free -h
swapon --show
```

### **Memory penuh dengan ZRAM**

```bash
# Cek compression ratio
zramctl

# Jika ratio rendah (<2x), data tidak compressible
# Pertimbangkan tambah SWAP atau upgrade RAM
```

### **Performa lambat dengan SWAP**

```bash
# Cek disk I/O
iostat -x 1

# Jika I/O tinggi, pertimbangkan:
# 1. Upgrade ke SSD
# 2. Ganti dengan ZRAM
# 3. Kurangi swappiness
echo 5 > /proc/sys/vm/swappiness
```

---

## 📈 Monitoring Memory

### **Cek Memory Usage:**
```bash
# Overall memory
free -h

# Detailed memory
cat /proc/meminfo

# Memory per process
ps aux --sort=-%mem | head
```

### **Cek SWAP Usage:**
```bash
# SWAP summary
swapon --show

# SWAP per process
for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r | head
```

### **Cek ZRAM Stats:**
```bash
# ZRAM info
zramctl

# Compression ratio
cat /sys/block/zram0/mm_stat

# Detailed stats
cat /proc/swaps
```

---

## ⚡ Performance Tips

### **Untuk SWAP:**
1. Gunakan SSD jika memungkinkan
2. Set `vm.swappiness=10` (sudah auto)
3. Jangan terlalu besar (max 2x RAM)
4. Monitor disk I/O

### **Untuk ZRAM:**
1. Set `vm.swappiness=100` (sudah auto)
2. Set `vm.page-cluster=0` (sudah auto)
3. Ukuran ZRAM: 50-100% dari RAM
4. Monitor compression ratio

### **Untuk SWAP+ZRAM:**
1. ZRAM priority lebih tinggi
2. SWAP sebagai backup
3. Total memory: RAM + ZRAM(2x) + SWAP
4. Monitor keduanya

---

## 🔒 Security (Fail2Ban)

### **Default Config:**
```
SSH Protection:
- Max retry: 3 kali
- Ban time: 2 jam
- Find time: 10 menit
```

### **Useful Commands:**
```bash
# Cek status
fail2ban-client status sshd

# Cek banned IPs
fail2ban-client status sshd | grep "Banned IP"

# Unban IP
fail2ban-client set sshd unbanip 192.168.1.100

# Restart
systemctl restart fail2ban
```

---

## 📊 Contoh Output

### **Setup Lengkap:**
```
=========================================
INFORMASI SISTEM
=========================================

Hostname    : vps-server
IP Address  : 192.168.1.100
OS          : Ubuntu 22.04.3 LTS
Kernel      : 5.15.0-89-generic
Timezone    : Asia/Jakarta
Waktu       : Mon Feb 17 14:30:45 WIB 2026

Memory & Swap:
              total        used        free
Mem:           2.0Gi       800Mi       1.2Gi
Swap:          6.0Gi        50Mi       5.9Gi

ZRAM Status : Active ✓
NAME       ALGORITHM DISKSIZE  DATA COMPR TOTAL
/dev/zram0 lz4            2G  400M  150M   160M

Fail2Ban    : Active ✓
```

### **ZRAM Compression Info:**
```
NAME       ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT
/dev/zram0 lz4            2G 512M  180M  190M       4 [SWAP]

Compression Ratio: 2.84x (sangat efisien!)
```

---

## 🎯 Best Practices

1. **Untuk VPS RAM Kecil (<2GB):**
   - Gunakan SWAP 2-4GB
   - Atau ZRAM 1-2GB jika butuh speed

2. **Untuk VPS RAM Medium (2-4GB):**
   - Gunakan SWAP + ZRAM
   - ZRAM untuk hot data
   - SWAP untuk cold data

3. **Untuk VPS RAM Besar (>4GB):**
   - ZRAM 4-8GB untuk efficiency
   - SWAP optional

4. **Monitoring:**
   - Cek memory usage harian
   - Monitor compression ratio ZRAM
   - Watch disk I/O dengan SWAP

---

## 📞 Support

### **Cek Logs:**
```bash
# System log
journalctl -xe

# Fail2ban log
tail -f /var/log/fail2ban.log

# ZRAM log
dmesg | grep zram
```

### **Reset Memory:**
```bash
# Reset SWAP
swapoff -a && swapon -a

# Reset ZRAM
systemctl restart zram.service
```

---

## 🚀 Quick Commands

```bash
# One-liner install
wget https://your-url/vps-simple-setup-v2.sh && \
chmod +x vps-simple-setup-v2.sh && \
./vps-simple-setup-v2.sh

# Check everything
free -h && swapon --show && zramctl && fail2ban-client status
```

---

**Version:** 2.0  
**Features:** Basic Packages + Timezone + Memory (SWAP/ZRAM) + Fail2Ban  
**Created:** February 2026  

🎉 **Enjoy your optimized VPS with ZRAM magic!** 🚀
