import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

class LivestAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final List<Widget>? actions;

  const LivestAppbar({super.key, required this.name, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 56,
      backgroundColor: LivestColors.baseWhite,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      titleSpacing: 16,
      leadingWidth: 72,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: LivestColors.primaryLight,
            ),
            alignment: Alignment.center,
            child: Image.asset('assets/images/icon/back.png', width: 24),
          ),
        ),
      ),
      title: Text(name, style: LivestTypography.h3),
      actions: actions,
    );
  }
}
