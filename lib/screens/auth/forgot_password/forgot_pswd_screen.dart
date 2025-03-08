import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import '../../../components/custom_container.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String screenTitle;

  const ForgotPasswordScreen({
    super.key,
    required this.screenTitle,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordScreen> {
  final TextEditingController _contactNumberController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void getOtp(context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      //navigate to the enter OTP page
      Navigator.pushReplacementNamed(context, '/enter-otp',arguments: widget.screenTitle,);
    } else {
      //display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Incorrect Contact number.",
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
            SizedBox(height: 10),
            Image.asset(
              'assets/images/forgot_pswd.png',
              height: 240,
            ),
            SizedBox(height: 10),
            Text(
              'Please enter your contact number here. You will receive an OTP to create a new password via mobile number.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: CustomInputBox(
                textName: 'Contact Number',
                hintText: 'Enter Contact Number',
                controller: _contactNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter your contact number';
                  } else if (value.length != 10) {
                    return 'Contact number length should 10';
                  } else {
                    return null;
                  }
                },
              ),
            ),

            // back to login
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  widget.screenTitle == 'changePassword'
                ? Navigator.popAndPushNamed(context, '/profile')
                : Navigator.popAndPushNamed(context, '/login');
                  
                },
                child: Text(
                  widget.screenTitle == 'changePassword'
                ? 'Back to Profile'
                : 'Back to Login',
                  
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              onPressed: () {
                getOtp(context);
              },
              btnLabel: 'Continue',
              cornerRadius: 15,
              btnColor: Colors.white,
              btnBorderColor: Color(0xFFE50F2A),
              labelColor: Color(0xFFE50F2A),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
