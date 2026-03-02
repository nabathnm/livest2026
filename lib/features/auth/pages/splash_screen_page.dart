import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff998573),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: LivestColors.primaryNormal,
                    shape: BoxShape.circle,
                  ),
                )
                .animate(delay: 200.ms)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(30, 30),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ),
            Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: LivestColors.baseWhite,
                    shape: BoxShape.circle,
                  ),
                )
                .animate(delay: 2000.ms)
                .scale(
                  delay: 5000.ms,
                  begin: const Offset(1, 1),
                  end: const Offset(25, 25),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                )
                .scale(
                  delay: 300.ms,
                  begin: const Offset(1, 1),
                  end: const Offset(8, 8),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                )
                .animate(delay: 300.ms)
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(25, 25),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png')
                    .animate(delay: 1100.ms)
                    .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: -0.50,
                      end: 0,
                      duration: 800.ms,
                      curve: Curves.easeOut,
                    )
                    .scale(
                      delay: 1000.ms,
                      begin: Offset(1, 1),
                      end: Offset(-20, -20),
                      curve: Curves.easeOut,
                    ),
                const SizedBox(height: 4),
                const Text(
                      "Livest",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: LivestColors.primaryNormal,
                      ),
                    )
                    .animate(delay: 1100.ms)
                    .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: 0.50,
                      end: 0,
                      duration: 800.ms,
                      curve: Curves.easeOut,
                    )
                    .scale(
                      delay: 1000.ms,
                      begin: Offset(1, 1),
                      end: Offset(-20, -20),
                      curve: Curves.easeOut,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
