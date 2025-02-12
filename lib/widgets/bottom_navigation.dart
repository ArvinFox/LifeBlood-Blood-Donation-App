import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CurveNavBar extends StatefulWidget {
  const CurveNavBar({super.key});

  @override
  State<CurveNavBar> createState() => _CurveNavBarState();
}

class _CurveNavBarState extends State<CurveNavBar> {
  int index = 0;
  final items = [
    const Icon(Icons.home, size: 30),
    const Icon(Icons.search, size: 30),
    const Icon(Icons.notifications, size: 30),
    const Icon(Icons.person, size: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
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
            index: index,
            onTap: (index) => setState(() => this.index = index),
          ),
        ),
      ),
    );
  }
}
