import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final NotificationPageNavigation navigation;

  const NotificationScreen({
    super.key,
    required this.navigation,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFE50F2A),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          " Notifications",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading:
            widget.navigation == NotificationPageNavigation.sideDrawer ? true : false,
        leading: widget.navigation == NotificationPageNavigation.sideDrawer
            ? CupertinoNavigationBarBackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.popAndPushNamed(context, "/home");
                },
              )
            : null,
        leadingWidth: 40,
      ),
    );
  }
}

enum NotificationPageNavigation {
  bottomNavigation,
  sideDrawer,
}
