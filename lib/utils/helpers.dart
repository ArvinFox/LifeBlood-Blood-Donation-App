import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class Helpers {
  //hashed password to store in firestore databse
  String hashPassword(String password) {
    final byte = utf8.encode(password); //convert password to byte
    final hashed = sha256.convert(byte); //hashed the byte
    return hashed.toString(); //convert hashed to readable string
  }

  //for validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email here';
    }
    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (!RegExp(emailRegex).hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  //convert DOB string to DateTime
  static DateTime? setDob(String dob) {
    try {
      return DateTime.tryParse(dob);
    } catch (e) {
      return null;
    }
  }

  //validate input fields
  static String? validateInputFields(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    } else {
      return null;
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

  //password strength checker
  static checkPasswordStrength(String password){
    if(password.length < 6) return 'Weak Password';

    bool hasLetters = password.contains(RegExp(r'[A-Za-z]'));
    bool hasNumbers = password.contains(RegExp(r'\d'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

    if(password.length >= 6 && hasLetters && hasNumbers && hasSpecialCharacters){
      return 'Strong Password';
    } else if(password.length >= 4 && hasLetters && hasNumbers){
      return 'Medium Password';
    } else{
      return 'Weak Password';
    }
  }
}
