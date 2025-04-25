import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';

class RequestService {
  Future<void> createRequest(BloodRequest request) async {
    CollectionReference requests = FirebaseFirestore.instance.collection('requests');
    await requests.add(request.toFirestore());
  }
}