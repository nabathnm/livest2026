import 'package:flutter/material.dart';
import 'package:livest/core/utils/theme/theme.dart';
import 'package:livest/features/role_page.dart';

class Livest extends StatelessWidget {
  const Livest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: LivestAppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: RolePage(),
    );
  }
}
