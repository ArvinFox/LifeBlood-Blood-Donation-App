import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomMainAppbar(title: 'About Us', showLeading: true),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 15),

                Text(
                  'Welcome to LifeBlood',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE50F2A),
                  ),
                ),
                SizedBox(height: 20),

                // Image
                Image.asset(
                  'assets/images/about_us.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),

                Text(
                  'Your essential companion for finding blood donors with ease and efficiency. Our mission is to save lives by connecting those in need of blood with generous donors. '
                  'With LifeBlood, donors can easily register and become part of a life-saving community. Whether you’re looking to donate or need blood, our app is designed to provide quick, reliable connections to ensure timely assistance. Join us in making a difference, one drop at a time.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),

                // Social Media Links
                Text(
                  'For More Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Facebook functionality
                      },
                      child: Image.asset(
                        'assets/images/facebook.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        // Google functionality
                      },
                      child: Image.asset(
                        'assets/images/google.png',
                        height: 28,
                        width: 28,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                // Footer Text
                Text(
                  '©2025 LifeBlood. All rights reserved. Developed by Group 10 (Batch 12 UOP - NSBM)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12,color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
