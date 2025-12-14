import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';
import 'package:educycle/widgets/navbar.dart';
import '../models/user_model.dart';

// Import halaman-halaman tujuan (Sesuaikan dengan nama file Anda)
import 'peminjaman/peminjaman_barang_page.dart';
import 'peminjaman/peminjaman_ruangan.dart';
import 'riwayat.dart';
import 'peminjaman/status_peminjaman_page.dart';
import 'staf/konfirmasi.dart';
import 'staf/kelola_stok_page.dart';

class HomePage extends StatefulWidget {
  final UserModel user; // Wajib menerima data user

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Getter pintas untuk cek role
    String nimDisplay = widget.user.email.split('@')[0].toUpperCase();
    final bool isStaff = widget.user.isStaff;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // APP BAR
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hilangkan tombol back default
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'EduCycle',
          style: TextStyle(
            color: Color(0xFFF59E0B), // Warna Orange sesuai desain lama
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.5,
          ),
        ),
      ),

      // BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SECTION SAMBUTAN (Dinamis sesuai User)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryBlue, Colors.blue.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          widget.user.photoUrl != null &&
                              widget.user.photoUrl!.isNotEmpty
                          ? NetworkImage(widget.user.photoUrl!)
                          : null,
                      // If needed, show initial as fallback (will be hidden when image present)
                      child:
                          (widget.user.photoUrl == null ||
                              widget.user.photoUrl!.isEmpty)
                          ? Text(
                              widget.user.fullName.isNotEmpty
                                  ? widget.user.fullName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jumpa Lagi,\n${widget.user.fullName}', // Nama Dinamis
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            nimDisplay,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            isStaff ? 'Staf Tata Usaha' : 'Mahasiswa',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 2. GRID MENU (Dinamis sesuai Role)
              const Text(
                'Layanan Utama',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),

              // Grid Layout
              Center(
                // 1. Tambahkan Center di sini
                child: Wrap(
                  spacing:
                      20, // (Opsional) Perbesar sedikit jarak horizontal biar lega
                  runSpacing: 20,
                  alignment: WrapAlignment.center, // 2. Ubah jadi center
                  children: [
                    // ... (Daftar tombol _buildMenuButton biarkan tetap sama) ...
                    // Copy-paste tombol-tombol dari kode lama Anda di sini

                    // MENU UMUM
                    _buildMenuButton(
                      icon: Icons.inventory_2_outlined,
                      label: 'Peminjaman\nBarang',
                      color: Colors.white,
                      iconColor: AppColors.primaryBlue,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PeminjamanBarangPage(user: widget.user),
                        ),
                      ),
                    ),
                    _buildMenuButton(
                      icon: Icons.meeting_room_outlined,
                      label: 'Peminjaman\nRuangan',
                      color: Colors.white,
                      iconColor: AppColors.secondaryOrange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PeminjamanRuangan(user: widget.user),
                        ),
                      ),
                    ),
                    _buildMenuButton(
                      icon: Icons.history,
                      label: 'Riwayat\nPeminjaman',
                      color: Colors.white,
                      iconColor: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RiwayatPage(user: widget.user),
                        ),
                      ),
                    ),

                    // MENU KHUSUS (Logic If-Else)
                    if (isStaff) ...[
                      _buildMenuButton(
                        icon: Icons.verified_user_outlined,
                        label: 'Konfirmasi\nPeminjaman',
                        color: Colors.red.shade50,
                        iconColor: Colors.red,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KonfirmasiPage(),
                          ),
                        ),
                      ),
                      _buildMenuButton(
                        icon: Icons.settings_input_component,
                        label: 'Kelola\nStok',
                        color: Colors.red.shade50,
                        iconColor: Colors.purple,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KelolaStokPage(),
                          ),
                        ),
                      ),
                    ] else ...[
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Pass user data ke Navbar jika navbar butuh data profil
      bottomNavigationBar: CustomBottomNav(currentIndex: 0, user: widget.user),
    );
  }

  // Widget Helper untuk Tombol Menu (Sama seperti desain lama Anda)
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required Color color,
    Color iconColor = Colors.black,
    VoidCallback? onTap,
  }) {
    // Menggunakan LayoutBuilder agar responsif terhadap lebar layar
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 100, // Ukuran tetap agar rapi di Wrap
        height: 110,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
