import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD2D3), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  "assets/images/get_started.jpg",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: "Welcome to ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                    ),
                  ),
                  TextSpan(
                    text: "LifeBlood! \n",
                    style: TextStyle(
                      color: Color(0xFFE50F2A),
                      fontSize: 26,
                    ),
                  ),
                  TextSpan(
                    text:
                        "Join a community of heroes who save  lives every day. Find blood donors, and track your donation history with easy.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                    ),
                  ),
                ]),
              ),
              //get started button
              CustomButton(
                btnLabel: 'Get Started',
                cornerRadius: 100,
                onPressed: () {
                  Navigator.pushNamed(context, "/select-role");
                },
                btnColor: Colors.white,
                btnBorderColor: Colors.red, 
                labelColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
