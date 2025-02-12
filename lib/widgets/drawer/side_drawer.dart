import 'package:flutter/material.dart';
import 'package:project_1/pages/about_us_page.dart';
import 'package:project_1/pages/home_page.dart';
import 'package:project_1/pages/login_signup.dart';
import 'package:project_1/pages/privacy_policy_page.dart';
import 'package:project_1/widgets/drawer/drawer_header.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              HeaderDrawer(),
              DrawerList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget DrawerList() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //list of menu drawer
          menuItem(1, "Home", Icons.home),
          menuItem(2, "Find Donors", Icons.search),
          menuItem(3, "Settings", Icons.settings),
          menuItem(4, "Notifications", Icons.notifications),
          menuItem(5, "Feedbacks", Icons.message),
          menuItem(6, "Privacy policy", Icons.security),
          menuItem(7, "Help", Icons.help),
          menuItem(8, "About Us", Icons.info),
          menuItem(9, "Logout", Icons.logout),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            if (id == 1) {
              //to navigate home page
              navigatePage(context, DrawerSelection.home);
            } else if (id == 2) {
              //to navigate home find donors page
              navigatePage(context, DrawerSelection.search);
            } else if (id == 3) {
              //to navigate home page
              navigatePage(context, DrawerSelection.settings);
            } else if (id == 4) {
              //to navigate home page
              navigatePage(context, DrawerSelection.notifications);
            } else if (id == 5) {
              //to navigate home page
              navigatePage(context, DrawerSelection.feedbacks);
            } else if (id == 6) {
              //to navigate home page
              navigatePage(context, DrawerSelection.privacyPolicy);
            } else if (id == 7) {
              //to navigate home page
              navigatePage(context, DrawerSelection.help);
            } else if (id == 8) {
              //to navigate home page
              navigatePage(context, DrawerSelection.aboutUs);
            } else if (id == 9) {
              //to navigate home page
              navigatePage(context, DrawerSelection.logout);
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SizedBox(
            height: 38,
            child: Row(
              children: [
                Expanded(
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum DrawerSelection {
  home,
  search,
  settings,
  notifications,
  feedbacks,
  privacyPolicy,
  help,
  aboutUs,
  logout,
}

void navigatePage(BuildContext context, DrawerSelection selection) {
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        switch (selection) {
          case DrawerSelection.home:
            return HomePage();
          case DrawerSelection.search:
            return HomePage(); //find donors page
          case DrawerSelection.settings:
            return HomePage(); //settings page
          case DrawerSelection.notifications:
            return HomePage(); //notification page
          case DrawerSelection.feedbacks:
            return HomePage(); //feedback page
          case DrawerSelection.privacyPolicy:
            return PrivacyPolicy();
          case DrawerSelection.help:
            return HomePage(); //help page
          case DrawerSelection.aboutUs:
            return AboutUs();
          case DrawerSelection.logout:
            return LoginScreen();
        }
      },
    ),
  );
}
