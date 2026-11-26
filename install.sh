#!/bin/bash
# ============================================
#  Install Script: Gmai-Tools + Telegram Bot
#  Dibuat buat running di Laptop/PC (Linux)
#  Dibuat oleh: radikal69
# ============================================

set -e  # Jika ada error, berhenti langsung

echo "=== Memulai Installasi Gmai-Tools ==="
echo ""

# ============================================
# 1. CEK APASAH UBUNTU/Debian
# ============================================
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "✅ Deteksi OS: $NAME $VERSION_ID"
else
    echo "❌ OS tidak dideteksi. Script ini buat Ubuntu/Debian."
    exit 1
fi

# ============================================
# 2. UPDATE & INSTALL DEPENDENSI SISTEM
# ============================================
echo ""
echo "🔄 Mengupdate package list dan menginstall Python3 + pip..."
apt update -y && apt upgrade -y
apt install -y python3 python3-pip git

# ============================================
# 3. INSTALL LIBRARY PYTHON
# ============================================
echo ""
echo "🔄 Menginstall library Python (faker + python-telegram-bot)..."
pip3 install --upgrade pip
pip3 install faker python-telegram-bot

# ============================================
# 4. SIAPKAN FILE APLIKASI
# ============================================
echo ""
echo "📁 Mengatur file aplikasi..."

# Cek apakah udah ada folder
if [ -d "app.py" ] || [ -f "app.py" ]; then
    echo "✅ File app.py sudah ada, lewat ke langkah selanjutnya."
else
    echo "⚠️  app.py belum ditemukan. Pastikan file sudah di-download atau di-clone."
    echo "   Ketik: git clone https://github.com/radikal69/gmai-tools.git"
    exit 1
fi

# ============================================
# 5. BUAT FOLDER LOG (Opsional)
# ============================================
echo ""
echo "📂 Membuat folder untuk log bot..."
mkdir -p ./logs
touch ./logs/bot.log

# ============================================
# 6. INFO SELESAI
# ============================================
echo ""
echo "========================================"
echo "✅ Installasi SELESAI!"
echo "========================================"
echo ""
echo "📦 Yang sudah terinstall:"
echo "   - Python3 + pip"
echo "   - Library: faker, python-telegram-bot"
echo "   - Folder log sudah dibuat"
echo ""
echo "▶️ Cara menjalankan bot:"
echo "   python3 telegram_bot.py"
echo ""
echo "📝 Catatan:"
echo "   - Isi BOT_TOKEN dan ADMIN_CHAT_ID di telegram_bot.py"
echo "   - Tekan Ctrl+C di terminal untuk menghentikan bot"
echo "========================================"