import 'package:cloud_firestore/cloud_firestore.dart';

class DonationEvents {
  String? eventId;
  final String eventName;
  final String description;
  final String location;
  final DateTime dateAndTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DonationEvents({
    this.eventId,
    required this.eventName,
    required this.description,
    required this.location,
    required this.dateAndTime,
    this.createdAt,
    this.updatedAt,
  });

  factory DonationEvents.fromFirestore(String id, Map<String, dynamic> data) {
    return DonationEvents(
      eventId: id,
      eventName: data['event_name'] ?? '', 
      description: data['description'] ?? '', 
      location: data['location'] ?? '', 
      dateAndTime: (data['date_and_time'] as Timestamp).toDate(), 
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : null,
      updatedAt: data['updated_at'] != null ? (data['updated_at'] as Timestamp).toDate() : null, 
    );
  }
}