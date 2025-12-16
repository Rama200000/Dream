# 🗄️ Cara Import Database ke XAMPP

## 📋 File yang Sudah Dibuat

- **setup_database.sql** - File SQL lengkap dengan semua tabel dan data awal

## 🚀 Langkah-langkah Import Database

### Metode 1: Menggunakan phpMyAdmin (TERMUDAH) ✅

#### Step 1: Jalankan XAMPP
1. Buka **XAMPP Control Panel**
2. Klik **Start** pada **Apache**
3. Klik **Start** pada **MySQL**
4. Tunggu hingga kedua service menyala (hijau)

#### Step 2: Buka phpMyAdmin
1. Buka browser (Chrome, Firefox, dll)
2. Ketik di address bar: `http://localhost/phpmyadmin`
3. Tekan Enter

#### Step 3: Import Database
1. Di phpMyAdmin, klik tab **"SQL"** di menu atas
2. Buka file `setup_database.sql` dengan text editor
3. **Copy seluruh isi file** (Ctrl+A lalu Ctrl+C)
4. **Paste** di kolom SQL query di phpMyAdmin
5. Scroll ke bawah dan klik tombol **"Go"** atau **"Kirim"**
6. Tunggu proses selesai (beberapa detik)
7. ✅ Selesai! Database dan semua tabel sudah dibuat

#### Verifikasi:
- Klik "pelaporan_akademik" di sidebar kiri
- Akan terlihat 10+ tabel
- Klik tabel "categories" → Browse → akan terlihat 6 kategori
- Klik tabel "users" → Browse → akan terlihat 3 user

---

### Metode 2: Import File SQL Langsung

#### Step 1: Di phpMyAdmin
1. Buka http://localhost/phpmyadmin
2. Klik tab **"Import"** di menu atas
3. Klik tombol **"Choose File"** atau **"Pilih File"**
4. Pilih file: `setup_database.sql`
5. Scroll ke bawah
6. Klik tombol **"Go"** atau **"Import"**
7. ✅ Selesai!

---

### Metode 3: Menggunakan Command Line MySQL

```bash
# Buka CMD atau PowerShell sebagai Administrator
# Ganti path sesuai lokasi XAMPP Anda

cd "D:\Pelaporan Akademik\pelaporan_akademik\admin_panel"

# Untuk XAMPP di C:\xampp
"C:\xampp\mysql\bin\mysql.exe" -u root < setup_database.sql

# Untuk XAMPP di D:\xampp
"D:\xampp\mysql\bin\mysql.exe" -u root < setup_database.sql
```

---

## 📊 Isi Database Setelah Import

### Tabel yang Dibuat (10 tabel):
1. **users** - Data pengguna (3 user sample)
2. **categories** - Kategori pelanggaran (6 kategori)
3. **reports** - Data laporan (kosong, siap terima data)
4. **cache** - Laravel cache
5. **cache_locks** - Cache locking
6. **sessions** - Laravel sessions
7. **jobs** - Laravel queue jobs
8. **job_batches** - Job batches
9. **failed_jobs** - Failed jobs log
10. **migrations** - Migration tracking

### Data Awal:

#### 6 Kategori Default:
1. Kekerasan (fas fa-fist-raised)
2. Bullying (fas fa-user-slash)
3. Pelanggaran Tata Tertib (fas fa-exclamation-triangle)
4. Penyalahgunaan Narkoba (fas fa-pills)
5. Pencurian (fas fa-mask)
6. Lainnya (fas fa-ellipsis-h)

#### 3 User Sample:
- **admin@example.com** - Admin
- **user1@example.com** - User Test 1
- **user2@example.com** - User Test 2

**Password default semua user**: `password`

---

## 🎯 Setelah Database Berhasil

### 1. Jalankan Server Laravel:
```bash
cd "D:\Pelaporan Akademik\pelaporan_akademik\admin_panel"
php artisan serve
```

### 2. Buka Admin Panel:
```
http://localhost:8000
```

### 3. Akses phpMyAdmin:
```
http://localhost/phpmyadmin
```

### 4. Cek Database:
- Buka database "pelaporan_akademik"
- Lihat tabel "categories" → harus ada 6 data
- Lihat tabel "users" → harus ada 3 data

---

## 🔧 Troubleshooting

### ❌ Error: "Access denied"
**Solusi:**
- Pastikan MySQL di XAMPP sedang running (hijau)
- Cek username di .env: harus `root`
- Cek password di .env: kosongkan jika default XAMPP

### ❌ Error: "Database already exists"
**Solusi:**
- Database sudah ada sebelumnya
- Di phpMyAdmin, klik database "pelaporan_akademik" → Operations → Drop Database
- Lalu import ulang file SQL

### ❌ MySQL tidak mau start di XAMPP
**Solusi:**
- Port 3306 mungkin dipakai aplikasi lain
- Buka XAMPP → Config (MySQL) → my.ini
- Ubah port dari 3306 ke 3307
- Restart XAMPP
- Update .env: `DB_PORT=3307`

### ❌ File SQL terlalu besar
**Solusi:**
- Jalankan via command line (Metode 3)
- Atau di phpMyAdmin → Import Settings → Increase max upload size

---

## 📌 Catatan Penting

- ✅ Database: `pelaporan_akademik`
- ✅ User MySQL: `root`
- ✅ Password MySQL: kosong (default XAMPP)
- ✅ Charset: `utf8mb4_unicode_ci`
- ✅ Engine: `InnoDB`
- ✅ Port: `3306` (default)

---

## ✅ Checklist Setup

- [ ] XAMPP sudah diinstall
- [ ] Apache & MySQL di XAMPP running (hijau)
- [ ] Database imported via phpMyAdmin
- [ ] File .env sudah dikonfigurasi (DB_CONNECTION=mysql)
- [ ] Server Laravel running (php artisan serve)
- [ ] Admin panel bisa diakses di http://localhost:8000

---

**🎉 Selamat! Database MySQL untuk XAMPP sudah siap digunakan!**
