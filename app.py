import random
import string
from faker import Faker

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

# --- TEST DRIVE 5 DATA PERTAMA ---
print(f"{'NAMA':<20} | {'USERNAME':<20} | {'PASSWORD':<15}")
print("-" * 60)
for _ in range(5):
    data = rakit_identitas("Indukan_Eko_01")
    print(f"{data['full_name']:<20} | {data['username']:<20} | {data['password']:<15}")
