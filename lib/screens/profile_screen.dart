import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';
import 'package:lifeblood_blood_donation_app/components/drawer/side_drawer.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/formatters.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final ProfilePageNavigation navigation;

  const ProfileScreen({super.key, required this.navigation});

  @override
  State<ProfileScreen> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  bool isAvailable = true;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userService = UserService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final User? currentUser = auth.currentUser;

      if (currentUser != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (userProvider.user == null) {
          userProvider.fetchUser(currentUser.uid);
        }
      }
    });
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Access Restricted'),
              content:
                  const Text('This feature is only accessible for verified users.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: const Text('Ok'))
              ],
            ));
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
          content: const Text(
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomMainAppbar(
        title: 'Profile',
        showLeading: false,
        automaticallyImplyLeading: false,
      ),
      endDrawer: NavDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Profile Image
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),
              const SizedBox(height: 16),
              
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final user = userProvider.user;
                  if (user == null || user.isDonorVerified == false) {
                    return Column(
                      children: [
                        Center(
                          child: Text(user?.email ?? 'No email available.',
                              style: const TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  } else if (user.isDonorVerified == true) {
                    return Column(
                      children: [
                        Text(user.fullName!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(Formatters.formatPhoneNumber(user.contactNumber!),
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 30),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Donation Info Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE50F2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Consumer<UserProvider>(
                          builder: (context, userProvider, child) {
                        final user = userProvider.user;
                        if (user!.isDonorVerified == true) {
                          return Text(
                            "Donation Count\n${user.donationCount.toString()}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          );
                        }
                        return const Text(
                          "No Donations",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        );
                      }),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE50F2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Next Donation Date\nAfter 3 months",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Availability Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Availability Status",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final user = userProvider.user;

                      return Switch(
                        padding: const EdgeInsets.only(right: 20),
                        value: isAvailable,
                        onChanged:
                            (user != null && user.isDonorVerified == true)
                                ? (value) async {
                                    setState(() {
                                      isAvailable = value;
                                    });

                                    final currentUser = auth.currentUser;
                                    if (currentUser != null) {
                                      final userProvider =
                                          Provider.of<UserProvider>(context,
                                              listen: false);
                                      await userProvider.fetchUserAvailability(
                                          currentUser.uid, value);
                                    }
                                  }
                                : null,
                        activeColor: const Color(0xFFE50F2A),
                      );
                    },
                  ),
                ],
              ),

              const Divider(thickness: 1.2, color: Colors.grey),

              const SizedBox(height: 10),

              // Profile Options
              Consumer<UserProvider>(builder: (context, userProvider, child) {
                final isDonor = userProvider.user?.isDonorVerified ?? true;

                return Column(
                  children: [
                    _buildProfileOption(Icons.edit, 'Edit Information', () {
                      if (isDonor) {
                        Navigator.pushNamed(context, "/edit-donor-information");
                      } else {
                        showAlert(context);
                      }
                    }, enable: isDonor),
                    _buildProfileOption(Icons.vpn_key, 'Change Password', () {
                      if (isDonor) {
                        Navigator.pushNamed(context, '/update-password');
                      } else {
                        showAlert(context);
                      }
                    }, enable: true),
                    _buildProfileOption(Icons.access_time, 'Donation History',
                        () {
                      if (isDonor) {
                        Navigator.pushNamed(context, "/donation-history");
                      } else {
                        showAlert(context);
                      }
                    }, enable: true),
                    _buildProfileOption(Icons.card_giftcard, 'View Rewards',
                        () {
                      if (isDonor) {
                        Navigator.pushNamed(context, "/view-rewards");
                      } else {
                        showAlert(context);
                      }
                    }, enable: true),
                    SizedBox(height: 30),
                    _buildProfileOption(
                      Icons.exit_to_app,
                      'Logout',
                      () async {
                        showLogoutDialog(context);
                      },
                      enable: true,
                      redColor: true,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildProfileOption(IconData icon, String text, VoidCallback onTap,
    {bool enable = true, bool redColor = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: redColor ? const Color(0xFFE50F2A) : Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: ListTile(
      leading: Icon(icon, color: redColor ? Colors.white : const Color(0xFFE50F2A)),
      title: Text(text,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: redColor ? Colors.white : Colors.black)),
      onTap: onTap,
    ),
  );
}

enum ProfilePageNavigation {
  bottomNavigation,
  sideDrawer,
}
