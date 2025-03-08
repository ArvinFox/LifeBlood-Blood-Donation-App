import 'package:flutter/material.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFD2D3)],
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
                child: _buildSelectOption('Become a Donor', 'assets/images/become_donor.jpg'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/find-donor");
                },
                child:  _buildSelectOption('Find a Donor', 'assets/images/find_donor.jpeg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSelectOption(String option, String imgUrl) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.asset(
          imgUrl.toString(),
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        bottom: 10,
        right: 10,
        child: Text(
          option,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
