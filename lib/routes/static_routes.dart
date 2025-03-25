import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/static/about_us_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/static/get_started_page.dart';
import 'package:lifeblood_blood_donation_app/screens/static/privacy_policy_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/static/splash_screen.dart';

class StaticRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/intro': (context) => SplashScreen(),
    '/welcome': (context) => GetStartedPage(),
    '/about-us': (context) => AboutUsScreen(),
    '/privacy-policy': (context) => PrivacyPolicy(),
  };
}