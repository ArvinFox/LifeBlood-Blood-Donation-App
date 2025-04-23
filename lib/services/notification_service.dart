import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
import 'package:lifeblood_blood_donation_app/models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a notification
  Future<void> createNotification(NotificationModel notification) async {
    try {
      await _db.collection("notifications").doc().set(notification.toFirestore());
    } catch (e) {
      throw Exception("Failed to create notification: $e");
    }
  }

  // Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _db.collection("notifications").doc(notificationId).update({"isRead": true});
    } catch (e) {
      throw Exception("Failed to mark notification as read: $e");
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      QuerySnapshot snapshot = await _db
        .collection("notifications")
        .where("userId", isEqualTo: userId)
        .where("isRead", isEqualTo: false)
        .get();
      
      for (var doc in snapshot.docs) {
        await _db.collection("notifications").doc(doc.id).update({"isRead": true});
      }
    } catch (e) {
      throw Exception("Failed to mark all notifications as read: $e");
    }
  }

  // Get a notification by ID
  Future<NotificationModel?> getNotificationById(String notificationId) async {
    try {
      DocumentSnapshot doc = await _db.collection("notifications").doc(notificationId).get();
      if (!doc.exists) return null;

      return NotificationModel.fromFirestore(doc);
    } catch (e) {
      throw Exception("Failed to get notification by ID: $e");
    }
  }

  // Get all unread notifications for a user
  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    try {
      QuerySnapshot snapshot = await _db
        .collection("notifications")
        .where("userId", isEqualTo: userId)
        .where("isRead", isEqualTo: false)
        .orderBy("timestamp", descending: true)
        .get();

      return snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Failed to get user notifications: $e");
    }
  }

  // Get donation request details from ID
  Future<DonationRequestDetails?> getDonationRequestDetailsId(String requestId) async {
    try {
      DocumentSnapshot doc = await _db.collection("requests").doc(requestId).get();
      if (!doc.exists) return null;

      return DonationRequestDetails.fromFirestore(doc);
    } catch (e) {
      throw Exception("Failed to get donation request details by ID: $e");
    }
  }
}