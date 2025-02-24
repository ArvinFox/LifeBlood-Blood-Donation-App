import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import '../../components/custom_container.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _verifyPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void verifyPassword(context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if (_newPasswordController.text == _verifyPasswordController.text) {
        //navigate to the login page
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        //display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Passwords are doesn't match",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black.withOpacity(0.3),
          ),
        );
      }
    } else {
      //display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 20),
            Text(
              'Forgot Password',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Image.asset('assets/images/reset_pswd.png', height: 230),
            SizedBox(height: 15),
            Text(
              'Enter your new password below...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomInputBox(
                    textName: 'Password',
                    hintText: 'Enter your new password',
                    controller: _newPasswordController,
                    hasAstricks: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password here';
                      } else if (value.length < 5) {
                        return 'Your password should have more than 5 characters.';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomInputBox(
                    textName: 'Verify Password',
                    hintText: 'Re-enter your new password',
                    controller: _verifyPasswordController,
                    hasAstricks: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter your password here';
                      } else if (value.length < 5 ) {
                        return 'Your password should have more than 5 characters.';
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                verifyPassword(context);
              },
              btnLabel: 'Reset Password',
              cornerRadius: 15,
              btnColor: Colors.white,
              btnBorderColor: Color(0xFFE50F2A),
              labelColor: Color(0xFFE50F2A),
            ),
            // LoginButton(
            //   text: 'Reset Password',
            //   onPressed: () {
            //     // Reset password button press
            //     Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => LoginScreen(),
            //       ),
            //       (route) => false,
            //     );
            //   },
            // ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
