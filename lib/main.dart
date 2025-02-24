import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/app.dart';
import 'package:lifeblood_blood_donation_app/screens/login_signup_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/privacy_policy_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LifeBlood();
  }
}
