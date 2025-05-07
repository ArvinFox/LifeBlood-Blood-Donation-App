import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';

class RequestService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a request
  Future<String> createRequest(BloodRequest request) async {
    CollectionReference requests = _db.collection('requests');
    DocumentReference docRef = await requests.add(request.toFirestore());
    return docRef.id;
  }

  // Fetch blood requests
  Future<List<BloodRequest>> getBloodRequests() async {
    try {
      QuerySnapshot snapshot = await _db
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

  // Get blood request by ID
  Future<BloodRequest?> getRequestById(String requestId) async {
    try {
      DocumentSnapshot requestDoc = await _db.collection("requests").doc(requestId).get();
      if (!requestDoc.exists) return null;

      return BloodRequest.fromFirestore(requestDoc);
      
    } catch (e) {
      throw Exception("Failed to get blood request by ID: $e");
    }
  }

  // Update request status (pending/confirmed/completed)
  Future<void> updateStatus(String requestId, String property, dynamic value) async {
    try {
      await _db.collection("requests").doc(requestId).update({property: value});
    } catch (e) {
      throw Exception("Failed to update status of request [$property]: $e");
    }
  }

  // Update confirmed donors
  Future<void> updateConfirmedDonors(String requestId, String userId, String status) async {
    try {
      final BloodRequest? request = await getRequestById(requestId);
      if (request == null) return;

      List<Map<String, dynamic>> confirmedDonors = request.confirmedDonors!;

      final donorExists = confirmedDonors.any((donor) => donor['userId'] == userId);

      if (status == 'confirmed') {
        if (!donorExists && confirmedDonors.length < 3) {
          confirmedDonors.add({
            "userId": userId,
            "confirmedAt": DateTime.now(),
          });
        }
      } else {
        confirmedDonors.removeWhere((donor) => donor['userId'] == userId);
      }

      await _db.collection("requests").doc(requestId).update({
        "confirmedDonors": confirmedDonors,
      });

    } catch (e) {
      throw Exception("Failed to update confirmed donors: $e");
    }
  }
}