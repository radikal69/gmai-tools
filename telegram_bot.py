import random
import string
from faker import Faker
from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes

# Konfigurasi Telegram
BOT_TOKEN = "9096933240:AAHazzrrWFOq3dKesRmR9tU8TFqVAdRT-Dw"
ADMIN_CHAT_ID = 1373520877

# Setel ke Nama Indonesia biar 'lokal' banget
fake = Faker('id_ID')

def rakit_identitas(indukan_name):
    """
    Fungsi buat nyiptain identitas calon email baru
    indukan_name: buat penanda ini 'anak' dari Gmail tua yang mana
    """
    first_name = fake.first_name()
    last_name = fake.last_name()
    full_name = f"{first_name} {last_name}"
    
    # Rakit username: gabungan nama + angka random (biar gak mainstream)
    # Contoh: slamet.mulyono88
    username_clean = "".join(filter(str.isalnum, first_name.lower()))
    last_name_clean = "".join(filter(str.isalnum, last_name.lower()))
    username = f"{username_clean}.{last_name_clean}{random.randint(10, 999)}"
    
    # Password spek 'brutal' (Campuran Huruf, Angka, Simbol)
    password = "".join(random.choices(string.ascii_letters + string.digits + "@#$!", k=12))
    
    # Tanggal Lahir (Spek Dewasa: 18 - 45 Tahun)
    dob = fake.date_of_birth(minimum_age=18, maximum_age=45)

    return {
        "full_name": full_name,
        "first_name": first_name,
        "last_name": last_name,
        "username": username,
        "password": password,
        "dob_day": dob.day,
        "dob_month": dob.month,
        "dob_year": dob.year,
        "parent_ref": indukan_name # Catatan ini anak dari indukan mana
    }

# --- Command Handler Telegram ---

async def start_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handler perintah /start"""
    await update.message.reply_text(
        "👋 *Selamat datang!*\n\n"
        "Bot ini generate identitas pengguna Indonesia palsu.\n"
        "Gunakan perintah `/generate` untuk membuat data baru.",
        parse_mode="Markdown"
    )

async def generate_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handler perintah /generate - generate identitas dan kirim ke Telegram"""
    data = rakit_identitas("Indukan_Eko_01")
    
    message = f"""🆔 *Identitas Baru Diganerasi*

• *Nama Lengkap*: {data['full_name']}
• *Username*: {data['username']}
• *Password*: {data['password']}
• *Tanggal Lahir*: {data['dob_day']}/{data['dob_month']}/{data['dob_year']}
• *Referensi*: {data['parent_ref']}"""

    # Kirim ke admin chat
    await context.bot.send_message(
        chat_id=ADMIN_CHAT_ID,
        text=message,
        parse_mode="Markdown"
    )
    
    # Balas ke user yang meminta
    await update.message.reply_text(
        "✅ Identitas berhasil digenerate dan dikirim ke admin!",
        parse_mode="Markdown"
    )

async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handler perintah /help"""
    await update.message.reply_text(
        "📖 *Bantuan*\n\n"
        "Perintah yang tersedia:\n"
        "• `/generate` - Generate identitas baru\n"
        "• `/start` - Mulai bot\n"
        "• `/help` - Tampilkan bantuan ini",
        parse_mode="Markdown"
    )

def main():
    """Main function to run the bot"""
    application = Application.builder().token(BOT_TOKEN).build()
    
    # Menambahkan handler
    application.add_handler(CommandHandler("start", start_command))
    application.add_handler(CommandHandler("generate", generate_command))
    application.add_handler(CommandHandler("help", help_command))
    
    # Start polling
    application.run_polling()

if __name__ == "__main__":
    main()