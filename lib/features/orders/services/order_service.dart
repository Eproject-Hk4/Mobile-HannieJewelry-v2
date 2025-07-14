import 'package:flutter/foundation.dart';
import '../../../features/checkout/models/order_model.dart';
import '../../../features/auth/services/auth_service.dart';
import '../../../core/services/api_service.dart';

class OrderService extends ChangeNotifier {
  final AuthService _authService;
  final ApiService _apiService = ApiService();
  List<OrderModel> _orders = [];

  OrderService(this._authService);

  List<OrderModel> get orders => _orders;

  // Get the list of orders for the current user
  Future<void> fetchOrders() async {
    if (!_authService.isAuthenticated) return;

    try {
      final response = await _apiService.get('orders');
      final List<dynamic> ordersData = response['orders'];
      _orders = ordersData.map((order) => OrderModel.fromMap(order)).toList();
      notifyListeners();
    } catch (e) {
      print('Error when getting order list: $e');
      // Fallback with sample data if API fails
      _initializeSampleOrders();
    }
  }

  // Initialize sample data (only used when API fails)
  void _initializeSampleOrders() {
    _orders = [
      OrderModel(
        id: 'ORD123456',
        items: [
          OrderItem(
            productId: 'P001',
            name: '18K Gold Bracelet',
            imageUrl: 'assets/images/placeholder.png',
            price: 2500000,
            quantity: 1,
          ),
        ],
        totalAmount: 2500000,
        shippingFee: 30000,
        deliveryMethod: DeliveryMethod.delivery,
        paymentMethod: PaymentMethod.cod,
        recipientName: 'John Doe',
        recipientPhone: '0901234567',
        recipientAddress: '123 ABC Street, District 1, HCMC',
      ),
      // Add other sample orders if needed
    ];

    notifyListeners();
  }

  // Add new order
  Future<bool> addOrder(OrderModel order) async {
    if (!_authService.isAuthenticated) return false;

    try {
      final response = await _apiService.post('orders', order.toMap());
      if (response['success']) {
        final newOrder = OrderModel.fromMap(response['order']);
        _orders.add(newOrder);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error when creating order: $e');
      return false;
    }
  }

  // Get order details by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final response = await _apiService.get('orders/$orderId');
      return OrderModel.fromMap(response['order']);
    } catch (e) {
      print('Error when getting order details: $e');
      // Fallback to search in local data if API fails
      try {
        return _orders.firstWhere((order) => order.id == orderId);
      } catch (e) {
        return null;
      }
    }
  }
}