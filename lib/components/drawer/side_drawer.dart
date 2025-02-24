import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/about_us_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/feedback_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/find_donor_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/home_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/login_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/privacy_policy_screen.dart';
import 'package:lifeblood_blood_donation_app/components/drawer/drawer_header.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  // Settings Dialog Box
  void showSettingsDialog(BuildContext context) {
    bool isDarkMode = false; // State for dark mode switch

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text(
                      "Dark Mode",
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Switch(
                      value: isDarkMode,
                      activeColor: const Color(0xFFE50F2A), // Red when ON
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showDeleteAccountDialog(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Delete Account Dialog Box
  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Account",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          content: const Text(
            "Are you sure you want to delete your account? This will permanently erase your account.",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    // Perform delete account action
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 30),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side:
                        const BorderSide(color: Color(0xFFE50F2A), width: 1.5),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Color(0xFFE50F2A)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Logout Dialog Box
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure, that you want to logout?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 30),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side:
                        const BorderSide(color: Color(0xFFE50F2A), width: 1.5),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Color(0xFFE50F2A)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

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
              showSettingsDialog(context);
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
              showLogoutDialog(context);
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
            return HomeScreen();
          case DrawerSelection.search:
            return FindDonorScreen(); //find donors page
          case DrawerSelection.settings:
            return HomeScreen(); //settings page
          case DrawerSelection.notifications:
            return HomeScreen(); //notification page
          case DrawerSelection.feedbacks:
            return FeedbackScreen();
          case DrawerSelection.privacyPolicy:
            return PrivacyPolicy();
          case DrawerSelection.help:
            return HomeScreen(); //help page
          case DrawerSelection.aboutUs:
            return AboutUsScreen();
          case DrawerSelection.logout:
            return LoginScreen();
        }
      },
    ),
  );
}
