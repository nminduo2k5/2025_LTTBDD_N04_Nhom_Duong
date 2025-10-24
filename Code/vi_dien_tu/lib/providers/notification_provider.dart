import 'package:flutter/foundation.dart';
import 'package:vi_dien_tu/models/notification.dart';
import 'package:vi_dien_tu/services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService =
      NotificationService();
  List<AppNotification> _notifications = [];

  List<AppNotification> get notifications =>
      _notifications;
  List<AppNotification> get unreadNotifications =>
      _notifications
          .where((n) => !n.isRead)
          .toList();
  int get unreadCount =>
      unreadNotifications.length;

  Future<void> fetchNotifications() async {
    try {
      _notifications = await _notificationService
          .getAllNotifications();
      notifyListeners();
    } catch (e) {
      throw Exception(
          'Failed to fetch notifications: $e');
    }
  }

  Future<void> markAsRead(
      String notificationId) async {
    try {
      await _notificationService
          .markAsRead(notificationId);
      final index = _notifications.indexWhere(
          (n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] =
            _notifications[index]
                .copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      throw Exception(
          'Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      _notifications = _notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      notifyListeners();
    } catch (e) {
      throw Exception(
          'Failed to mark all notifications as read: $e');
    }
  }

  Future<void> deleteNotification(
      String notificationId) async {
    try {
      await _notificationService
          .deleteNotification(notificationId);
      _notifications.removeWhere(
          (n) => n.id == notificationId);
      notifyListeners();
    } catch (e) {
      throw Exception(
          'Failed to delete notification: $e');
    }
  }

  Future<void> addNotification(
      AppNotification notification) async {
    try {
      final newNotification =
          await _notificationService
              .addNotification(notification);
      _notifications.insert(0, newNotification);
      notifyListeners();
    } catch (e) {
      throw Exception(
          'Failed to add notification: $e');
    }
  }

  List<AppNotification> getNotificationsByType(
      String type) {
    return _notifications
        .where((n) => n.type == type)
        .toList();
  }
}
