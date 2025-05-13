import 'package:cloud_firestore/cloud_firestore.dart';

class Rewards {
  final String id;
  final String reward_name;
  final String description;
  final String image;
  final DateTime start_date;
  final DateTime end_date;
  final DateTime created_at;

  Rewards({
    required this.id,
    required this.reward_name,
    required this.description,
    required this.image,
    required this.start_date,
    required this.end_date,
    required this.created_at,
  });

  factory Rewards.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Rewards(
      id: doc.id,
      reward_name: data['reward_name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      start_date: (data['start_date'] as Timestamp).toDate(),
      end_date: (data['end_date'] as Timestamp).toDate(),
      created_at: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'reward_name': reward_name,
      'description': description,
      'image': image,
      'start_date': Timestamp.fromDate(start_date),
      'end_date': Timestamp.fromDate(end_date),
      'created_at': Timestamp.fromDate(created_at),
    };
  }
}