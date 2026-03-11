import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Komponen dasar untuk skeleton loading (lazy loading)
/// Menggunakan flutter_animate untuk memberikan efek shimmer/pulsing yang halus.
class LivestSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;

  const LivestSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5), // Warna abu-abu terang skeleton
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRadius),
        shape: shape,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1500.ms,
          color: Colors.white.withOpacity(0.5),
        );
  }
}
