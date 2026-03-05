import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/providers/navigation_provider.dart';
import 'package:livest/features/buyer/home/pages/home_page.dart';
import 'package:livest/features/buyer/profile/pages/profile_page.dart';
import 'package:livest/features/buyer/history/pages/history_page.dart';

class BuyerMainPage extends StatelessWidget {
  const BuyerMainPage({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    HistoryPage(),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: "History",
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
