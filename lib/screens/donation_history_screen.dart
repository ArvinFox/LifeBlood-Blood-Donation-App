import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';
import 'package:lifeblood_blood_donation_app/models/donation_history_model.dart';
import 'package:lifeblood_blood_donation_app/providers/donation_history_provider.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user!.userId;

      Provider.of<DonationHistoryProvider>(context, listen: false)
        .fetchDonationHistory(userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomMainAppbar(title: 'Donation History', showLeading: true),
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
                height: 220,
              ),
              
              Consumer<DonationHistoryProvider>(
                builder: (context, historyProvider, _) {
                  if (historyProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.red));
                  }

                  final List<DonationHistory> donationHistory = historyProvider.donationHistory;

                  if (donationHistory.isEmpty) {
                    return const Center(child: Text('No donation history available.'));
                  }

                  return Column(
                    children: donationHistory.map((donation) {
                      return _donationHistoryCard(
                        place: donation.place,
                        date: DateFormat('dd MMM yyyy').format(donation.date),
                        time: DateFormat('hh:mm a').format(donation.time),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _donationHistoryCard({
    required String place,
    required String date,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF1F1), Color.fromARGB(255, 255, 232, 232)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 3,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.bloodtype_rounded,
            color: Color(0xFFE50F2A),
            size: 30,
          ),
        ),
        title: Text(
          place,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date: $date",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Time: $time",
                style: const TextStyle(
                  fontSize: 13,
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
