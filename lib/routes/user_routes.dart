import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/about_us_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/blood_request_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/donation_history_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/events_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/feedback_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/find_donor_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/main_layout_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/notification_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/privacy_policy_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/profile_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/rewards_screen.dart';

class UserRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/home': (context) => MainLayoutScreen(selectIndex: 0,),
    '/find-donor': (context) => FindDonorScreen(navigation: NavigationPage.sideDrawer,),
    '/notifications': (context) => NotificationScreen(navigation: NotificationPageNavigation.sideDrawer,),
    '/profile': (context) => ProfileScreen(navigation: ProfilePageNavigation.sideDrawer,),
    '/feedback': (context) => FeedbackScreen(),
    '/privacy-policy': (context) => PrivacyPolicy(),
    '/about-us': (context) => AboutUsScreen(),
    '/donation-request': (context) => BloodRequestScreen(),
    '/events': (context) => EventsScreen(),
    '/donation-history': (context) => DonationHistoryScreen(),
    '/view-rewards': (context) => RewardsScreen(),
  };
}
