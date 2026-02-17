# VPS Rebuild Scripts - Perbandingan Versi (Updated with ZRAM)

## 📦 3 Versi Tersedia

### **Version 1.0** - Full Features + ZRAM ⭐
✅ Pilihan 20+ OS (Debian 10-13, Ubuntu 20.04-25.04, CentOS, Rocky, AlmaLinux)  
✅ Set password baru (auto-generate atau manual input)  
✅ Validasi password (minimal 8 karakter, huruf besar/kecil, angka)  
✅ Install paket dasar (curl, wget, git, vim, htop, dll)  
✅ Setup timezone (Asia/Jakarta, Kuala_Lumpur, Singapore, dll)  
✅ **Setup Memory: SWAP / ZRAM / SWAP+ZRAM (1GB, 2GB, 3GB, 4GB, 8GB)**  
✅ Fail2Ban untuk proteksi brute-force  

### **Version 2.0** - Lite Version 🚀
✅ Pilihan 20+ OS (Debian 10-13, Ubuntu 20.04-25.04, CentOS, Rocky, AlmaLinux)  
✅ Set password baru (auto-generate atau manual input)  
✅ Validasi password (minimal 8 karakter, huruf besar/kecil, angka)  
✅ Install paket dasar (curl, wget, git, vim, htop, dll)  
✅ Setup timezone (Asia/Jakarta, Kuala_Lumpur, Singapore, dll)  
❌ Tanpa Swap/Zram  
❌ Tanpa Fail2Ban  

### **Version 3.0** - Full Features + ZRAM ⭐
✅ Pilihan 20+ OS (Debian 10-13, Ubuntu 20.04-25.04, CentOS, Rocky, AlmaLinux)  
✅ Set password baru (auto-generate atau manual input)  
✅ Validasi password (minimal 8 karakter, huruf besar/kecil, angka)  
✅ Install paket dasar (curl, wget, git, vim, htop, dll)  
✅ Setup timezone (Asia/Jakarta, Kuala_Lumpur, Singapore, dll)  
✅ **Setup Memory: SWAP / ZRAM / SWAP+ZRAM (1GB, 2GB, 3GB, 4GB, 8GB)**  
✅ Fail2Ban untuk proteksi brute-force  

---

## 📊 Tabel Perbandingan

| Fitur | v1.0 | v2.0 | v3.0 |
|-------|------|------|------|
| **Pilihan OS (20+)** | ✅ | ✅ | ✅ |
| **Password Management** | ✅ | ✅ | ✅ |
| **Validasi Password** | ✅ | ✅ | ✅ |
| **Install Paket Dasar** | ✅ | ✅ | ✅ |
| **Setup Timezone** | ✅ | ✅ | ✅ |
| **SWAP (1-8GB)** | ✅ | ❌ | ✅ |
| **ZRAM (1-8GB)** | ✅ 🔥 | ❌ | ✅ 🔥 |
| **SWAP + ZRAM** | ✅ 🔥 | ❌ | ✅ 🔥 |
| **Fail2Ban** | ✅ | ❌ | ✅ |

---

## 🔥 **FITUR BARU: ZRAM - Storage Jadi RAM!**

### **Apa itu ZRAM?**
ZRAM menggunakan **storage sebagai RAM terkompresi** dengan efisiensi 2-3x lipat!

### **3 Pilihan Memory di v1.0 & v3.0:**

#### **1. SWAP Saja**
```
✓ Disk sebagai memory backup
✓ Stabil, kapasitas besar
✓ Cocok untuk: RAM < 2GB
✗ Lambat (tergantung disk)
```

#### **2. ZRAM Saja** 🔥
```
✓ Storage jadi RAM terkompresi
✓ Sangat cepat (pakai RAM)
✓ Tidak ada I/O disk
✓ Efisiensi 2-3x
✓ Cocok untuk: RAM > 1GB
```

#### **3. SWAP + ZRAM** 🚀 (RECOMMENDED!)
```
✓ Kombinasi keduanya
✓ ZRAM untuk speed
✓ SWAP untuk backup
✓ Performa & kapasitas maksimal
✓ Cocok untuk: Production server
```

### **Ukuran Tersedia:**
- 1 GB
- 2 GB (Recommended untuk RAM 1-2GB)
- 3 GB
- 4 GB (Recommended untuk RAM 2-4GB)
- 8 GB (Recommended untuk RAM > 4GB)

