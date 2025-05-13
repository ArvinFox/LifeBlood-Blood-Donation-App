import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomMainAppbar(title: 'Privacy Policy', showLeading: true),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(23.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Welcome to LifeBlood",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE50F2A),
                      ),
                    ),
                    Image.asset(
                      'assets/images/privacy_policy.png',
                      height: 250,
                    ),
                  ],
                ),
              ),

              const Text(
                "We are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our app.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              
              _buildSectionHeader("1. Information Collection"),
              _buildSectionContent([
                "Personal Information: Name, contact details, blood type, and location.",
                "Health Information: Blood donation history and eligibility status.",
                "Usage Data: Information on how you interact with the app.",
              ]),
              const SizedBox(height: 10),

              _buildSectionHeader("2. Use of Information"),
              _buildSectionContent([
                "Connect donors with recipients.",
                "Improve app functionality and user experience.",
                "Send notifications and updates related to blood donation.",
              ]),
              const SizedBox(height: 10),

              _buildSectionHeader("3. Data Storage and Security"),
              _buildSectionContent([
                "We implement robust security measures to protect your data, including encryption and access controls. Your information is stored securely on our servers and is only accessible by authorized personnel.",
              ]),
              const SizedBox(height: 10),

              _buildSectionHeader("4. Data Sharing and Disclosure"),
              _buildSectionContent([
                "We do not sell or share your personal information with third parties, except:",
                "When required by law.",
                "With trusted service providers who assist us in operating the app, under strict confidentiality agreements.",
              ]),
              const SizedBox(height: 10),

              _buildSectionHeader("5. User Rights"),
              _buildSectionContent([
                "Access your personal information.",
                "Correct any inaccuracies in your data.",
                "Request the deletion of your data.",
              ]),
              const SizedBox(height: 10),

              _buildSectionHeader("6. Cookies and Tracking Technologies"),
              _buildSectionContent([
                "We may use cookies and similar technologies to enhance your experience. You can manage your cookie preferences through your device settings.",
              ]),
              const SizedBox(height: 10),

              _buildSectionHeader("7. Changes to Privacy Policy"),
              _buildSectionContent([
                "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on our app and updating the effective date.",
              ]),
              const SizedBox(height: 10),

              _buildSectionHeader("8. Contact Information"),
              _buildSectionContent([
                "If you have any questions or concerns about our Privacy Policy, please contact us at:",
                "Email: privacy@lifebloodapp.com",
                "Phone: +123-456-7890",
              ]),
              const SizedBox(height: 20),

              const Text(
                "Thank you for trusting LifeBlood. We are dedicated to ensuring the privacy and security of your information.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSectionContent(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            "• $point",
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  }
}
