import 'package:flutter/material.dart';
import 'package:project_1/pages/forgot_pswd_page.dart';
import 'package:project_1/pages/home_page.dart';
import '../widgets/login_button.dart';
import '../widgets/custom_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/login.png', // Image
            height: 240,
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter Your Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
          //Forgot password link
          ForgotPasswordText(),
          const SizedBox(height: 20),
          LoginButton(
            text: 'Login',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
                (route) => false,
              );
            },
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
              builder: (context) => ForgotPasswordPage(),
            ),
          );
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: isTapped ? Colors.red : Colors.grey),
        ),
      ),
    );
  }
}
