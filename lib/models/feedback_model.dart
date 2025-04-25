import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedback {
  final String? feedbackId;
  final String userName;
  final String feedbackContent;
  final int rating;
  final DateTime createdAt;

  UserFeedback({
    this.feedbackId,
    required this.userName,
    required this.feedbackContent,
    required this.rating,
    required this.createdAt,
  });

  // Convert Firestore document to UserFeedback model
  factory UserFeedback.fromMap(Map<String, dynamic> data, String documentId) {
    return UserFeedback(
      userName: data['userName'] ?? '',
      feedbackContent: data['feedbackContent'] ?? '',
      rating: data['rating'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert UserFeedback model to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'feedbackContent': feedbackContent,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