---

## 💡 **Contoh Efisiensi ZRAM:**

```
RAM Physical: 2GB
ZRAM: 2GB (terkompresi)
─────────────────────────
Total Efektif: ~4-6GB!

Compression Ratio: 2-3x
Speed: Sama dengan RAM
I/O Disk: 0 (nihil!)
```

**VS**

```
RAM Physical: 2GB
SWAP: 2GB (di disk)
─────────────────────────
Total: 4GB

Speed: Lambat (tergantung disk)
I/O Disk: Tinggi
```

---

## 🎯 Rekomendasi Penggunaan

### **Gunakan v1.0 atau v3.0 jika:**
- ✅ Ingin proteksi keamanan maksimal (Fail2Ban)
- ✅ VPS memiliki RAM kecil dan butuh extra memory
- ✅ Setup production server dengan performa optimal
- ✅ Ingin fitur ZRAM (storage jadi RAM terkompresi!) 🔥
- ✅ Butuh fitur lengkap

### **Gunakan v2.0 jika:**
- ✅ Hanya butuh setup dasar
- ✅ VPS sudah memiliki RAM besar (>4GB) dan cukup
- ✅ Testing atau development
- ✅ Ingin proses rebuild sangat cepat

---

## 🚀 Cara Penggunaan

### **Upload ke VPS**
```bash
# Upload script pilihan Anda
scp vps-rebuild-v1.0.sh root@YOUR-VPS-IP:/root/
# atau
scp vps-rebuild-v2.0.sh root@YOUR-VPS-IP:/root/
# atau
scp vps-rebuild-v3.0.sh root@YOUR-VPS-IP:/root/
```

### **Jalankan Script**
```bash
# SSH ke VPS
ssh root@YOUR-VPS-IP

# Beri permission
chmod +x vps-rebuild-v*.sh

# Jalankan versi yang dipilih
./vps-rebuild-v1.0.sh
# atau
./vps-rebuild-v2.0.sh
# atau
./vps-rebuild-v3.0.sh
```

---

## 📋 Workflow v1.0 & v3.0 dengan ZRAM

### **Step 1: Pilih OS**
```
Pilihan OS (Debian, Ubuntu, CentOS, Rocky, AlmaLinux)
```

### **Step 2: Set Password**
```
1. Auto-generate (16 karakter random)
2. Input manual (dengan validasi)
```

### **Step 3: Update & Install**
```
- Update sistem
- Install paket dasar
```

### **Step 4: Setup Timezone**
```
Pilih dari 10 timezone populer
```

### **Step 5: Setup Memory** 🔥 **BARU!**
```
Pilih jenis memory:
1. SWAP - Disk sebagai memory (lambat, stabil)
2. ZRAM - Storage jadi RAM terkompresi (cepat, efisien)
3. SWAP + ZRAM - Kombinasi keduanya (optimal)

Pilih ukuran: 1GB, 2GB, 3GB, 4GB, 8GB
```

### **Step 6: Setup Fail2Ban**
```
- Install dan konfigurasi
- Proteksi SSH brute-force
```

---

## 🎯 Rekomendasi Setup Memory

### **RAM 512MB - 1GB:**
```bash
Pilih: SWAP 2GB
Atau: ZRAM 1GB (jika butuh speed)
```

### **RAM 1-2GB:**
```bash
Pilih: ZRAM 2GB (optimal!)
Atau: SWAP 2GB + ZRAM 2GB
Result: ~5-6GB efektif
```

### **RAM 2-4GB:**
```bash
Pilih: SWAP 4GB + ZRAM 4GB (BEST!)
Result: ~10-12GB efektif memory
Performance: Excellent
```

### **RAM > 4GB:**
```bash
Pilih: ZRAM 4-8GB
Result: Extra 8-16GB compressed memory
Perfect for: Database, high-performance apps
```

---

## ⚡ Quick Comparison

```bash
# v1.0 - FULL (dengan Swap/Zram & Fail2Ban) 🔥
Waktu setup: ~5-10 menit
Cocok untuk: Production server
Keamanan: Tinggi
Memory: Optimal dengan SWAP/ZRAM
Speed: Sangat cepat dengan ZRAM

# v2.0 - LITE (tanpa Swap/Zram & Fail2Ban)
Waktu setup: ~3-5 menit
Cocok untuk: Development/Testing
Keamanan: Standar
Memory: Bergantung VPS

# v3.0 - FULL (dengan Swap/Zram & Fail2Ban) 🔥
Waktu setup: ~5-10 menit
Cocok untuk: Production server
Keamanan: Tinggi
Memory: Optimal dengan SWAP/ZRAM
Speed: Sangat cepat dengan ZRAM
```

