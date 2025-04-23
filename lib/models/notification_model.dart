import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String userId;
  final String requestId;
  final String type;  // new_request, status_update
  bool isRead;
  final DateTime timestamp;
  final String? status; // accepted, cancelled

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.requestId,
    required this.type,
    this.isRead = false,
    required this.timestamp,
    this.status,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return NotificationModel(
      notificationId: doc.id,
      userId: data['userId'] ?? '',
      requestId: data['requestId'] ?? '',
      type: data['type'] ?? '',
      isRead: data['isRead'] ?? false,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: data['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userId": userId,
      "requestId": requestId,
      "type": type,
      "isRead": isRead,
      "timestamp": Timestamp.fromDate(timestamp),
      "status": status,
    };
  }
}