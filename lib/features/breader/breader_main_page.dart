import 'package:flutter/material.dart';
import 'package:livest/features/breader/ai/pages/ai.dart';
import 'package:livest/features/breader/home/pages/home_page.dart';
import 'package:livest/features/breader/pasar/pages/pasar_page.dart';
import 'package:livest/features/breader/profile/pages/profile_page.dart';

class BreaderMainPage extends StatefulWidget {
  const BreaderMainPage({super.key});

  @override
  State<BreaderMainPage> createState() => _BreaderMainPageState();
}

class _BreaderMainPageState extends State<BreaderMainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [
    HomePage(),
    PasarPage(),
    GeminiChatApp(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.amber,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Pasar"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Konsultasi"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
