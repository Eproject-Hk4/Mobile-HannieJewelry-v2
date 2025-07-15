import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../../../core/services/api_service.dart';

class NotificationService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<NotificationModel> _notifications = [];

  NotificationService() {
    fetchNotifications();
  }

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((notification) => !notification.isRead).length;

  Future<void> fetchNotifications() async {
    try {
      final response = await _apiService.get('notifications');
      // The response might be directly a List or contained in the body
      List<dynamic> notificationsData;
      
      if (response is List) {
        // If response is already a list
        notificationsData = response;
      } else if (response is Map && response.containsKey('notifications')) {
        // If response is a map with 'notifications' key
        notificationsData = response['notifications'];
      } else {
        // If response is a map but doesn't have 'notifications' key
        // Try to parse the response body directly
        notificationsData = response as List<dynamic>;
      }
      
      _notifications = notificationsData
          .map((notification) => NotificationModel.fromMap(notification))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching notifications: $e');
      // Fallback with sample data if API fails
      _initializeNotifications();
    }
  }

  void _initializeNotifications() {
    // Sample data
    _notifications = [
      NotificationModel(
        id: '1',
        title: 'Special Promotion',
        message: '20% discount on all diamond rings from June 15 to June 30',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.promotion,
        imageUrl: 'assets/images/placeholder.png',
      ),
      // Add other sample notifications if needed
    ];
  }

  Future<void> markAsRead(String id, {Function? onSuccess}) async {
    try {
      final response = await _apiService.put('notifications/$id/read', {});
      if (response['success']) {
        final index = _notifications.indexWhere((notification) => notification.id == id);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(isRead: true);
          notifyListeners();
          if (onSuccess != null) {
            onSuccess();
          }
        }
      }
    } catch (e) {
      print('Error marking as read: $e');
      // Offline fallback if API fails
      final index = _notifications.indexWhere((notification) => notification.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
        if (onSuccess != null) {
          onSuccess();
        }
      }
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await _apiService.put('notifications/read-all', {});
      if (response['success']) {
        _notifications = _notifications.map((notification) => 
          notification.copyWith(isRead: true)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error marking all as read: $e');
      // Offline fallback if API fails
      _notifications = _notifications.map((notification) => 
        notification.copyWith(isRead: true)).toList();
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final response = await _apiService.delete('notifications/$id');
      if (response['success']) {
        _notifications.removeWhere((notification) => notification.id == id);
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting notification: $e');
      // Offline fallback if API fails
      _notifications.removeWhere((notification) => notification.id == id);
      notifyListeners();
    }
  }

  Future<void> clearAll() async {
    try {
      final response = await _apiService.delete('notifications/clear-all');
      if (response['success']) {
        _notifications = [];
        notifyListeners();
      }
    } catch (e) {
      print('Error clearing all notifications: $e');
      // Offline fallback if API fails
      _notifications = [];
      notifyListeners();
    }
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }
}