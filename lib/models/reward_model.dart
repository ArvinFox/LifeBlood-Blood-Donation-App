import 'package:cloud_firestore/cloud_firestore.dart';

class Rewards {
  final int rewardId;
  final String rewardTitle;
  final String rewardDescription;
  final String rewardPosterUrl;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  Rewards(
      {required this.rewardId,
      required this.rewardTitle,
      required this.rewardDescription,
      required this.rewardPosterUrl,
      required this.startDate,
      required this.endDate,
      required this.createdAt});

  Map<String, dynamic> toFirestore() {
    return {
      'rewardId': rewardId,
      'rewardTitle': rewardTitle,
      'rewardDescription': rewardDescription,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Rewards.fromFirestore(Map<String, dynamic> data) {
    return Rewards(
      rewardId: data['rewardId'],
      rewardTitle: data['rewardTitle'],
      rewardDescription: data['rewardDescription'],
      rewardPosterUrl: data['rewardPosterUrl'],
      startDate: data['startDate'].toDate(),
      endDate:data['endDate'].toDate(),
      createdAt: data['createdAt'].todate()
    );
  }
}
