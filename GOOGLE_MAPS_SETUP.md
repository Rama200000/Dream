# Cara Setup Google Maps API

Aplikasi ini menggunakan Google Maps untuk fitur pemilihan lokasi kejadian. Ikuti langkah berikut untuk setup:

## 1. Dapatkan Google Maps API Key

1. Buka [Google Cloud Console](https://console.cloud.google.com/)
2. Buat project baru atau pilih project yang sudah ada
3. Aktifkan **Maps SDK for Android** di Library
4. Buka menu **Credentials**
5. Klik **Create Credentials** → **API Key**
6. Copy API Key yang dihasilkan

## 2. Tambahkan API Key ke Android

Edit file `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="GANTI_DENGAN_API_KEY_ANDA" />
```

**Ganti** `YOUR_API_KEY_HERE` dengan API Key yang sudah di-copy.

## 3. (Opsional) Batasi API Key

Untuk keamanan, batasi API Key agar hanya bisa digunakan oleh aplikasi Anda:

1. Di Google Cloud Console, buka menu **Credentials**
2. Klik pada API Key yang sudah dibuat
3. Di bagian **Application restrictions**, pilih **Android apps**
4. Tambahkan package name: `com.example.pelaporan_akademik`
5. Tambahkan SHA-1 certificate fingerprint (untuk mendapatkannya, jalankan):

```bash
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

## 4. Test Aplikasi

Jalankan aplikasi dan coba fitur pemilihan lokasi:
- Buka form Create Report
- Scroll ke bagian "Lokasi Kejadian"
- Klik tombol icon peta di sebelah kanan field lokasi
- Pilih lokasi di peta dengan tap atau drag marker
- Klik "Konfirmasi Lokasi"

## Troubleshooting

### Map tidak muncul / blank
- Pastikan API Key sudah benar
- Pastikan Maps SDK for Android sudah diaktifkan
- Periksa logcat untuk error message
- Coba clean dan rebuild: `flutter clean && flutter pub get`

### "This app is not authorized to use..."
- API Key restriction terlalu ketat
- Coba hapus restriction terlebih dahulu untuk testing
- Pastikan package name dan SHA-1 fingerprint sudah benar

### Permission denied
- Pastikan permission lokasi sudah ditambahkan di AndroidManifest.xml
- User harus memberikan izin lokasi saat pertama kali membuka map

## Fitur Map Location Picker

- **Tap di peta** untuk pilih lokasi
- **Drag marker** untuk pindahkan lokasi
- **My Location button** untuk ke lokasi saat ini (butuh permission)
- **Zoom controls** untuk zoom in/out
- Koordinat ditampilkan di card bawah
- Klik **Konfirmasi Lokasi** untuk simpan pilihan

Koordinat yang dipilih akan otomatis terisi di field "Lokasi Kejadian" dalam format:
```
Lat: -6.208800, Long: 106.845600
```
