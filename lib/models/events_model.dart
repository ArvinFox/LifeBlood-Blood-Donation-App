import 'package:cloud_firestore/cloud_firestore.dart';

class DonationEvents {
  final String id;
  final String eventName;
  final String description;
  final String image;
  final String location;
  final DateTime dateAndTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DonationEvents({
    required this.id,
    required this.eventName,
    required this.description,
    required this.location,
    required this.dateAndTime,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory DonationEvents.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DonationEvents(
      id: doc.id,
      eventName: data['event_name'] ?? '', 
      description: data['description'] ?? '', 
      location: data['location'] ?? '', 
      image: data['image'] ?? '',
      dateAndTime: (data['date_and_time'] as Timestamp).toDate(), 
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : null,
      updatedAt: data['updated_at'] != null ? (data['updated_at'] as Timestamp).toDate() : null, 
    );
  }
}