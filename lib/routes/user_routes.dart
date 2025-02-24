import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/about_us_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/blood_request_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/events_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/feedback_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/find_donor_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/main_layout_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/privacy_policy_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/profile_screen.dart';

class UserRoutes{
  static Map<String, WidgetBuilder> routes = {
    '/home' : (context) => MainLayoutScreen(),
    '/find-donor' : (context) => FindDonorScreen(),
    // 'notifications' : (context) => Notifications(),
    '/profile' : (context) => ProfileScreen(),
    '/feedback' : (context) => FeedbackScreen(),
    '/privacy-policy' : (context) => PrivacyPolicy(),
    '/about-us' : (context) => AboutUsScreen(),
    '/donation-events' : (context) => EventsScreen(),
    '/donation-requests' : (context) => BloodRequestScreen(),
    '/events' : (context) => EventsScreen(),
  };
}