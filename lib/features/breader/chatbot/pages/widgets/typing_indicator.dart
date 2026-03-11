import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.2, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval((index * 0.2), 1.0, curve: Curves.easeInOut),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD2C7BC), // Light brownish grey from screenshot
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          const Text(
            "Menyiapkan jawaban...",
            style: TextStyle(
              color: LivestColors.textSecondary,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
