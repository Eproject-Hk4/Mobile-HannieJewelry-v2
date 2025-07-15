import 'package:flutter/material.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/products/screens/product_detail_screen.dart';
import '../features/cart/screens/cart_screen.dart';
import '../features/checkout/screens/checkout_screen.dart';
import '../features/checkout/screens/order_success_screen.dart';
import '../features/orders/screens/order_history_screen.dart'; // Changed import
import '../features/orders/screens/order_detail_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/info/screens/company_info_screen.dart';
import '../main.dart';
import 'app_routes.dart';
import '../features/checkout/models/order_model.dart'; // Import for OrderModel
import '../features/products/models/product_model.dart'; // Import for Product model

class AppPages {
  static const initial = Routes.SPLASH; // Changed INITIAL to initial

  static final Map<String, WidgetBuilder> routes = {
    Routes.SPLASH: (context) => const SplashScreen(),
    Routes.LOGIN: (context) => const LoginScreen(),
    Routes.HOME: (context) => const HomeScreen(),
    Routes.PRODUCT_DETAIL: (context) => ProductDetailScreen(
      productId: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['productId'] as String,
      product: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['product'] as Product?,
    ),
    Routes.CART: (context) => const CartScreen(),
    Routes.CHECKOUT: (context) => const CheckoutScreen(),
    Routes.ORDER_SUCCESS: (context) => OrderSuccessScreen(order: ModalRoute.of(context)!.settings.arguments as OrderModel),
    Routes.ORDERS: (context) => const OrderHistoryScreen(), // Changed OrdersScreen to OrderHistoryScreen
    Routes.ORDER_DETAIL: (context) => OrderDetailScreen(orderId: ModalRoute.of(context)!.settings.arguments as String),
    Routes.PROFILE: (context) => const ProfileScreen(),
    Routes.NOTIFICATIONS: (context) => const NotificationsScreen(),
    Routes.COMPANY_INFO: (context) => const CompanyInfoScreen(),
  };
}