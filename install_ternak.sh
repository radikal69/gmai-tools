#!/bin/bash
# ============================================
#  Install Script Lengkap: Gmail Farming Setup
#  Buat: Python3 + Telegram Bot + Selenium Browser Automation
#  Catatan: Script ini siapin environment, tapi konfigurasi CAPTCHA/proxy
#           harus user isi manual sesuai butuhan.
# ============================================

set -e

# Warna untuk tampilan
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Install Script: Gmail Farming Setup${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e ""
echo -e "${YELLOW}⚠️  CATATAN PENTING${NC}"
echo -e "${YELLOW}Script ini menginstall environment Python dan dependencies${NC}"
echo -e "${YELLOW}untuk otomatisasi browser. Konfigurasi CAPTCHA solver,${NC}"
echo -e "${YELLOW}proxy, dan solver rekaptcha harus user atur sendiri.${NC}"
echo -e "${YELLOW}Google sistem keamanannya ketat, gunakan dengan bijak.${NC}"
echo -e ""

# ============================================
# 1. CEK OS DAN HAK AKSES
# ============================================
echo -e "${GREEN}[1/7] Memeriksa sistem operasi...${NC}"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo -e "   ✅ OS: $NAME"
    if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
        echo -e "   ⚠️  OS terdeteksi $ID, script ini dieksekusi optimal di Ubuntu/Debian."
    fi
else
    echo -e "   ❌ Tidak bisa mendeteksi OS. Keluar."
    exit 1
fi

# ============================================
# 2. UPDATE SYSTEM
# ============================================
echo -e "${GREEN}[2/7] Mengupdate sistem operasi...${NC}"
apt update -y || echo -e "   ⚠️  Gagal update, coba manual${NC}"
apt upgrade -y || echo -e "   ⚠️  Gagal upgrade, lewati${NC}"

# ============================================
# 3. INSTALL DEPENDENSI SISTEM
# ============================================
echo -e "${GREEN}[3/7] Menginstall dependencies sistem (python3, pip, git)...${NC}"
apt install -y python3 python3-pip git curl wget unzip || {
    echo -e "   ❌ Gagal install dependencies. Keluar."
    exit 1
}

# ============================================
# 4. INSTALL LIBRARY PYTHON UTAMA
# ============================================
echo -e "${GREEN}[4/7] Menginstall library Python...${NC}"

# Upgrade pip dulu
echo -e "   → Upgrade pip ke versi terbaru..."
pip3 install --upgrade pip > /dev/null 2>&1 || echo -e "   ⚠️  Gagal upgrade pip"

# Install library utama
echo -e "   → Menginstall faker (generate data identitas)..."
pip3 install faker > /dev/null 2>&1 || echo -e "   ❌ Gagal install faker"

echo -e "   → Menginstall python-telegram-bot (komunikasi Telegram)..."
pip3 install python-telegram-bot > /dev/null 2>&1 || echo -e "   ❌ Gagal install python-telegram-bot"

echo -e "   → Menginstall requests (HTTP client)..."
pip3 install requests > /dev/null 2>&1 || echo -e "   ❌ Gagal install requests"

# ============================================
# 5. INSTALL SELENIUM UNTUK AUTOMASI BROWSER
# ============================================
echo -e "${GREEN}[5/7] Menginstall Selenium untuk otomatisasi browser...${NC}"
echo -e "   → Selenium butuh driver browser (chromedriver/geckdriver) secara manual."
echo -e "   → Install selenium library..."
pip3 install selenium > /dev/null 2>&1 || echo -e "   ❌ Gagal install selenium"

# ============================================
# 6. INSTALL OPTIONAL: PLAYWRIGHT (Alternatif Selenium)
# ============================================
echo -e "${GREEN}[6/7] Menawarkan Playwright (alternatif selenium yang lebih kuat)...${NC}"
echo -e "   Playwright hadir dengan browser bawaan, butuh instalasi ekstra."
echo -e "   Apakah mau install playwright? (y/n)"
read -r playchoice
if [[ "$playchoice" =~ ^[Yy]$ ]]; then
    echo -e "   → Install playwright..."
    pip3 install playwright > /dev/null 2>&1
    echo -e "   → Download browser playwright..."
    playwright install > /dev/null 2>&1 || echo -e "   ⚠️  Gagal install browser playwright"
fi

# ============================================
# 7. SETUP FILE PROYEK DAN KONFIGURASI
# ============================================
echo -e "${GREEN}[7/7] Mengsetup file proyek dan konfigurasi...${NC}"

# Cek folder proyek
PROJECT_DIR="/data/data/com.termux/files/home/gmai-tools"
if [ -d "$PROJECT_DIR" ]; then
    cd "$PROJECT_DIR" || {
        echo -e "   ❌ Gagal masuk ke folder proyek. Keluar."
        exit 1
    }
else
    echo -e "   ⚠️  Folder proyek $PROJECT_DIR tidak ditemukan."
    echo -e "   → Clone dari GitHub: git clone https://github.com/radikal69/gmai-tools.git"
    exit 1
fi

# Cek dan buat konfigurasi bot Telegram
if [ -f "telegram_bot.py" ]; then
    echo -e "   → File telegram_bot.py ditemukan."
    # Cek apakah token dan chat ID sudah diisi
    if grep -q "YOUR_BOT_TOKEN" telegram_bot.py || grep -q "9096933240:AA" telegram_bot.py; then
        echo -e "   ⚠️  Token Telegram belum diisi di file telegram_bot.py."
        echo -e "   → Silakan edit file telegram_bot.py dan masukan:"
        echo -e "      BOT_TOKEN='9096933240:AAHazzrrWFOq3dKesRmR9tU8TFqVAdRT-Dw'"
        echo -e "      ADMIN_CHAT_ID=1373520877"
    else
        echo -e "   ✅ Konfigurasi Telegram sudah terisi."
    fi
else
    echo -e "   ⚠️  telegram_bot.py tidak ditemukan. Pastikan file sudah ada."
fi

# Cek app.py
if [ -f "app.py" ]; then
    echo -e "   ✅ File app.py ditemukan (fungsi generate identitas)."
else
    echo -e "   ❌ app.py tidak ditemukan. Script tidak lengkap."
fi

# Buat folder log
mkdir -p ./logs
touch ./logs/bot.log
echo -e "   → Folder logs dibuat di ./logs/"

# ============================================
# SELESAI
# ============================================
echo -e ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ INSTALLASI SELESAI!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e ""
echo -e "${GREEN}✅ Yang terinstall:${NC}"
echo -e "   • Python3 + pip3"
echo -e "   • Library: faker, python-telegram-bot, requests"
echo -e "   • Selenium (untuk otomatisasi browser)"
echo -e "   • (Opsional) Playwright jika dipilih"
echo -e "   • Folder konfigurasi proyek"
echo -e ""
echo -e "${GREEN}▶️ Cara menjalankan:${NC}"
echo -e "   • Edit file telegram_bot.py isi BOT_TOKEN dan ADMIN_CHAT_ID"
echo -e "   • Jalankan: python3 telegram_bot.py"
echo -e "   • Untuk otomatisasi browser: python3 selenium_bot.py (butuh konfigurasi driver)"
echo -e ""
echo -e "${GREEN}📝 Langkah Selanjutnya yang Harus Dikerjakan Manual:${NC}"
echo -e "   1. Dapatkan chromedriver/geckdriver yang sesuai versi browser-nya"
echo -e "   2. Setup proxy jika butuh IP berbeda setiap akun"
echo -e "   3. Dapatkan CAPTCHA solver atau gunakan manual (Google ReCaptcha)"
echo -e "   4. Konfigurasi cookie dan browser fingerprint sesuai butuhan"
echo -e ""
echo -e "${YELLOW}⚠️  PENTING:${NC}"
echo -e "   - Google punya sistem anti-abuse yang ketat"
echo -e "   - Akun yang dibuat harus dikelola dengan responsabel"
echo -e "   - Perbarui driver browser setiap kali browser di-update"
echo -e ""
echo -e "${GREEN}Installasi berhasil! Selamat mencoba.${NC}"