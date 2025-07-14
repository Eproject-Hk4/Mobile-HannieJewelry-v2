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
      final List<dynamic> notificationsData = response['notifications'];
      _notifications = notificationsData
          .map((notification) => NotificationModel.fromMap(notification))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Lỗi khi lấy thông báo: $e');
      // Fallback với dữ liệu mẫu nếu API lỗi
      _initializeNotifications();
    }
  }

  void _initializeNotifications() {
    // Dữ liệu mẫu
    _notifications = [
      NotificationModel(
        id: '1',
        title: 'Khuyến mãi đặc biệt',
        message: 'Giảm giá 20% cho tất cả sản phẩm nhẫn kim cương từ ngày 15/06 đến 30/06',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.promotion,
        imageUrl: 'assets/images/placeholder.png',
      ),
      // Thêm các thông báo mẫu khác nếu cần
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
      print('Lỗi khi đánh dấu đã đọc: $e');
      // Fallback xử lý offline nếu API lỗi
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
      print('Lỗi khi đánh dấu tất cả đã đọc: $e');
      // Fallback xử lý offline nếu API lỗi
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
      print('Lỗi khi xóa thông báo: $e');
      // Fallback xử lý offline nếu API lỗi
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
      print('Lỗi khi xóa tất cả thông báo: $e');
      // Fallback xử lý offline nếu API lỗi
      _notifications = [];
      notifyListeners();
    }
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }
}