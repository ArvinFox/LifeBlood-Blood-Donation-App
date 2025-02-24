import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/forgot_pswd_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/home_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/signup_personal_info_screen.dart';
import '../components/login_button.dart';
import '../components/custom_container.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          // const SizedBox(height: 10),
          Center(
            child: Image.asset(
              'assets/images/login.png',
              height: 280,
            ),
          ),
          const Text(
            "Email",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter Your Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Password",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter Your Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Forgot password link
          ForgotPasswordText(),
          const SizedBox(height: 25),

          // Login button
          LoginButton(
            text: 'Login',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                (route) => false,
              );
            },
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignupPersonalInfoScreen()));
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
        ],
      ),
    );
  }
}

//statefull widget for change the forgot password text color when user tap on "forgot password"
class ForgotPasswordText extends StatefulWidget {
  const ForgotPasswordText({super.key});

  @override
  State<ForgotPasswordText> createState() => _ForgotPasswordTextState();
}

class _ForgotPasswordTextState extends State<ForgotPasswordText> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isTapped = true;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForgotPasswordScreen(),
            ),
          );
        },
        child: Text(
          'Forgot Password?',
          style:
              TextStyle(color: isTapped ? Colors.red : const Color(0xFF616161)),
        ),
      ),
    );
  }
}
