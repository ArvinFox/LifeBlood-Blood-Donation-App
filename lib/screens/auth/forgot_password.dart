import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import '../../../components/custom_container.dart';

class ForgotPasswordScreen extends StatefulWidget {

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void _checkAndSendEmail() async {
    setState(() {
      isLoading = true;
    });

    try{
      final email = _emailController.text.trim();

      if(email.isEmpty){
        Helpers.showError(context, "Please enter your email address.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      await auth.sendPasswordResetEmail(email: email);
      Helpers.showSucess(context, "Password reset email sent successfully to $email.");
      Navigator.pushNamed(context, '/login');

    } on FirebaseAuthException catch (e){
      if (e.code == 'user-not-found') {
      Helpers.showError(context, "No user found with this email address.");
    } else {
      Helpers.showError(context, "An error occurred: ${e.message}");
    }
    } catch (e) {
      Helpers.showError(context, "An unexpected error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
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
              'Forgot Password?',
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
              'Please enter your registered email address here. You will receive a link to create a new password via email.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: CustomInputBox(
                textName: 'Email',
                hintText: 'Enter Email address',
                controller: _emailController,
                validator: Helpers.validateEmail,
              ),
            ),

            // back to login
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back to Login',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              onPressed: isLoading
                  ? null
                  : () {
                      _checkAndSendEmail();
                    },
              btnLabel: 'Continue',
              buttonChild: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.red,
                      ),
                    )
                  : null,
              cornerRadius: 15,
              btnColor: isLoading ? Color(0xFFE50F2A) : Colors.white,
              btnBorderColor: Color(0xFFE50F2A),
              labelColor: isLoading ? Colors.white : Color(0xFFE50F2A),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
