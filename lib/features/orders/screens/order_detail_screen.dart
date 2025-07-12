import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../checkout/models/order_model.dart';
import '../services/order_service.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderService = Provider.of<OrderService>(context);
    final order = orderService.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text('Chi tiết đơn hàng'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Không tìm thấy đơn hàng'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Chi tiết đơn hàng'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trạng thái đơn hàng
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Đã giao hàng',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Đơn hàng của bạn đã được giao thành công',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Thông tin đơn hàng
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đơn hàng #${order.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Thông tin người nhận'),
                  _buildInfoRow('Họ tên', order.recipientName),
                  _buildInfoRow('Số điện thoại', order.recipientPhone),
                  if (order.deliveryMethod == DeliveryMethod.delivery)
                    _buildInfoRow('Địa chỉ', order.recipientAddress),
                  if (order.deliveryMethod == DeliveryMethod.pickup && order.pickupLocation != null)
                    _buildInfoRow('Địa điểm nhận hàng', order.pickupLocation!),
                  
                  const SizedBox(height: 16),
                  _buildSectionTitle('Phương thức giao hàng'),
                  _buildInfoRow(
                    'Phương thức',
                    order.deliveryMethod == DeliveryMethod.delivery
                        ? 'Giao tận nơi'
                        : 'Tự đến lấy',
                  ),
                  
                  const SizedBox(height: 16),
                  _buildSectionTitle('Phương thức thanh toán'),
                  _buildInfoRow(
                    'Phương thức',
                    order.paymentMethod == PaymentMethod.cod
                        ? 'Thanh toán khi nhận hàng (COD)'
                        : 'Chuyển khoản ngân hàng',
                  ),
                  
                  const SizedBox(height: 16),
                  _buildSectionTitle('Sản phẩm'),
                  ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/placeholder.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${_formatCurrency(item.price)} đ x ${item.quantity}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${_formatCurrency(item.price * item.quantity)} đ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                  
                  const Divider(),
                  _buildInfoRow('Tạm tính', '${_formatCurrency(order.totalAmount - order.shippingFee)} đ'),
                  _buildInfoRow('Phí vận chuyển', '${_formatCurrency(order.shippingFee)} đ'),
                  _buildInfoRow(
                    'Tổng cộng',
                    '${_formatCurrency(order.totalAmount)} đ',
                    valueStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                  
                  if (order.note != null && order.note!.isNotEmpty) ...[  
                    const SizedBox(height: 16),
                    _buildSectionTitle('Ghi chú'),
                    Text(order.note!),
                  ],
                  
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Xử lý mua lại
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Chức năng đang được phát triển')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Mua lại'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double price) {
    String priceString = price.toStringAsFixed(0);
    final result = StringBuffer();
    for (int i = 0; i < priceString.length; i++) {
      if ((priceString.length - i) % 3 == 0 && i > 0) {
        result.write('.');
      }
      result.write(priceString[i]);
    }
    return result.toString();
  }
}