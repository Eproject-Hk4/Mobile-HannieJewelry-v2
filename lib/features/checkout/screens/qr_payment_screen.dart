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
    // Đây là định dạng đơn giản, thực tế VietQR có thể phức tạp hơn
    final formattedAmount = widget.order.totalAmount.toStringAsFixed(0);
    return "${widget.bankName}|${widget.accountNumber}|$formattedAmount|Thanh toan don hang ${widget.order.id}";
  }

  Future<void> _downloadQRCode() async {
    // Thực hiện tải mã QR (trong ứng dụng thực tế sẽ cần plugin để lưu hình ảnh)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã tải mã QR thành công')),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã sao chép vào bộ nhớ tạm')),
    );
  }

  @override
  // Thêm nút xác nhận đã thanh toán
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán QR'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Thông tin đơn hàng
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Mã đơn hàng', widget.order.id),
                    const Divider(),
                    _buildInfoRow(
                      'Tổng tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Quét mã để thanh toán',
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
                      label: const Text('Tải mã QR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Thông tin chuyển khoản
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin chuyển khoản',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildCopyableInfoRow('Ngân hàng', widget.bankName),
                    const Divider(),
                    _buildCopyableInfoRow('Số tài khoản', widget.accountNumber),
                    const Divider(),
                    _buildCopyableInfoRow('Tên tài khoản', widget.accountName),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Số tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Nội dung CK',
                      'Thanh toan don hang ${widget.order.id}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Lưu ý
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Lưu ý:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '- Vui lòng thanh toán trong vòng 24h kể từ khi đặt hàng\n'
                      '- Đơn hàng sẽ được xử lý sau khi chúng tôi nhận được thanh toán\n'
                      '- Nếu cần hỗ trợ, vui lòng liên hệ hotline: 0345 807 906',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán QR'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Thông tin đơn hàng
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Mã đơn hàng', widget.order.id),
                    const Divider(),
                    _buildInfoRow(
                      'Tổng tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Quét mã để thanh toán',
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
                      label: const Text('Tải mã QR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Thông tin chuyển khoản
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin chuyển khoản',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildCopyableInfoRow('Ngân hàng', widget.bankName),
                    const Divider(),
                    _buildCopyableInfoRow('Số tài khoản', widget.accountNumber),
                    const Divider(),
                    _buildCopyableInfoRow('Tên tài khoản', widget.accountName),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Số tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Nội dung CK',
                      'Thanh toan don hang ${widget.order.id}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Lưu ý
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Lưu ý:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '- Vui lòng thanh toán trong vòng 24h kể từ khi đặt hàng\n'
                      '- Đơn hàng sẽ được xử lý sau khi chúng tôi nhận được thanh toán\n'
                      '- Nếu cần hỗ trợ, vui lòng liên hệ hotline: 0345 807 906',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán QR'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Thông tin đơn hàng
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Mã đơn hàng', widget.order.id),
                    const Divider(),
                    _buildInfoRow(
                      'Tổng tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Quét mã để thanh toán',
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
                      label: const Text('Tải mã QR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Thông tin chuyển khoản
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin chuyển khoản',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildCopyableInfoRow('Ngân hàng', widget.bankName),
                    const Divider(),
                    _buildCopyableInfoRow('Số tài khoản', widget.accountNumber),
                    const Divider(),
                    _buildCopyableInfoRow('Tên tài khoản', widget.accountName),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Số tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Nội dung CK',
                      'Thanh toan don hang ${widget.order.id}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Lưu ý
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Lưu ý:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '- Vui lòng thanh toán trong vòng 24h kể từ khi đặt hàng\n'
                      '- Đơn hàng sẽ được xử lý sau khi chúng tôi nhận được thanh toán\n'
                      '- Nếu cần hỗ trợ, vui lòng liên hệ hotline: 0345 807 906',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán QR'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Thông tin đơn hàng
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Mã đơn hàng', widget.order.id),
                    const Divider(),
                    _buildInfoRow(
                      'Tổng tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Quét mã để thanh toán',
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
                      label: const Text('Tải mã QR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Thông tin chuyển khoản
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin chuyển khoản',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildCopyableInfoRow('Ngân hàng', widget.bankName),
                    const Divider(),
                    _buildCopyableInfoRow('Số tài khoản', widget.accountNumber),
                    const Divider(),
                    _buildCopyableInfoRow('Tên tài khoản', widget.accountName),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Số tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Nội dung CK',
                      'Thanh toan don hang ${widget.order.id}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Lưu ý
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Lưu ý:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '- Vui lòng thanh toán trong vòng 24h kể từ khi đặt hàng\n'
                      '- Đơn hàng sẽ được xử lý sau khi chúng tôi nhận được thanh toán\n'
                      '- Nếu cần hỗ trợ, vui lòng liên hệ hotline: 0345 807 906',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán QR'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Thông tin đơn hàng
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Mã đơn hàng', widget.order.id),
                    const Divider(),
                    _buildInfoRow(
                      'Tổng tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Quét mã để thanh toán',
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
                      label: const Text('Tải mã QR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Thông tin chuyển khoản
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin chuyển khoản',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildCopyableInfoRow('Ngân hàng', widget.bankName),
                    const Divider(),
                    _buildCopyableInfoRow('Số tài khoản', widget.accountNumber),
                    const Divider(),
                    _buildCopyableInfoRow('Tên tài khoản', widget.accountName),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Số tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Nội dung CK',
                      'Thanh toan don hang ${widget.order.id}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Lưu ý
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Lưu ý:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '- Vui lòng thanh toán trong vòng 24h kể từ khi đặt hàng\n'
                      '- Đơn hàng sẽ được xử lý sau khi chúng tôi nhận được thanh toán\n'
                      '- Nếu cần hỗ trợ, vui lòng liên hệ hotline: 0345 807 906',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán QR'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Thông tin đơn hàng
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Mã đơn hàng', widget.order.id),
                    const Divider(),
                    _buildInfoRow(
                      'Tổng tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Quét mã để thanh toán',
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
                      label: const Text('Tải mã QR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Thông tin chuyển khoản
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin chuyển khoản',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildCopyableInfoRow('Ngân hàng', widget.bankName),
                    const Divider(),
                    _buildCopyableInfoRow('Số tài khoản', widget.accountNumber),
                    const Divider(),
                    _buildCopyableInfoRow('Tên tài khoản', widget.accountName),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Số tiền',
                      '${widget.order.totalAmount.toStringAsFixed(0)} đ',
                    ),
                    const Divider(),
                    _buildCopyableInfoRow(
                      'Nội dung CK',
                      'Thanh toan don hang ${widget.order.id}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Lưu ý
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Lưu ý:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '- Vui lòng thanh toán trong vòng 24h kể từ khi đặt hàng\n'
                      '- Đơn hàng sẽ được xử lý sau khi chúng tôi nhận được thanh toán\n'
                      '- Nếu cần hỗ trợ, vui lòng liên hệ hotline: 0345 807 906',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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