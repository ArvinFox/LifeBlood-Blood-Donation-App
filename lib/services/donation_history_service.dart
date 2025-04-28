import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/models/donation_history_model.dart';

class DonationHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get donation history of user
  Future<List<DonationHistory>> getDonationHistoryOfUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
        .collection("donation_history")
        .where("user_id", isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

      return snapshot.docs.map((doc) => DonationHistory.fromFirestore(doc)).toList();

    } catch (e) {
      throw Exception("Failed to fetch donation history of user: $e");
    }
  }
}