import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/constants/app_credentials.dart';
import 'package:lifeblood_blood_donation_app/models/events_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all events from Firestore
  Future<List<DonationEvents>> getEvents() async {
    try{
      final snapshot = await _firestore.collection('events').get();
      return snapshot.docs.map((doc) => DonationEvents.fromFirestore(doc.id, doc.data())).toList();
    } catch (e){
      throw Exception('Error fetching events : $e');
    }
  }

  //get image URL from supabase
  String getImageUrl(String eventId) {
    return '${AppCredentials.supabaseUrl}/storage/v1/object/public/events/$eventId/event_image_$eventId.jpg';
  }
}
