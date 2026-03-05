import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/providers/navigation_provider.dart';
import 'package:livest/features/breader/ai/pages/ai.dart';
import 'package:livest/features/breader/home/pages/home_page.dart';
import 'package:livest/features/breader/pasar/pages/pasar_page.dart';
import 'package:livest/features/breader/profile/pages/profile_page.dart';

class BreaderMainPage extends StatelessWidget {
  const BreaderMainPage({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    PasarPage(),
    GeminiChatApp(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        return Scaffold(
          body: IndexedStack(
            index: navProvider.selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.amber,
            currentIndex: navProvider.selectedIndex,
            onTap: (index) => navProvider.setIndex(index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.store), label: "Pasar"),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: "Konsultasi",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }
}
