import 'package:flutter/material.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD2D3), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 70),
              const Text(
                "Choose your role",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "below",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF444444),
                ),
              ),
              const SizedBox(height: 18),
              const Icon(Icons.arrow_downward_rounded, size: 32, color: Colors.grey),
              const SizedBox(height: 40),
      
              // Donor Card
              _roleCard(
                context,
                title: "Become a Donor",
                imagePath: "assets/images/become_donor.jpg",
                onTap: () => Navigator.pushNamed(context, "/login"),
              ),
      
              const SizedBox(height: 32),
              const Text(
                "or",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
      
              // Find Donor Card
              _roleCard(
                context,
                title: "Find a Donor",
                imagePath: "assets/images/find_donor.jpeg",
                onTap: () => Navigator.pushNamed(context, "/find-donor"),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(
    BuildContext context, {
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                imagePath,
                height: 160,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
