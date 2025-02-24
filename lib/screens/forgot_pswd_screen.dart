import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/enter_otp_screen.dart';
import '../components/custom_container.dart';
import '../components/login_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordScreen> {
  final TextEditingController contactNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Forgot Password?',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.asset('assets/images/forgot_pswd.png', height: 240),
            SizedBox(height: 20),
            Text(
              'Please enter your contact number here. You will receive an OTP to create a new password via mobile number.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contact Number',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 6),
            TextField(
              controller: contactNumberController,
              decoration: InputDecoration(
                hintText: 'Enter Contact Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 60),
            LoginButton(
              text: 'Continue',
              onPressed: () {
                // Continue button press (send OTP)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnterOtpScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
