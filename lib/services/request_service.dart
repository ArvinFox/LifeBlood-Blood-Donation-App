import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';

class RequestService {
  Future<String> createRequest(BloodRequest request) async {
    CollectionReference requests = FirebaseFirestore.instance.collection('requests');
    DocumentReference docRef = await requests.add(request.toFirestore());
    return docRef.id;
  }

  // Fetch blood requests
  Future<List<BloodRequest>> getBloodRequests() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('requests')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BloodRequest.fromFirestore(doc))
          .toList();

    } catch (e) {
      throw Exception("Failed to get blood requests: $e");
    }
  }
}