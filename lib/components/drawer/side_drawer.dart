import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/screens/donate_blood_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/request_donors_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/static/about_us_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/feedback_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/home_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/login_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/main_layout_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/notification_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/static/privacy_policy_screen.dart';
import 'package:lifeblood_blood_donation_app/components/drawer/drawer_header.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:provider/provider.dart';

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

//user account delete functionality
  void deleteUser(BuildContext context) async {
    final auth = UserService();

    try {
      await auth.deleteUser();
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Account deletion failed. Please try again.",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.3),
        ),
      );
    }
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
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE50F2A), width: 1.5),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Color(0xFFE50F2A)),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    deleteUser(context);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //Logout functionality
  void logoutUser(BuildContext context) async {
    final auth = UserService();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      await auth.signOut();
      userProvider.resetUser(); // Reset user after logged out
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
      // Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Logout failed. Please try again.",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.3),
        ),
      );
    }
  }

  // Logout Dialog Box
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want to logout?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                const SizedBox(width: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    logoutUser(context);
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
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
          menuItem(2, "Request a Donor", Icons.search),
          menuItem(3, "Donate Blood", Icons.bloodtype),
          menuItem(4, "Settings", Icons.settings),
          menuItem(5, "Notifications", Icons.notifications),
          menuItem(6, "Feedbacks", Icons.message),
          menuItem(7, "Privacy policy", Icons.security),
          menuItem(8, "About Us", Icons.info),
          menuItem(9, "Help", Icons.help),
          menuItem(10, "Logout", Icons.logout),
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
              // to navigate home page
              navigatePage(context, DrawerSelection.home);
            } else if (id == 2) {
              // to navigate Request donors page
              navigatePage(context, DrawerSelection.search);
            } else if (id == 3) {
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              final isDonor = userProvider.user?.isDonorVerified ?? false;

              if (isDonor) {
                navigatePage(context, DrawerSelection.request);
              } else {
                showAlert(context);
              }
            } else if (id == 4) {
              Navigator.pop(context);
              showSettingsDialog(context);
            } else if (id == 5) {
              // to navigate notification page
              navigatePage(context, DrawerSelection.notifications);
            } else if (id == 6) {
              // to navigate feedback page
              navigatePage(context, DrawerSelection.feedbacks);
            } else if (id == 7) {
              // to navigate privacy policy page
              navigatePage(context, DrawerSelection.privacyPolicy);
            } //else if (id == 7) {
            //to navigate home page
            //navigatePage(context, DrawerSelection.help);
            //}
            else if (id == 8) {
              //to navigate home page
              navigatePage(context, DrawerSelection.aboutUs);
            } else if (id == 10) {
              Navigator.pop(context);
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

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Access Restricted'),
              content:
                  Text('This feature is only accessible for verified users.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text('Ok'))
              ],
            ));
  }

  void navigatePage(BuildContext context, DrawerSelection selection) {
    Navigator.pop(context);
    if (selection == DrawerSelection.logout) {
      showLogoutDialog(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            switch (selection) {
              case DrawerSelection.home:
                return MainLayoutScreen(selectIndex: 0);
              case DrawerSelection.search:
                return RequestDonors();
              case DrawerSelection.settings:
                return HomeScreen();
              case DrawerSelection.request:
                return BloodRequestScreen();
              case DrawerSelection.notifications:
                return NotificationScreen(
                    navigation: NotificationPageNavigation.sideDrawer);
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
  }
}

enum DrawerSelection {
  home,
  search,
  request,
  settings,
  notifications,
  feedbacks,
  privacyPolicy,
  help,
  aboutUs,
  logout,
}
