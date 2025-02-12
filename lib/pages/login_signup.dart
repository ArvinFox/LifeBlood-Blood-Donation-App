import 'package:flutter/material.dart';
import 'package:project_1/pages/login_page.dart';
import 'package:project_1/pages/personal_info_page.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/blood_logo.jpg',
              height: 180,
              width: 160,
            ),

            // Add Padding
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                        text: 'Lifebl', style: TextStyle(color: Colors.black)),
                    TextSpan(text: 'oo', style: TextStyle(color: Color(0xFFE50F2A))),
                    TextSpan(text: 'd', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40),

            // Login Button
            ElevatedButton(
              onPressed: () {
                // login functionality
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE50F2A),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 25),

            // Sign-Up Button
            ElevatedButton(
              onPressed: () {
                //sign-up functionality
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalInfoPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.red),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
            SizedBox(height: 40),

            Text(
              'Sign in with',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),

            // Social Media Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Facebook functionality
                  },
                  child: Image.asset(
                    'assets/images/facebook.png',
                    height: 48,
                    width: 48,
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    // Google functionality
                  },
                  child: Image.asset(
                    'assets/images/google.png',
                    height: 25,
                    width: 25,
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    // LinkedIn functionality
                  },
                  child: Image.asset(
                    'assets/images/linkedin.jpg',
                    height: 40,
                    width: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
