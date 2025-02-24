import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/profile_screen.dart';

class HeaderDrawer extends StatefulWidget {
  const HeaderDrawer({super.key});

  @override
  State<HeaderDrawer> createState() => _HeaderDrawerState();
}

class _HeaderDrawerState extends State<HeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE50F2A),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/images/profile.jpg"),
              ),
            ),
          ),
          Text(
            "Hi @Username",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen()), // Navigate to Profile Screen
              );
            },
            child: const Text(
              "View Profile",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
