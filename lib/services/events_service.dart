import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/models/events_model.dart';

class EventWithId {
  final String id;
  final DonationEvents event;

  EventWithId({required this.id, required this.event});
}

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<EventWithId>> getEvents() async {
    try {
      // Get current date and time
      final currentDate = DateTime.now();

      QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where('date_and_time',
              isGreaterThan: currentDate) // Filter for future events
          .orderBy('date_and_time',
              descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        return EventWithId(
          id: doc.id,
          event: DonationEvents.fromFirestore(doc),
        );
      }).toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }
}