import 'package:flutter/material.dart';
import 'package:project_1/pages/login_signup.dart';
// import 'pages/address_info_page.dart';
// import 'pages/personal_info_page.dart';
// import 'pages/about_us_page.dart';
// import 'pages/login_page.dart';
// import 'pages/forgot_pswd_page.dart';
// import 'pages/enter_otp_page.dart';
// import 'pages/reset_pswd_page.dart';
// import 'pages/privacy_policy_page.dart';
// import 'pages/profile_page.dart';
// import 'package:project_1/pages/login_signup.dart';
// import 'package:project_1/pages/home_page.dart';

void main() {
  runApp(LifeBloodApp());
}

class LifeBloodApp extends StatelessWidget {
  const LifeBloodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), //Change this to see the page
    );
  }
}
