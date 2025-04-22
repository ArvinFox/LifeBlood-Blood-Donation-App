import 'package:cloud_firestore/cloud_firestore.dart';

class DonationEvents {
  final String? eventId;
  final String eventName;
  final String description;
  // final String location;
  final DateTime dateAndTime;
  final DateTime createdAt;

  DonationEvents({
    this.eventId,
    required this.eventName,
    required this.description,
    // required this.location,
    required this.dateAndTime,
    required this.createdAt,
  });

  factory DonationEvents.fromFirestore(String id, Map<String, dynamic> data) {
    return DonationEvents(
      eventId: id,
      eventName: data['event_name'] ?? '',
      description: data['description'] ?? '',
      // location: data['location'] ?? '',
      dateAndTime: (data['date_and_time'] as Timestamp).toDate(),
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }
}
