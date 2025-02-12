import 'package:flutter/material.dart';
import '../widgets/custom_container.dart';
import '../widgets/login_button.dart';

class EnterOtpPage extends StatefulWidget {
  const EnterOtpPage({super.key});

  @override
  State<EnterOtpPage> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  final TextEditingController _otpController = TextEditingController();

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
            Image.asset('assets/images/otp.png', height: 240),
            SizedBox(height: 20),
            Text(
              'Enter the OTP here...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'OTP',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 6),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                hintText: 'Enter Your OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 60),
            LoginButton(
              text: 'Continue',
              onPressed: () {
                // Send OTP when clicking continue
              },
            ),
          ],
        ),
      ),
    );
  }
}
