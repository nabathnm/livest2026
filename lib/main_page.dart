// import 'package:flutter/material.dart';
// import 'package:livest/features/home/pages/home_page.dart';
// import 'package:livest/features/user/konsultasi/pages/konsultasi_page.dart';
// import 'package:livest/features/user/profile/library/pages/library_page.dart';
// import 'package:livest/features/user/profile/pages/profile_page.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [HomePage(), GeminiChatApp(), ProfilePage()];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Livest")),
//       body: IndexedStack(index: _selectedIndex, children: _pages),
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: "Library"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }
