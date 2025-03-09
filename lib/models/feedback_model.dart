import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedback {
  final int feedbackId;
  // final int userId;
  final String feedbackContent;
  final int rating;
  final DateTime createdAt;

  UserFeedback({
    required this.feedbackId,
    // required this.userId,
    required this.feedbackContent,
    required this.rating,
    required this.createdAt,
  });

  // Convert Firestore document to UserFeedback model
  factory UserFeedback.fromMap(Map<String, dynamic> data, String documentId) {
    return UserFeedback(
      feedbackId: documentId.hashCode, // Using hashCode as a temporary ID
      // userId: data['userId'] ?? 0,
      feedbackContent: data['feedbackContent'] ?? '',
      rating: data['rating'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert UserFeedback model to Firestore format
  Map<String, dynamic> toMap() {
    return {
      // 'userId': userId,
      'feedbackContent': feedbackContent,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
