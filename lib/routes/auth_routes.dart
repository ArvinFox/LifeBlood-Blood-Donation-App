import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/forgot_password/enter_otp_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/forgot_password/forgot_pswd_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/get_started_page.dart';
import 'package:lifeblood_blood_donation_app/screens/login_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/forgot_password/reset_pswd_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/role_selection_page.dart';
import 'package:lifeblood_blood_donation_app/screens/signup/signup_address_info_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/signup/signup_medical_info_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/signup/signup_personal_info_screen.dart';

class AuthRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/welcome': (context) => GetStartedPage(),
    '/select-role': (context) => RoleSelectionPage(),
    '/login': (context) => LoginScreen(),
    '/signup-personal-info': (context) {
      final condition = ModalRoute.of(context)?.settings.arguments as String?;
      return SignupPersonalInfoScreen(
        screenTitle: condition ?? 'SignupPage',
      );
    },
    '/signup-address-info': (context) {
      final condition = ModalRoute.of(context)?.settings.arguments as String?;
      return SignupAddressInfoScreen(
        screenTitle: condition ?? 'SignupPage',
      );
    },
    '/signup-medical-info': (context) {
      final condition = ModalRoute.of(context)?.settings.arguments as String?;
      return SignupMedicalInfoScreen(
        screenTitle: condition ?? 'SignupPage',
      );
    },
    '/forgot-password': (context) {
      final condition = ModalRoute.of(context)?.settings.arguments as String?;
      return ForgotPasswordScreen(
        screenTitle: condition ?? 'forgotPassword',
      );
    },
    '/enter-otp': (context) {
      final condition = ModalRoute.of(context)?.settings.arguments as String?;
      return EnterOtpScreen(
        screenTitle: condition ?? 'forgotPassword',
      );
    },
    '/new-password': (context) {
      final condition = ModalRoute.of(context)?.settings.arguments as String?;
      return ResetPasswordScreen(
        screenTitle: condition ?? 'forgotPassword',
      );
    },
  };
}
