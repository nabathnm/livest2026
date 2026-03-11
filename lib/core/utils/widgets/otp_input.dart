import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

class OtpInput extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final int length;

  const OtpInput({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.length = 8,
  });

  @override
  State<OtpInput> createState() => OtpInputState();
}

class OtpInputState extends State<OtpInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  int _secondsLeft = 300;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _secondsLeft = 300;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        t.cancel();
      }
    });
  }

  void restartTimer() {
    _startTimer();
    _controller.clear();
    setState(() {});
  }

  String get _timerText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onTap() {
    _focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timer
        Text(
          _timerText,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: LivestColors.textPrimary,
          ),
        ),
        const SizedBox(height: LivestSizes.lg),

        // Kotak visual + hidden TextField
        GestureDetector(
          onTap: _onTap,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Hitung ukuran kotak agar pas di layar
              const gap = 6.0;
              final boxSize =
                  ((constraints.maxWidth - (gap * (widget.length - 1))) /
                          widget.length)
                      .clamp(28.0, 52.0);

              return Stack(
                alignment: Alignment.center,
                children: [
                  // Hidden TextField — opacity hampir nol agar keyboard tetap muncul
                  Opacity(
                    opacity: 0.01,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: widget.length,
                      enableInteractiveSelection: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: boxSize * 0.5),
                      onChanged: (value) {
                        if (value.length > widget.length) {
                          _controller.text =
                              value.substring(0, widget.length);
                          _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: widget.length),
                          );
                        }
                        setState(() {});
                        widget.onChanged?.call(_controller.text);
                        if (_controller.text.length == widget.length) {
                          widget.onCompleted(_controller.text);
                        }
                      },
                    ),
                  ),

                  // Visual boxes (di atas hidden field)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.length, (i) {
                      final code = _controller.text;
                      final char = i < code.length ? code[i] : '';
                      final isCurrent = _focusNode.hasFocus &&
                          i ==
                              (code.length < widget.length
                                  ? code.length
                                  : widget.length - 1);

                      return Container(
                        margin: EdgeInsets.only(
                            right: i < widget.length - 1 ? gap : 0),
                        width: boxSize,
                        height: boxSize * 1.15,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1EBE6), // Soft beige matching design
                          borderRadius: BorderRadius.circular(12),
                          // No border, just filled background
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isCurrent && char.isEmpty ? '|' : char,
                          style: TextStyle(
                            fontSize: boxSize * 0.48,
                            fontWeight: isCurrent && char.isEmpty ? FontWeight.w300 : FontWeight.w700,
                            color: isCurrent && char.isEmpty ? LivestColors.textPrimary.withValues(alpha: 0.5) : LivestColors.textPrimary,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
