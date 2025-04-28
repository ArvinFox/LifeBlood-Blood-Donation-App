import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/models/reward_model.dart';

class RewardWithId {
  final String id;
  final Rewards reward;

  RewardWithId({required this.id, required this.reward});
}

class RewardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RewardWithId>> getRewards() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('rewards')
          .orderBy('start_date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return RewardWithId(
          id: doc.id,
          reward: Rewards.fromFirestore(doc),
        );
      }).toList();
    } catch (e) {
      print('Error fetching rewards: $e');
      return [];
    }
  }
}
