import 'package:Hannie/features/checkout/screens/qr_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../orders/services/order_service.dart';
import '../models/order_model.dart';
import '../widgets/payment_method_modal.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);
  
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DeliveryMethod _deliveryMethod = DeliveryMethod.delivery;
  PaymentMethod _paymentMethod = PaymentMethod.cod;
  String _recipientName = '';
  String _recipientPhone = '';
  String _recipientAddress = '';
  String? _note;

  void _showPaymentMethodModal() {
    // Tạo một đối tượng OrderModel tạm thời để truyền vào modal
    final tempOrder = OrderModel(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      items: [], // Trong ứng dụng thực tế, lấy từ giỏ hàng
      totalAmount: 500000, // Giả định tổng tiền
      shippingFee: 30000,
      deliveryMethod: _deliveryMethod,
      paymentMethod: _paymentMethod,
      recipientName: _recipientName,
      recipientPhone: _recipientPhone,
      recipientAddress: _recipientAddress,
      note: _note,
    );
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => PaymentMethodModal(
        onSelect: (method) {
          setState(() {
            _paymentMethod = method;
          });
        },
        order: tempOrder, // Truyền đơn hàng để hiển thị QR nếu chọn chuyển khoản
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình thức giao hàng
              const Text('Hình thức giao hàng', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _deliveryMethod = DeliveryMethod.delivery),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: _deliveryMethod == DeliveryMethod.delivery ? Colors.red : Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          color: _deliveryMethod == DeliveryMethod.delivery ? Colors.red.shade50 : Colors.white,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: const [
                            Icon(Icons.local_shipping),
                            SizedBox(height: 8),
                            Text('Giao tận nơi'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _deliveryMethod = DeliveryMethod.pickup),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: _deliveryMethod == DeliveryMethod.pickup ? Colors.red : Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          color: _deliveryMethod == DeliveryMethod.pickup ? Colors.red.shade50 : Colors.white,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: const [
                            Icon(Icons.store),
                            SizedBox(height: 8),
                            Text('Tự đến lấy'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Thông tin người nhận
              if (_deliveryMethod == DeliveryMethod.delivery)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thông tin người nhận hàng', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Họ tên',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => _recipientName = v,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Số điện thoại',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (v) => _recipientPhone = v,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Địa chỉ',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onChanged: (v) => _recipientAddress = v,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              
              // Phương thức thanh toán
              const Text('Phương thức thanh toán', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _showPaymentMethodModal,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _paymentMethod == PaymentMethod.cod
                                ? Icons.payments_outlined
                                : Icons.account_balance_outlined,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _paymentMethod == PaymentMethod.cod
                                ? 'Thanh toán khi nhận hàng (COD)'
                                : 'Chuyển khoản ngân hàng',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Ghi chú
              const Text('Ghi chú', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Nhập ghi chú cho đơn hàng (nếu có)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (v) => _note = v,
              ),
              const SizedBox(height: 32),
              
              // Nút đặt hàng
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Xử lý đặt hàng
                    _placeOrder();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Đặt hàng',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _placeOrder() {
    // Tạo đơn hàng và xử lý
    final order = OrderModel(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      items: [], // Trong ứng dụng thực tế, lấy từ giỏ hàng
      totalAmount: 500000, // Giả định tổng tiền
      shippingFee: 30000,
      deliveryMethod: _deliveryMethod,
      paymentMethod: _paymentMethod,
      recipientName: _recipientName,
      recipientPhone: _recipientPhone,
      recipientAddress: _recipientAddress,
      note: _note,
    );
    
    // Nếu chọn chuyển khoản, hiển thị màn hình QR
    if (_paymentMethod == PaymentMethod.bankTransfer) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRPaymentScreen(
            order: order,
            bankName: 'Vietcombank',
            accountNumber: '1234567890',
            accountName: 'CÔNG TY TNHH HUY THANH',
          ),
        ),
      );
    } else {
      // Xử lý đơn hàng COD và chuyển đến màn hình thành công
      // Thêm đơn hàng vào OrderService
      final orderService = Provider.of<OrderService>(context, listen: false);
      orderService.addOrder(order).then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessScreen(order: order),
          ),
        );
      });
    }
  }
}