import 'package:cloud_firestore/cloud_firestore.dart';

class DonationEvents {
  final int eventId;
  final String eventName;
  final String eventPosterUrl;
  final String description;
  final DateTime createdAt;

  DonationEvents({
    required this.eventId,
    required this.eventName,
    required this.eventPosterUrl,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'eventPosterUrl': eventPosterUrl,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory DonationEvents.fromFirestore(Map<String, dynamic> data) {
    return DonationEvents(
      eventId:data['eventId'] ?? '',
      eventName: data['eventName'] ?? '',
      eventPosterUrl: data['eventPosterUrl'] ?? '',
      description: data['description'] ?? '',
      createdAt: data['createdAt'].toDate(),
    );
  }
}
