import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

class EmptyProductView extends StatelessWidget {
  const EmptyProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 192,
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/mascot/empty.png"),
            Text(
              textAlign: TextAlign.center,
              "Belum ada penjualan. Yuk tambah penjualan di tombol bawah ini!",
              style: LivestTypography.bodyMd.copyWith(
                color: LivestColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
