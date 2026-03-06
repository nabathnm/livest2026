import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/models/nav_item_data_model.dart';
import 'package:livest/features/buyer/home/pages/home_page.dart';
import 'package:livest/features/buyer/profile/pages/profile_page.dart';
import 'package:livest/features/buyer/history/pages/history_page.dart';

class BuyerMainPage extends StatefulWidget {
  const BuyerMainPage({super.key});

  @override
  State<BuyerMainPage> createState() => _BuyerMainPageState();
}

class _BuyerMainPageState extends State<BuyerMainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [HomePage(), HistoryPage(), ProfilePage()];

  final List<NavItemDataModel> _navItems = const [
    NavItemDataModel(
      activeIcon: 'assets/images/icon/berandaactive.png',
      inactiveIcon: 'assets/images/icon/beranda.png',
      label: 'Beranda',
    ),
    NavItemDataModel(
      activeIcon: 'assets/images/icon/keranjangactive.png',
      inactiveIcon: 'assets/images/icon/keranjang.png',
      label: 'Keranjang',
    ),
    NavItemDataModel(
      activeIcon: 'assets/images/icon/profilactive.png',
      inactiveIcon: 'assets/images/icon/profil.png',
      label: 'Profil',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          width: 412,
          height: 112,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: LivestColors.baseWhite,
              currentIndex: _selectedIndex,
              selectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: LivestColors.primaryNormal,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isActive = _selectedIndex == index;

                return BottomNavigationBarItem(
                  label: "",
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background container
                      AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: 80,
                            width: 80,
                            decoration: isActive
                                ? BoxDecoration(
                                    color: LivestColors.primaryLight,
                                    borderRadius: BorderRadius.circular(32),
                                  )
                                : BoxDecoration(
                                    color: LivestColors.baseWhite,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                          )
                          .animate(target: isActive ? 1 : 0)
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.0, 1.0),
                            duration: 300.ms,
                            curve: Curves.easeOutBack,
                          ),

                      // Icon + Label
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            isActive ? item.activeIcon : item.inactiveIcon,
                            height: 28,
                            width: 28,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isActive
                                  ? LivestColors.primaryNormal
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
