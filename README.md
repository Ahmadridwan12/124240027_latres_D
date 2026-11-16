# Latres SI-D — Ruang Belanja

Aplikasi Flutter toko online yang mengambil produk dari
[DummyJSON Products](https://dummyjson.com/products).

## Fitur

- Login dengan username bebas dan password berupa NIM.
- Sesi login disimpan dengan Shared Preferences.
- Daftar produk dan detail produk diambil dari API.
- Jumlah produk dapat dipilih sesuai stok.
- Cart tersimpan secara lokal dengan Hive dan dipisahkan per username.
- Profile menampilkan username aktif dan menyediakan logout.

## Menjalankan aplikasi

```bash
flutter pub get
flutter run --dart-define=STUDENT_NIM=<NIM_ANDA>
```

Masukkan username pilihan sendiri dan NIM sebagai password. NIM tidak
disimpan di repository; berikan nilainya melalui `--dart-define` saat
menjalankan atau membangun aplikasi.

## Struktur folder

```text
lib/
├── data/
│   └── cart_store.dart          # Penyimpanan dan pemisahan cart per user (Hive)
├── models/
│   └── product.dart             # Model produk dan ulasan API
├── screens/
│   ├── cart_page.dart           # Daftar dan penghapusan item cart
│   ├── login_page.dart          # Form login
│   ├── product_detail_page.dart # Informasi produk dan pemilihan jumlah
│   └── shop_shell.dart          # Home, Profile, dan bottom navigation
├── services/
│   └── product_service.dart     # HTTP request ke DummyJSON
└── main.dart                    # Inisialisasi Hive, sesi, dan aplikasi
```

## Dependensi utama

- `http` untuk request API.
- `shared_preferences` untuk menyimpan sesi login.
- `hive` dan `hive_flutter` untuk penyimpanan cart lokal.
