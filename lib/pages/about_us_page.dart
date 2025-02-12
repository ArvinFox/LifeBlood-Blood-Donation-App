import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),

              // Welcome Text
              Text(
                'Welcome to LifeBlood',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
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

              // Description
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
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
