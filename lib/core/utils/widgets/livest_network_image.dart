import 'package:flutter/material.dart';
import 'package:livest/core/utils/widgets/livest_image_placeholder.dart';

class LivestNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double borderRadius;

  const LivestNetworkImage({
    super.key,
    required this.imageUrl,
    this.height = 176,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const LivestImagePlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl!,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const LivestImagePlaceholder(),
      ),
    );
  }
}
