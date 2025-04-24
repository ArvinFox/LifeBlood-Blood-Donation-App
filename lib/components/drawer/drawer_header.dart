import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final User? currentUser = auth.currentUser;
      
      if (currentUser != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if(userProvider.user == null){
          userProvider.fetchUser(currentUser.uid);
        }
      }
    });
  }

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
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final user = userProvider.user;
              if (user == null || user.isDonor == false) {
                return Text(
                  Formatters.truncateEmail(user?.email ?? ''),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                );
              } 
              return Text(
                user.fullName!,
                style: TextStyle(fontSize: 20, color: Colors.white)
              );
            },
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
