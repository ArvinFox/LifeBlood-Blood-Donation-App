import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/donation_history_card.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryScreen> {
  final List<Map<String, String>> _donationHistory = [
    {
      'place': 'Base Hospital - Homagama',
      'date': '20 Aug 2024',
      'time': '09.00 AM',
    },
    {
      'place': 'Base Hospital - Homagama',
      'date': '20 Nov 2024',
      'time': '10.00 AM',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color(0xFFE50F2A),
          title: const Text(
            'Donation History',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          leading: CupertinoNavigationBarBackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.popAndPushNamed(context, '/profile');
            },
          ),
          leadingWidth: 40),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'Track your past blood donations and \nmake a difference with every drop!',
                style: TextStyle(
                  color: Color(0xFFE50F2A),
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'assets/images/about_us.png',
                height: 250, // Change the image size
              ),
              const SizedBox(height: 20),
              //to grt items form the list
              ..._donationHistory.map((donation) {
                return DonationHistoryCard(
                  place: donation['place']!,
                  date: donation['date']!,
                  time: donation['time']!,
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
