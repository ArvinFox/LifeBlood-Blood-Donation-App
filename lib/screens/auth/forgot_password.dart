import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
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
  final userService = UserService();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();    
  }

  void _checkAndSendEmail() async {
    setState(() {
      isLoading = true;
    });

    try {
      final email = _emailController.text.trim();

      if (email.isEmpty) {
        Helpers.showError(context, "Please enter your email address.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      final userExists = await userService.doesUserExist(email);

      if (!userExists) {
        Helpers.showError(context, "No user found with this email address.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      await userService.sendPasswordResetEmail(email);
      Helpers.showSucess(context, "Password reset email sent successfully to $email.");
      Navigator.pushNamed(context, '/login');

    } catch (e) {
      Helpers.debugPrintWithBorder("Error sending reset email: $e");
      Helpers.showError(context, "An unexpected error occurred. Please try again later.");

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
            const SizedBox(height: 20),
            const Text(
              'Forgot Password?',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            Image.asset(
              'assets/images/forgot_pswd.png',
              height: 240,
            ),
            const SizedBox(height: 10),

            const Text(
              'Please enter your registered email address here. You will receive a link to create a new password via email.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

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
                child: const Text(
                  'Back to Login',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),

            CustomButton(
              onPressed: isLoading
                ? null
                : () => _checkAndSendEmail(),
              btnLabel: 'Continue',
              buttonChild: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.red,
                      ),
                    )
                  : null,
              cornerRadius: 15,
              btnColor: isLoading ? const Color(0xFFE50F2A) : Colors.white,
              btnBorderColor: const Color(0xFFE50F2A),
              labelColor: isLoading ? Colors.white : const Color(0xFFE50F2A),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
