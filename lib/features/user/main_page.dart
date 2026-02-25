import 'package:flutter/material.dart';
import 'package:livest/features/user/home/pages/home_page.dart';
import 'package:livest/features/user/konsultasi/pages/konsultasi_page.dart';
import 'package:livest/features/user/pasar/pages/pasar_page.dart';
import 'package:livest/features/user/profile/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [
    HomePage(),
    PasarPage(),
    KonsultasiPage(),
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
