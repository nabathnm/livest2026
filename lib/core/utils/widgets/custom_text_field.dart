import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final String? hintText;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final bool hasError;

  const CustomTextField({
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
    this.inputFormatters,
    this.hasError = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onTap() {
    _focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: LivestSizes.fontSizeSm,
            fontWeight: FontWeight.w500,
            color: LivestColors.textPrimary,
          ),
        ),
        const SizedBox(height: LivestSizes.sm),

        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          onTap: _onTap,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters,
          style: const TextStyle(
            fontSize: LivestSizes.fontSizeSm,
            color: LivestColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText ?? widget.label,
            hintStyle: TextStyle(
              fontSize: LivestSizes.fontSizeSm,
              color: widget.hasError
                  ? const Color(0xFFE53935)
                  : LivestColors.primaryLightActive,
            ),
            prefixIcon: widget.prefixIcon ??
                const Icon(
                  Icons.person_outline,
                  color: LivestColors.primaryLightActive,
                  size: 20,
                ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: LivestColors.primaryLightActive,
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
              borderRadius:
                  BorderRadius.circular(LivestSizes.inputFieldRadius),
              borderSide: const BorderSide(
                color: LivestColors.primaryLightActive,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(LivestSizes.inputFieldRadius),
              borderSide: BorderSide(
                color: widget.hasError
                    ? const Color(0xFFE53935)
                    : LivestColors.primaryLightActive,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(LivestSizes.inputFieldRadius),
              borderSide: const BorderSide(
                color: LivestColors.primaryNormal,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(LivestSizes.inputFieldRadius),
              borderSide: const BorderSide(
                color: Color(0xFFE53935),
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(LivestSizes.inputFieldRadius),
              borderSide: const BorderSide(
                color: Color(0xFFE53935),
                width: 1.5,
              ),
            ),
            errorStyle: const TextStyle(
              color: Color(0xFFE53935),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}