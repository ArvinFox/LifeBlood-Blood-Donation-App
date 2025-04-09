import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/reward_model.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsScreen> {
  final List<Rewards> rewards = [
    Rewards(
      rewardId: 1,
      rewardTitle: 'Free Health Checkup Package',
      createdAt: DateTime(2025, 3, 7),
      rewardPosterUrl: 'assets/images/health_package.jpg',
      rewardDescription: 'Free Health Checkup Package',
      startDate: DateTime(2025, 3, 7),
      endDate: DateTime(2025, 6, 7),
    ),
    Rewards(
      rewardId: 2,
      rewardTitle: 'Free Health Checkup Package',
      createdAt: DateTime(2025, 3, 7),
      rewardPosterUrl: 'assets/images/health_package.jpg',
      rewardDescription: 'Free Health Checkup Package',
      startDate: DateTime(2025, 3, 7),
      endDate: DateTime(2025, 6, 7),
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
              Navigator.popAndPushNamed(context, '/home_profile');
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
                    return _buildRewardCard(reward: rewards[index]);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard({required Rewards reward}) {
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reward.rewardTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(
            reward.rewardPosterUrl,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey,
              ),
              SizedBox(width: 5),
              Text(
                DateTime.now().toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
