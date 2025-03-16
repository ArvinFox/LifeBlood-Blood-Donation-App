import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/forgot_password.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/update_password/enter_otp_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/update_password/enter_mobile_no.dart';
import 'package:lifeblood_blood_donation_app/screens/static/get_started_page.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/login_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/update_password/reset_pswd_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/role_selection_page.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/signup/signup_address_info_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/signup/signup_medical_info_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/auth/signup/signup_personal_info_screen.dart';

class AuthRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/welcome': (context) => GetStartedPage(),
    '/select-role': (context) => RoleSelectionPage(),
    '/login': (context) => LoginScreen(),
    '/forgot-password': (context) => ForgotPasswordScreen(),
    '/signup-personal-info': (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return SignupPersonalInfoScreen(
        screenTitle: arguments?['screenTitle'] ?? 'SignupPage',
      );
    },
    '/signup-address-info': (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final personalInfo = arguments?['personalInfo']; // Get personal info from previous screen
      return SignupAddressInfoScreen(
        screenTitle: arguments?['screenTitle'] ?? 'SignupPage',
        personalInfo:personalInfo, // Pass personalInfo to the address info screen
      );
    },
    '/signup-medical-info': (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final personalInfo = arguments?['personalInfo'];
      final addressInfo = arguments?['addressInfo'];
      return SignupMedicalInfoScreen(
        screenTitle: arguments?['screenTitle'] ?? 'SignupPage',
        personalInfo: personalInfo, // Pass personalInfo
        addressInfo: addressInfo, // Pass addressInfo
      );
    },
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
