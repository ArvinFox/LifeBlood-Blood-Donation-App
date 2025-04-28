import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/donor_registration.dart';
import 'package:lifeblood_blood_donation_app/screens/blood_request_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/donation_history_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/edit_user_information.dart';
import 'package:lifeblood_blood_donation_app/screens/events_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/feedback_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/main_layout_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/notification_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/profile_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/request_donors.dart';
import 'package:lifeblood_blood_donation_app/screens/rewards_screen.dart';

class UserRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/home': (context) => MainLayoutScreen(selectIndex: 0,),
    '/home_profile': (context) => MainLayoutScreen(selectIndex: 3),
    '/donor-registration': (context) => DonorRegistration(),
    '/find-donor': (context) => RequestDonors(navigation: NavigationPage.sideDrawer,),
    '/notifications': (context) => NotificationScreen(navigation: NotificationPageNavigation.sideDrawer,),
    '/profile': (context) => ProfileScreen(navigation: ProfilePageNavigation.sideDrawer,),
    '/feedback': (context) => FeedbackScreen(),
    '/donation-request': (context) => BloodRequestScreen(),
    '/events': (context) => EventsScreen(),
    '/donation-history': (context) => DonationHistoryScreen(),
    '/view-rewards': (context) => RewardsScreen(),
    '/edit-donor-information': (context) => EditUserInformation(),
  };
}
