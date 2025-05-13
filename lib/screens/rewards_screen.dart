import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifeblood_blood_donation_app/models/reward_model.dart';
import 'package:lifeblood_blood_donation_app/services/reward_service.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  late Future<List<RewardWithId>> _rewardFuture;
  final RewardService _rewardService = RewardService();

  @override
  void initState() {
    super.initState();
    _rewardFuture = _rewardService.getRewards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomMainAppbar(title: 'Rewards', showLeading: true),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<RewardWithId>>(
        future: _rewardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));

          } else if (snapshot.hasError) {
            Helpers.debugPrintWithBorder("Error loading rewards: ${snapshot.error}");
            return Center(child: Text('An error occurred while loading rewards. Please try again.'));

          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No rewards available.'));

          } else {
            final rewardsWithId = snapshot.data!;
            return ListView.builder(
              itemCount: rewardsWithId.length,
              itemBuilder: (context, index) {
                return _buildRewardCard(
                  rewardId: rewardsWithId[index].id,
                  reward: rewardsWithId[index].reward,
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildRewardCard({required String rewardId, required Rewards reward}) {
    final imageUrl =
        'https://lwifhyarxkcqhewdboby.supabase.co/storage/v1/object/public/rewards/$rewardId/${reward.image}';

    final startDate = DateFormat('yyyy-MM-dd').format(reward.start_date);
    final endDate = DateFormat('yyyy-MM-dd').format(reward.end_date);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Color.fromARGB(255, 240, 240, 240),
            Color.fromARGB(255, 240, 240, 240)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reward.reward_name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE50F2A),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 214, 214, 214).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),

          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Start Date : ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '$startDate',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'End Date : ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '$endDate',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50F2A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Reward Description',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            reward.description,
                            style: const TextStyle(color: Colors.black87),
                          ),
                          const SizedBox(height: 20),
                          
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const Text(
                'View Description',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
