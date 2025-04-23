import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/forgot_password.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/signup.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/update_password/enter_otp_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/update_password/enter_mobile_no.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/login_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/update_password/reset_pswd_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/role_selection_page.dart';

class AuthRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/select-role': (context) => RoleSelectionPage(),
    '/login': (context) => LoginScreen(),
    '/signup':(context) => SignupScreen(),
    '/forgot-password': (context) => ForgotPasswordScreen(),
    '/update-password': (context) => EnterMobileNumber(),
    '/enter-otp': (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final contactNumber = arguments?['contactNumber'];
      final otp = arguments?['otp'];
      return EnterOtpScreen(
        contactNumber: contactNumber, 
        otp: otp, 
      );
    },
    '/new-password': (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final contactNumber = arguments?['contactNumber'];
      return ResetPasswordScreen(
        contactNumber: contactNumber, 
      );
    },
  };
}
