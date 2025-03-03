import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/find_donor_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/home_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/notification_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/profile_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  final int selectIndex;

  const MainLayoutScreen({
    super.key,
    required this.selectIndex,
  });

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  final items = [
    const Icon(Icons.home, size: 30),
    const Icon(Icons.search, size: 30),
    const Icon(Icons.notifications, size: 30),
    const Icon(Icons.person, size: 30),
  ];

  final List<Widget> pages = [
    HomeScreen(),
    FindDonorScreen(navigation: NavigationPage.bottomNavigation),
    NotificationScreen(navigation: NotificationPageNavigation.bottomNavigation),
    ProfileScreen(navigation: ProfilePageNavigation.bottomNavigation),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Material(
        elevation: 5,
        child: Container(
          color: Colors.white,
          height: 76,
          child: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(color: Colors.white),
            ),
            child: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              color: Color(0xFFE50F2A),
              items: items,
              index: _currentIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
