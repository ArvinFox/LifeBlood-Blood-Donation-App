import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final ProfilePageNavigation navigation;

  const ProfileScreen({
    super.key,
    required this.navigation,
  });

  @override
  State<ProfileScreen> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  bool isAvailable = true; // Availability toggle status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0xFFE50F2A),
          title: Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          automaticallyImplyLeading:
              widget.navigation == ProfilePageNavigation.sideDrawer
                  ? true
                  : false,
          leading: widget.navigation == ProfilePageNavigation.sideDrawer
              ? CupertinoNavigationBarBackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "/home");
                  },
                )
              : null,
          leadingWidth: 40), // Reduce space in between leading and text
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 16),

              // Profile Image
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),

              SizedBox(height: 16),
              Text("@Username",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("07XXXXXXXX", style: TextStyle(fontSize: 16)),
              SizedBox(height: 30),

              // Donation Info Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE50F2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Donation Count\n02",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE50F2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Next Donation Date\nAfter 3 months",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              // Availability Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Availability Status",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Switch(
                    padding: EdgeInsets.only(right: 20),
                    value: isAvailable,
                    onChanged: (value) {
                      setState(() {
                        isAvailable = value;
                      });
                    },
                    activeColor: Color(0xFFE50F2A),
                  ),
                ],
              ),

              Divider(thickness: 1.2, color: Colors.grey),

              SizedBox(height: 10),

              // Profile Options
              _buildProfileOption(Icons.edit, 'Edit Information', () {
                Navigator.popAndPushNamed(
                  context,
                  "/signup-personal-info",
                  arguments: 'profilePage',
                );
              }),
              _buildProfileOption(Icons.vpn_key, 'Change Password', () {
                Navigator.popAndPushNamed(
                  context,
                  "/forgot-password",
                  arguments: 'changePassword',
                );
              }),
              _buildProfileOption(Icons.access_time, 'Donation History', () {
                Navigator.popAndPushNamed(context, "/donation-history");
              }),
              _buildProfileOption(Icons.card_giftcard, 'View Rewards', () {
                Navigator.popAndPushNamed(context, "/view-rewards");
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildProfileOption(IconData icon, String text, VoidCallback onTap) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    padding: EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: ListTile(
      leading: Icon(icon, color: Color(0xFFE50F2A)),
      title: Text(text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
      onTap: onTap,
    ),
  );
}

enum ProfilePageNavigation {
  bottomNavigation,
  sideDrawer,
}
