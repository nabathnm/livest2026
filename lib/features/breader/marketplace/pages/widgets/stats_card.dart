import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;

  const StatsCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: LivestColors.primaryLight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
