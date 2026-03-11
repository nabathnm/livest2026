import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

class CustomTextFieldPill extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final String? hintText;
  final bool enabled;
  final bool hasError;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFieldPill({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.hintText,
    this.enabled = true,
    this.hasError = false,
    this.inputFormatters,
  });

  @override
  State<CustomTextFieldPill> createState() => _CustomTextFieldPillState();
}

class _CustomTextFieldPillState extends State<CustomTextFieldPill> {
  bool _obscureText = true;
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onTap() {
    _focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  String? _handleValidator(String? value) {
    if (widget.validator != null) {
      final result = widget.validator!(value);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _errorText != result) {
          setState(() => _errorText = result);
        }
      });
      return result != null ? '' : null; // trigger error border internally but hide default text
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final showRedBorder = _errorText != null || widget.hasError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: LivestTypography.bodySmMedium.copyWith(color: LivestColors.textPrimary),
        ),
        const SizedBox(height: LivestSizes.sm),

        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          onTap: _onTap,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: _handleValidator,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters,
          style: LivestTypography.bodySm.copyWith(color: LivestColors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hintText ?? widget.label,
            hintStyle: LivestTypography.bodySm.copyWith(color: LivestColors.primaryLightActive),
            prefixIcon: widget.prefixIcon, 
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: LivestColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  )
                : null,
            filled: true,
            fillColor: LivestColors.baseWhite,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: LivestSizes.md,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(90), // Pill Shape
              borderSide: const BorderSide(
                color: LivestColors.primaryLightActive,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(90),
              borderSide: BorderSide(
                color: showRedBorder ? const Color(0xFFE53935) : LivestColors.primaryLightActive,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(90),
              borderSide: BorderSide(
                color: showRedBorder ? const Color(0xFFE53935) : LivestColors.primaryNormal,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(90),
              borderSide: const BorderSide(
                color: Color(0xFFE53935),
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(90),
              borderSide: const BorderSide(
                color: Color(0xFFE53935),
                width: 1.5,
              ),
            ),
            errorStyle: const TextStyle(height: 0, fontSize: 0, color: Colors.transparent),
          ),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _errorText!,
              style: LivestTypography.captionSmSemibold.copyWith(color: const Color(0xFFE53935)),
            ),
          ),
        ]
      ],
    );
  }
}
