import 'package:flutter/material.dart';
import 'package:project_1/pages/enter_otp_page.dart';
import '../widgets/custom_container.dart';
import '../widgets/login_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController contactNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                    builder: (context) => EnterOtpPage(),
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
