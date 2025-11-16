import 'package:educycle/constants/colors.dart';
import 'package:flutter/material.dart';

/// Widget kustom untuk menampilkan satu baris informasi profil.
/// Contoh: NIM | F1E123018
class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast; // Untuk menentukan apakah perlu ada divider di bawahnya

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Label (Contoh: NIM) - Tebal dan berwarna biru
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primaryBlue,
                ),
              ),
              // Value (Contoh: F1E123018) - Warna abu-abu yang lebih tenang
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textGray,
                ),
              ),
            ],
          ),
        ),
        // Divider hanya ditampilkan jika bukan baris terakhir
        if (!isLast)
          const Divider(
            height: 1,
            color: AppColors.borderGray,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}