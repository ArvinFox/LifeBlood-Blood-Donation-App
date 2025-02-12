import 'package:flutter/material.dart';
import 'package:project_1/pages/about_us_page.dart';
import 'package:project_1/pages/privacy_policy_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "@Username"; // To store username fetched from database

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade600,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50), // Space from the top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 26),
                  onPressed: () {
                    Navigator.pop(context); // Close the profile page
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                    width: 35), // Space between profile image and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi $username,",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "View Profile",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.white, thickness: 0.8),
          const SizedBox(height: 25),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20), // Add padding to list
              children: [
                buildMenuItem(Icons.home, "Home", context),
                buildMenuItem(Icons.search, "Find Donors", context),
                buildMenuItem(Icons.settings, "Settings", context),
                buildMenuItem(Icons.notifications, "Notifications", context),
                buildMenuItem(Icons.message, "Feedbacks", context),
                buildMenuItem(Icons.policy, "Privacy Policy", context),
                buildMenuItem(Icons.help, "Help", context),
                buildMenuItem(Icons.info, "About Us", context),
                buildMenuItem(Icons.logout, "Logout", context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        if (title == "Privacy Policy") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PrivacyPolicy()),
          );
        } else if (title == "About Us") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutUs()),
          );
        }
      },
    );
  }
}
