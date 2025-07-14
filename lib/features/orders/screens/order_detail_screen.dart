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
    
    return FutureBuilder<OrderModel?>(
      future: orderService.getOrderById(orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: const Text('Order Details'),
              centerTitle: true,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final order = snapshot.data;
        
        if (order == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: const Text('Order Details'),
              centerTitle: true,
            ),
            body: const Center(
              child: Text('Order not found'),
            ),
          );
        }
        
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text('Order Details'),
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
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.green,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivered',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your order has been delivered successfully',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
    
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Recipient Information'),
                      _buildInfoRow('Name', order.recipientName),
                      _buildInfoRow('Phone', order.recipientPhone),
                      if (order.deliveryMethod == DeliveryMethod.delivery)
                        _buildInfoRow('Address', order.recipientAddress),
                      if (order.deliveryMethod == DeliveryMethod.pickup && order.pickupLocation != null)
                        _buildInfoRow('Pickup Location', order.pickupLocation!),
                      
                      const SizedBox(height: 16),
                      _buildSectionTitle('Delivery Method'),
                      _buildInfoRow(
                        'Method',
                        order.deliveryMethod == DeliveryMethod.delivery
                            ? 'Home Delivery'
                            : 'Self Pickup',
                      ),
                      
                      const SizedBox(height: 16),
                      _buildSectionTitle('Payment Method'),
                      _buildInfoRow(
                        'Method',
                        order.paymentMethod == PaymentMethod.cod
                            ? 'Cash on Delivery (COD)'
                            : 'Bank Transfer',
                      ),
                      
                      const SizedBox(height: 16),
                      _buildSectionTitle('Products'),
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
                      _buildInfoRow('Subtotal', '${_formatCurrency(order.totalAmount - order.shippingFee)} đ'),
                      _buildInfoRow('Shipping Fee', '${_formatCurrency(order.shippingFee)} đ'),
                      _buildInfoRow(
                        'Total',
                        '${_formatCurrency(order.totalAmount)} đ',
                        valueStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                      
                      if (order.note != null && order.note!.isNotEmpty) ...[  
                        const SizedBox(height: 16),
                        _buildSectionTitle('Notes'),
                        Text(order.note!),
                      ],
                      
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('This feature is under development')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Buy Again'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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