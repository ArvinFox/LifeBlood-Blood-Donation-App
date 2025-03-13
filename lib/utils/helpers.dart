import 'dart:convert';
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

  //validate DOB
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your Date of Birth';
    }
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value)) {
      return 'Invalid date format. Please use YYYY-MM-DD.';
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
}
