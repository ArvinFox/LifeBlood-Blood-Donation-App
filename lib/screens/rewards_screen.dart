import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/reward_card.dart';
import 'package:lifeblood_blood_donation_app/models/rewards.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsScreen> {
  final List<Rewards> rewards = [
    Rewards(
      title: 'Free Health Checkup Package',
      date: '20 Aug 2024',
      rewardImgUrl: 'assets/images/health_package.jpg',
    ),
    Rewards(
      title: 'Free Health Checkup Package',
      date: '20 Nov 2024',
      rewardImgUrl: 'assets/images/health_package.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color(0xFFE50F2A),
          title: const Text(
            'Rewards',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: CupertinoNavigationBarBackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.popAndPushNamed(context, '/profile');
            },
          )),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Rewards for Your Contributions',
                  style: TextStyle(
                    color: Color(0xFFE50F2A),
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/rewards.png',
                  height: 210,
                ),
                const SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: rewards.length,
                  itemBuilder: (context, index) {
                    return RewardCard(reward: rewards[index]);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
