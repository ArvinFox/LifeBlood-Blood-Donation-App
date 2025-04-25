import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/utils/formatters.dart';
import 'package:provider/provider.dart';

class HeaderDrawer extends StatefulWidget {
  const HeaderDrawer({super.key});

  @override
  State<HeaderDrawer> createState() => _HeaderDrawerState();
}

class _HeaderDrawerState extends State<HeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
          if (userProvider.user == null || userProvider.user!.isDonorVerified == false) ...[
            Text(
              Formatters.truncateEmail(userProvider.user!.email ?? ''),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ] else ...[
            Text(
              userProvider.user!.fullName!,
              style: TextStyle(fontSize: 20, color: Colors.white)
            ),
          ],
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
