import 'package:flutter/material.dart';

enum NotificationType {
  promotion,
  order,
  system,
  news
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;
  final String? imageUrl;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
    this.imageUrl,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
    String? imageUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  IconData getIcon() {
    switch (type) {
      case NotificationType.promotion:
        return Icons.card_giftcard;
      case NotificationType.order:
        return Icons.shopping_bag;
      case NotificationType.system:
        return Icons.info;
      case NotificationType.news:
        return Icons.newspaper;
    }
  }

  Color getColor() {
    switch (type) {
      case NotificationType.promotion:
        return Colors.purple;
      case NotificationType.order:
        return Colors.blue;
      case NotificationType.system:
        return Colors.orange;
      case NotificationType.news:
        return Colors.green;
    }
  }
}