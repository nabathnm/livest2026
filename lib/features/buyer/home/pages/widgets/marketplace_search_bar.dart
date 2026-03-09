import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSearch;

  const SearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: 'Cari ternak yang ingin kamu beli!',
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () => onSearch(controller.text),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90),
          borderSide: BorderSide(
            width: 2,
            color: LivestColors.primaryLightHover,
          ),
        ),
      ),
      onSubmitted: onSearch,
    );
  }
}
