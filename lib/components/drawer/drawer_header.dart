import 'package:flutter/material.dart';

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
          Padding(
            padding: const EdgeInsets.all(10),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: AssetImage("assets/images/profile.jpg"),
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
              Navigator.pushReplacementNamed(context, '/profile');
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
