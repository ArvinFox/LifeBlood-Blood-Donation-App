import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feedback_model.dart';

class FeedbackService {
  final CollectionReference feedbackCollection = FirebaseFirestore.instance.collection('feedbacks');

  // Add feedback to Firestore
  Future<void> addFeedback(UserFeedback feedback) async {
    try {
      await feedbackCollection.add({
        // 'userId': feedback.userId,
        'feedbackContent': feedback.feedbackContent,
        'rating': feedback.rating,
        'createdAt': Timestamp.fromDate(feedback.createdAt),
      });
    } catch (e) {
      print("Error adding feedback: $e");
    }
  }

  // Retrieve feedback stream from Firestore
  Stream<List<UserFeedback>> getFeedbackStream() {
    return feedbackCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserFeedback(
          feedbackId: doc.id.hashCode, // Using hashCode as a temporary ID
          // userId: doc['userId'],
          feedbackContent: doc['feedbackContent'],
          rating: doc['rating'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}