---

## 📝 Contoh Output v1.0 & v3.0

### **Dengan SWAP Saja:**
```
=========================================
REBUILD VPS v1.0 SELESAI!
=========================================

INFORMASI SISTEM
Hostname    : vps-server
IP Address  : 192.168.1.100
OS          : Ubuntu 22.04.3 LTS
Timezone    : Asia/Jakarta
Swap        : 2.0G (disk)
```

### **Dengan ZRAM Saja:**
```
=========================================
REBUILD VPS v1.0 SELESAI!
=========================================

INFORMASI SISTEM
Hostname    : vps-server
IP Address  : 192.168.1.100
OS          : Ubuntu 22.04.3 LTS
Timezone    : Asia/Jakarta
Swap        : 2.0G (zram - compressed)
Compression : ~2.5x ratio
```

### **Dengan SWAP + ZRAM:**
```
=========================================
REBUILD VPS v1.0 SELESAI!
=========================================

INFORMASI SISTEM
Hostname    : vps-server
IP Address  : 192.168.1.100
OS          : Ubuntu 22.04.3 LTS
Timezone    : Asia/Jakarta
Memory:
- Physical  : 2.0G
- ZRAM      : 2.0G (compressed)
- SWAP      : 2.0G (disk)
Total Effective: ~6-8GB 🚀
```

---

## 🛠️ Troubleshooting

### **Semua Versi:**
```bash
# Cek status
systemctl status sshd

# Test koneksi
ssh root@YOUR-VPS-IP
```

### **v1.0 & v3.0 (ZRAM):**
```bash
# Cek ZRAM
zramctl

# Cek compression ratio
cat /sys/block/zram0/mm_stat

# Restart ZRAM
systemctl restart zram.service
```

### **v1.0 & v3.0 (Fail2Ban):**
```bash
# Cek status
fail2ban-client status sshd

# Unban IP
fail2ban-client set sshd unbanip IP_ADDRESS
```

### **v1.0 & v3.0 (Swap):**
```bash
# Cek swap
free -h
swapon --show

# Reaktivasi swap
swapoff -a && swapon -a
```

---

## 🔄 Update & Maintenance

### **Setelah Rebuild:**
```bash
# Update rutin (semua versi)
apt update && apt upgrade -y  # Debian/Ubuntu
yum update -y                 # CentOS/Rocky/Alma

# Monitor memory
free -h
zramctl  # Untuk v1.0/v3.0 dengan ZRAM

# Monitor sistem
htop
```

---

## 💾 ZRAM vs SWAP - Detail Perbandingan

| Feature | SWAP | ZRAM |
|---------|------|------|
| **Location** | Disk | RAM (compressed) |
| **Speed** | Slow (disk speed) | Fast (RAM speed) |
| **Compression** | None | 2-3x |
| **I/O Impact** | High | None |
| **Capacity** | Large (limited by disk) | Limited (by RAM) |
| **Best Use** | Backup memory | Active memory |
| **RAM Usage** | 0 | Yes (but compressed) |
| **Wear** | Disk wear | No wear |

---

## 📞 Support

Untuk masalah atau pertanyaan:
1. Cek log: `journalctl -xe`
2. Cek memory: `free -h && zramctl`
3. Cek fail2ban: `fail2ban-client status`
4. Hubungi provider VPS jika masalah hardware

---

## 🎉 Summary

**Version 1.0 & 3.0:** Full-featured dengan ZRAM support! 🔥
- Best for: Production servers
- Memory: SWAP / ZRAM / Both (1-8GB)
- Security: Fail2Ban included
- Performance: Optimal

**Version 2.0:** Lite & fast!
- Best for: Development/Testing
- Memory: None
- Security: Basic
- Performance: Depends on VPS

---

**Version Info:**
- v1.0 - Full Features (Swap/ZRAM + Fail2Ban) 🔥
- v2.0 - Lite Version (Basic only)
- v3.0 - Full Features (Swap/ZRAM + Fail2Ban) 🔥

**Updated:** February 2026  
**New Feature:** ZRAM Support - Storage Jadi RAM Terkompresi! 🚀
