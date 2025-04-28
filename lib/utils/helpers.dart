import 'dart:math';
import 'package:flutter/material.dart';

class Helpers {
  //for validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '* Required';
    }
    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (!RegExp(emailRegex).hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  //validate input fields
  static String? validateInputFields(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    } else {
      return null;
    }
  }

  // Check password strength
  static checkPasswordStrength(String password) {
    if (password.length < 6) return 'Weak Password';

    bool hasLetters = password.contains(RegExp(r'[A-Za-z]'));
    bool hasNumbers = password.contains(RegExp(r'\d'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

    if (password.length >= 6 && hasLetters && hasNumbers && hasSpecialCharacters) {
      return 'Strong Password';
    } else if (password.length >= 4 && hasLetters && hasNumbers) {
      return 'Medium Password';
    } else {
      return 'Weak Password';
    }
  }

  //error message
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  //sucess message
  static void showSucess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  static void debugPrintWithBorder(String message) {
    print("========================================");
    print(message);
    print("========================================");
  }
  
  static String generateOtp() {
    Random random = Random();
    int otp = 100000 + random.nextInt(900000);
    return otp.toString();
  }

  static TableRow buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
