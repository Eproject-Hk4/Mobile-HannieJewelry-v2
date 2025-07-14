import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../features/auth/services/auth_service.dart';
import '../features/cart/services/cart_service.dart';
import '../features/orders/services/order_service.dart';
import '../features/notifications/services/notification_service.dart';

class AppProvider {
  static AuthService? _authService;
  
  static Future<void> init() async {
    _authService = AuthService();
    await _authService!.initialize();
  }
  
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider.value(value: _authService!),
    ChangeNotifierProvider(create: (ctx) => CartService()),
    ChangeNotifierProxyProvider<AuthService, OrderService>(
      create: (context) => OrderService(Provider.of<AuthService>(context, listen: false)),
      update: (context, auth, previous) => OrderService(auth),
    ),
    ChangeNotifierProvider(create: (_) => NotificationService()),
  ];
}