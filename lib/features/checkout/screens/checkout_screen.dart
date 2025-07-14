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
    // Create a temporary OrderModel to pass into the modal
    final tempOrder = OrderModel(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      items: [], // In a real app, fetch from cart
      totalAmount: 500000, // Example total
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
        order: tempOrder, // Used for showing QR if bank transfer is selected
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery method
              const Text(
                'Delivery Method',
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
                            Text('Home Delivery'),
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
                            Text('Self Pickup'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recipient information
              if (_deliveryMethod == DeliveryMethod.delivery)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recipient Information',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => _recipientName = v,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (v) => _recipientPhone = v,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onChanged: (v) => _recipientAddress = v,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),

              // Payment method
              const Text(
                'Payment Method',
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
                                ? 'Cash on Delivery (COD)'
                                : 'Bank Transfer',
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

              // Note
              const Text(
                'Note',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Add a note for your order (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (v) => _note = v,
              ),
              const SizedBox(height: 32),

              // Place order button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Place Order',
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
    // Create and submit order
    final order = OrderModel(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      items: [], // In a real app, fetch from cart
      totalAmount: 500000, // Example total
      shippingFee: 30000,
      deliveryMethod: _deliveryMethod,
      paymentMethod: _paymentMethod,
      recipientName: _recipientName,
      recipientPhone: _recipientPhone,
      recipientAddress: _recipientAddress,
      note: _note,
    );

    if (_paymentMethod == PaymentMethod.bankTransfer) {
      // Navigate to QR code screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRPaymentScreen(
            order: order,
            bankName: 'Vietcombank',
            accountNumber: '1234567890',
            accountName: 'HANNIE JEWELRY CO., LTD',
          ),
        ),
      );
    } else {
      // Process COD order and navigate to success screen
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
