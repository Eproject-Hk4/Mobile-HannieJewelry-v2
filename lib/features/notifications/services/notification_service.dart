import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationService extends ChangeNotifier {
  List<NotificationModel> _notifications = [];

  NotificationService() {
    _initializeNotifications();
  }

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((notification) => !notification.isRead).length;

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
      NotificationModel(
        id: '2',
        title: 'Đơn hàng #HD123456 đã được xác nhận',
        message: 'Đơn hàng của bạn đã được xác nhận và đang được chuẩn bị',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.order,
      ),
      NotificationModel(
        id: '3',
        title: 'Bộ sưu tập mới',
        message: 'Bộ sưu tập Hannie Jewelry mùa hè 2023 đã ra mắt',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        type: NotificationType.news,
        imageUrl: 'assets/images/placeholder.png',
      ),
      NotificationModel(
        id: '4',
        title: 'Cập nhật ứng dụng',
        message: 'Phiên bản mới của ứng dụng đã sẵn sàng để cập nhật',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        type: NotificationType.system,
      ),
    ];
  }

  void markAsRead(String id, {Function? onSuccess}) {
    final index = _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
      if (onSuccess != null) {
        onSuccess();
      }
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((notification) => 
      notification.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
  }

  void clearAll() {
    _notifications = [];
    notifyListeners();
  }

  Future<void> refreshNotifications() async {
    // Trong ứng dụng thực tế, bạn sẽ gọi API để lấy thông báo mới
    // Ở đây chúng ta giả lập bằng cách đợi một chút và khởi tạo lại danh sách
    await Future.delayed(const Duration(milliseconds: 800));
    _initializeNotifications();
    notifyListeners();
  }
}