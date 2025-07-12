import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/checkout/models/order_model.dart';
import '../../../features/auth/services/auth_service.dart';

class OrderService extends ChangeNotifier {
  final AuthService _authService;
  List<OrderModel> _orders = [];

  OrderService(this._authService);

  List<OrderModel> get orders => _orders;

  // Lấy danh sách đơn hàng của người dùng hiện tại
  Future<void> fetchOrders() async {
    if (!_authService.isAuthenticated) return;

    // Trong thực tế, bạn sẽ gọi API để lấy danh sách đơn hàng
    // Đây là mô phỏng lấy dữ liệu thành công
    await Future.delayed(const Duration(seconds: 1));

    // Tạo dữ liệu mẫu
    _orders = [
      OrderModel(
        id: 'ORD123456',
        items: [
          OrderItem(
            productId: 'P001',
            name: 'Lắc tay vàng 18K',
            imageUrl: 'assets/images/placeholder.png',
            price: 2500000,
            quantity: 1,
          ),
        ],
        totalAmount: 2500000,
        shippingFee: 30000,
        deliveryMethod: DeliveryMethod.delivery,
        paymentMethod: PaymentMethod.cod,
        recipientName: 'Nguyễn Văn A',
        recipientPhone: '0901234567',
        recipientAddress: '123 Đường ABC, Quận 1, TP.HCM',
      ),
      OrderModel(
        id: 'ORD789012',
        items: [
          OrderItem(
            productId: 'P002',
            name: 'Nhẫn kim cương',
            imageUrl: 'assets/images/placeholder.png',
            price: 5000000,
            quantity: 1,
          ),
          OrderItem(
            productId: 'P003',
            name: 'Bông tai bạc',
            imageUrl: 'assets/images/placeholder.png',
            price: 800000,
            quantity: 2,
          ),
        ],
        totalAmount: 6600000,
        shippingFee: 0,
        deliveryMethod: DeliveryMethod.pickup,
        paymentMethod: PaymentMethod.bankTransfer,
        recipientName: 'Nguyễn Văn A',
        recipientPhone: '0901234567',
        recipientAddress: '',
        pickupLocation: 'Chi nhánh Quận 1',
      ),
    ];

    notifyListeners();
  }

  // Thêm đơn hàng mới
  Future<bool> addOrder(OrderModel order) async {
    if (!_authService.isAuthenticated) return false;

    // Trong thực tế, bạn sẽ gọi API để tạo đơn hàng
    // Đây là mô phỏng tạo đơn hàng thành công
    await Future.delayed(const Duration(seconds: 1));

    _orders.add(order);
    notifyListeners();
    return true;
  }

  // Lấy chi tiết đơn hàng theo ID
  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }
}