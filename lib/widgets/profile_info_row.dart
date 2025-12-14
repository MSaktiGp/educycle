import 'package:educycle/constants/colors.dart';
import 'package:flutter/material.dart';

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon; // Opsional: Tambah ikon biar manis
  final bool isLast;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Agar rapi jika teks panjang (multi-line)
            children: [
              // 1. IKON (Opsional)
              if (icon != null) ...[
                Icon(icon, size: 20, color: AppColors.primaryBlue),
                const SizedBox(width: 12),
              ],

              // 2. LABEL (Lebar Tetap)
              // Ini kuncinya: Kita kunci lebar label agar ":" selalu lurus vertikal
              SizedBox(
                width: 110, 
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey[600], // Warna label agak pudar biar fokus ke value
                  ),
                ),
              ),

              // 3. PEMISAH
              const Text(":", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(width: 12),

              // 4. VALUE (Isi Data)
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                    height: 1.3, // Jarak antar baris jika teks panjang
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        
        // Garis Pembatas Halus
        if (!isLast)
          Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}