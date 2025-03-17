import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/models/events_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all events from Firestore
  Stream<List<DonationEvents>> getEvents() {
    return _firestore.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return DonationEvents.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
