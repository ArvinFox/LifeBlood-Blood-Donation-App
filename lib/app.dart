import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/home_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/login_signup_screen.dart';

class LifeBlood extends StatelessWidget {
  const LifeBlood({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LifeBlood",
      debugShowCheckedModeBanner: false,
      home: LoginSignupScreen(), // Change this to see the page
    );
  }
}
