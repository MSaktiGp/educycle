<div align="center">

  <img src="assets/images/EduCycle_Logo.jpg" alt="EduCycle Logo" width="150" height="150">

  # EduCycle
  
  **Sistem Manajemen Peminjaman Inventaris & Ruangan (FST UNJA)**

  [![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
  [![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](./LICENSE)

  <p>
    <a href="#-tentang-proyek">Tentang</a> •
    <a href="#-fitur-unggulan">Fitur</a> •
    <a href="#-teknologi">Teknologi</a> •
    <a href="#-galeri-aplikasi">Galeri</a> •
    <a href="#-instalasi">Instalasi</a> •
    <a href="#-tim-pengembang">Tim</a>
  </p>
</div>

---

## 📖 Tentang Proyek

**EduCycle** adalah aplikasi mobile berbasis Flutter yang dirancang untuk mendigitalisasi proses peminjaman fasilitas (Ruangan) dan inventaris (Barang) di Fakultas Sains dan Teknologi, Universitas Jambi.

Aplikasi ini mengatasi masalah sistem manual (Google Form/Kertas) dengan menyediakan pengecekan stok *real-time*, validasi jadwal otomatis, dan komunikasi langsung antara Mahasiswa dan Staf Tata Usaha.

## 🚀 Fitur Unggulan

### 👨‍🎓 Untuk Mahasiswa
* **Cek Ketersediaan Real-time:** Melihat stok barang dan ruangan yang kosong saat itu juga.
* **Booking Cerdas:** Filter ruangan berdasarkan Gedung (FST A / FST B).
* **Validasi Jadwal:** Mencegah input jam selesai yang lebih awal dari jam mulai.
* **Riwayat Transparan:** Memantau status pengajuan (Pending, Disetujui, Ditolak, Selesai).
* **Detail Peminjaman:** Melihat informasi lengkap barang yang dipinjam.

### 👮 Untuk Admin / Staf TU
* **Moderasi Pengajuan:** Menyetujui atau Menolak peminjaman masuk.
* **Manajemen Stok:** CRUD (Create, Read, Update, Delete) data barang dan ruangan (via Firestore).
* **Integrasi WhatsApp:** Tombol "Hubungi via WhatsApp" otomatis muncul di detail riwayat untuk menegur peminjam yang terlambat.
* **Visualisasi Peminjam:** Melihat foto profil mahasiswa peminjam secara langsung.

## 🛠 Teknologi

* **Frontend:** Flutter (Dart)
* **State Management:** `setState` & `StreamBuilder` (Architecture MVVM friendly)
* **Backend:** Firebase
    * **Authentication:** Email/Password Login
    * **Cloud Firestore:** Database NoSQL Real-time
* **External Packages:**
    * `google_fonts` (Typography)
    * `url_launcher` (WhatsApp & Call)
    * `intl` (Date Formatting)

## 📸 Galeri Aplikasi

| Login Page | Dashboard | Peminjaman |
|:---:|:---:|:---:|
| <img src="screenshots/login.png" width="200"> | <img src="screenshots/home.png" width="200"> | <img src="screenshots/loan.png" width="200"> |

| Riwayat | Detail & WA | Admin Approval |
|:---:|:---:|:---:|
| <img src="screenshots/history.png" width="200"> | <img src="screenshots/detail.png" width="200"> | <img src="screenshots/admin.png" width="200"> |

## 💻 Instalasi (Untuk Developer)

Jika Anda ingin menjalankan *source code* ini di mesin lokal Anda:

1.  **Clone Repository**
    ```bash
    git clone [https://github.com/USERNAME_ANDA/educycle.git](https://github.com/USERNAME_ANDA/educycle.git)
    cd educycle
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Konfigurasi Firebase (PENTING)**
    * Buat project baru di Firebase Console.
    * Download `google-services.json` (Android) dan `GoogleService-Info.plist` (iOS).
    * Letakkan di folder `android/app/` dan `ios/Runner/`.
    * *(Opsional)* Gunakan `flutterfire configure` jika CLI terinstall.

4.  **Jalankan Aplikasi**
    ```bash
    flutter run
    ```

## 📱 Download APK

Untuk pengguna Android, silakan unduh versi terbaru di menu **Releases**:

[**Download EduCycle v1.0.0.apk**](https://github.com/USERNAME_ANDA/educycle/releases)

## 👥 Tim Pengembang

Proyek ini disusun untuk memenuhi tugas Pemrograman Mobile di Universitas Jambi oleh:

* **Dina Putri Chairani** (F1E123018)
* **Juliyando Akbar** (F1E123029)
* **M. Sakti Guruh Pratama** (F1E123053)
* **Azia Naura Ramadhani** (F1E123064)
* **Selvi Ayu Ramadhani** (F1E123090)

---

<div align="center">
  Copyright © 2025 EduCycle Team. All rights reserved.<br>
  Dibuat dengan ❤️ menggunakan Flutter.
</div>

