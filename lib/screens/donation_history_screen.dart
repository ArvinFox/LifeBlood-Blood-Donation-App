import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                return _donationHistoryCard(
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

  Widget _donationHistoryCard({required String place,required String date,required String time}){
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            color: Color(0xFFE50F2A),
          ),
          const SizedBox(width: 25), // Added space between icon and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Place: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: place,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Date: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: date,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Time: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: time,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
