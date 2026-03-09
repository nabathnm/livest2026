import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';

class LivestImagePlaceholder extends StatelessWidget {
  const LivestImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      color: LivestColors.primaryLight,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: LivestColors.primaryNormal,
        size: 48,
      ),
    );
    ;
  }
}
