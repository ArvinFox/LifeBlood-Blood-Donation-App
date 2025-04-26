import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/notification_model.dart';
import 'package:lifeblood_blood_donation_app/services/notification_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  // Fetch user notifications
  Future<void> fetchNotifications(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _notificationService.getUserNotifications(userId);
    } catch (e) {
      Helpers.debugPrintWithBorder("Error fetching user notifications: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create a notification
  Future<void> createNotification(NotificationModel notification) async {
    try {
      await _notificationService.createNotification(notification);
      fetchNotifications(notification.userId);
      
    } catch (e) { 
      Helpers.debugPrintWithBorder("Error creating notification: $e");
      notifyListeners();
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      final index = _notifications.indexWhere((notif) => notif.notificationId == notificationId);
      if (index != -1) {
        _notifications[index].isRead = true;
      }

      notifyListeners();

    } catch (e) {
      Helpers.debugPrintWithBorder("Error marking notification as read: $e");
      notifyListeners();
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      await _notificationService.markAllAsRead(userId);
      final index = _notifications.indexWhere((notif) => notif.notificationId == userId);
      if (index != -1) {
        _notifications[index].isRead = true;
      }

      notifyListeners();

    } catch (e) {
      Helpers.debugPrintWithBorder("Error marking all notifications as read: $e");
      notifyListeners();
    }
  }
}