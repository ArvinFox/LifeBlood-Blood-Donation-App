import 'package:cloud_firestore/cloud_firestore.dart';

class DonationHistory {
  final String donationHistoryId;
  final String? requestId;
  final String userId;
  final String place;
  final DateTime date;
  final DateTime time;

  DonationHistory({
    required this.donationHistoryId,
    this.requestId,
    required this.userId,
    required this.place,
    required this.date,
    required this.time,
  });

  factory DonationHistory.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return DonationHistory(
      donationHistoryId: doc.id,
      requestId: data['request_id'] ?? '',
      userId: data['user_id'] ?? '',
      place: data['place'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: (data['time'] as Timestamp).toDate(),
    );
  }
}