import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/order_model.dart';

class QRPaymentScreen extends StatefulWidget {
  final OrderModel order;
  final String bankName;
  final String accountNumber;
  final String accountName;

  const QRPaymentScreen({
    Key? key,
    required this.order,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  }) : super(key: key);

  @override
  State<QRPaymentScreen> createState() => _QRPaymentScreenState();
}

class _QRPaymentScreenState extends State<QRPaymentScreen> {
  late String qrContent;

  @override
  void initState() {
    super.initState();
    qrContent = _generateVietQRContent();
  }

  String _generateVietQRContent() {
    // Format: bankCode|accountNumber|amount|content
    // This is a simplified format. Actual VietQR format might differ
    final formattedAmount = widget.order.totalAmount.toStringAsFixed(0);
    return "${widget.bankName}|${widget.accountNumber}|$formattedAmount|Payment for order ${widget.order.id}";
  }

  Future<void> _downloadQRCode() async {
    // Simulate download (actual saving will require plugins like path_provider, image_gallery_saver)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('QR code downloaded successfully')),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Payment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Order information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                children: [
                  _buildInfoRow('Order ID', widget.order.id),
                  const Divider(),
                  _buildInfoRow(
                    'Total Amount',
                    '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // QR Code
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                children: [
                  const Text(
                    'Scan to Pay',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  QrImageView(
                    data: qrContent,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _downloadQRCode,
                    icon: const Icon(Icons.download),
                    label: const Text('Download QR Code'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bank transfer info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bank Transfer Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCopyableInfoRow('Bank', widget.bankName),
                  const Divider(),
                  _buildCopyableInfoRow('Account Number', widget.accountNumber),
                  const Divider(),
                  _buildCopyableInfoRow('Account Name', widget.accountName),
                  const Divider(),
                  _buildCopyableInfoRow(
                    'Amount',
                    '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                  ),
                  const Divider(),
                  _buildCopyableInfoRow(
                    'Transfer Note',
                    'Payment for order ${widget.order.id}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Notes
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Please complete the payment within 24 hours after placing the order.\n'
                        '- Your order will be processed after we receive the payment.\n'
                        '- For support, contact hotline: 0345 807 906',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCopyableInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Row(
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                onPressed: () => _copyToClipboard(value),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(left: 8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
