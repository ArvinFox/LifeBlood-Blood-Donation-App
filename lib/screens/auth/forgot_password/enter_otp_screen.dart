import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import '../../../components/custom_container.dart';

class EnterOtpScreen extends StatefulWidget {
  final String screenTitle;

  const EnterOtpScreen({
    super.key,
    required this.screenTitle,
  });

  @override
  State<EnterOtpScreen> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void verifyOtp(context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/new-password',arguments: widget.screenTitle,);
    } else {
      Helpers.showError(context, "Incorrect OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              widget.screenTitle == 'changePassword'
                ? 'Need to Change Password ?'
                : 'Forgot Password?',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Image.asset('assets/images/otp.png', height: 230),
            SizedBox(height: 20),
            Text(
              'Enter the OTP here...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: CustomInputBox(
                textName: 'OTP',
                hintText: 'Enter your OTP',
                controller: _otpController,
                hasAstricks: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  return Helpers.validateInputFields(value, 'Please enter the given OTP');
                },
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  //resend OTP
                  print("resend OTP...");
                },
                child: Text(
                  'Resend OTP',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 40),
            CustomButton(
              onPressed: () {
                verifyOtp(context);
              },
              btnLabel: 'Continue',
              cornerRadius: 15,
              btnColor: Colors.white,
              btnBorderColor: Color(0xFFE50F2A),
              labelColor: Color(0xFFE50F2A),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
