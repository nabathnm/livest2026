import 'package:flutter/widgets.dart';

class Dot extends StatefulWidget {
  final int delay;

  const Dot({required this.delay});

  @override
  State<Dot> createState() => DotState();
}

class DotState extends State<Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween(begin: 0.3, end: 1.0).animate(_controller);

    Future.delayed(Duration(milliseconds: widget.delay), () {
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 16,
        height: 16,
        decoration: const BoxDecoration(
          color: Color(0xFFC9BFB5), // sesuaikan warna
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
