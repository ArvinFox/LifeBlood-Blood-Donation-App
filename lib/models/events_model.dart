import 'package:cloud_firestore/cloud_firestore.dart';

class DonationEvents {
  final String eventName;
  final String eventPosterUrl;
  final String description;
  final DateTime createdAt;

  DonationEvents({
    required this.eventName,
    required this.eventPosterUrl,
    required this.description,
    required this.createdAt,
  });

  // Convert Firestore data to DonationEvents object
  factory DonationEvents.fromFirestore(Map<String, dynamic> data) {
    return DonationEvents(
      eventName: data['eventName'] ?? '',
      eventPosterUrl: data['eventPosterUrl'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
