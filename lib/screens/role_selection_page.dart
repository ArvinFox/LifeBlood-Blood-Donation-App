import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/option_card.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFD2D3),],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: OptionCard(
                  option: 'Become a Donor',
                  imgUrl: 'assets/images/become_donor.jpg',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/find-donor");
                },
                child: OptionCard(
                  option: 'Find a Donor',
                  imgUrl: 'assets/images/find_donor.jpeg',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
