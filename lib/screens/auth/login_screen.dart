import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import '../../components/custom_container.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  void loginUser(context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      if (email == "test@gmail.com" && password == "12345") {
        //navigate to the home page
        Navigator.pushReplacementNamed(context, '/home');
        print("login sucess...");
      }
    } else {
      print("login failed..");
      //display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Login failed. Please try again using correct credentials.",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.3),
        ),
      );
    }
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email here';
    }
    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/login.png',
              height: 250,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomInputBox(
                  textName: 'Email',
                  hintText: 'Enter your Email',
                  controller: _emailController,
                  validator: validateEmail,
                ),
                CustomInputBox(
                  textName: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
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
              ],
            ),
          ),

          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/forgot-password',
                  arguments: 'forgotPassword',
                );
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Login button
          CustomButton(
            onPressed: () {
              loginUser(context);
            },
            btnLabel: 'Login',
            cornerRadius: 15,
            btnColor: Colors.white,
            btnBorderColor: Color(0xFFE50F2A),
            labelColor: Color(0xFFE50F2A),
          ),
          const SizedBox(height: 18),

          // "Don't have an account?" with "Sign Up"
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(
                  color: Color(0xFF616161),
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup-personal-info');
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
