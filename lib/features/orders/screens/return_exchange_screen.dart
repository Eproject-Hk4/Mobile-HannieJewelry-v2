import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../checkout/models/order_model.dart';
import '../models/return_exchange_model.dart';
import '../services/order_service.dart';
import 'order_history_screen.dart';

class ReturnExchangeScreen extends StatefulWidget {
  final String? orderId;

  const ReturnExchangeScreen({Key? key, this.orderId}) : super(key: key);

  @override
  State<ReturnExchangeScreen> createState() => _ReturnExchangeScreenState();
}

class _ReturnExchangeScreenState extends State<ReturnExchangeScreen> {
  final _formKey = GlobalKey<FormState>();
  ReturnExchangeType _selectedType = ReturnExchangeType.return_item;
  String _reason = '';
  String _additionalInfo = '';
  List<OrderItem> _selectedItems = [];
  OrderModel? _selectedOrder;
  
  @override
  void initState() {
    super.initState();
    if (widget.orderId != null) {
      // Nếu có orderId được truyền vào, tự động chọn đơn hàng đó
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final orderService = Provider.of<OrderService>(context, listen: false);
        final order = orderService.getOrderById(widget.orderId!);
        if (order != null) {
          setState(() async {
            _selectedOrder = await order;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Yêu cầu trả/đổi hàng'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedOrder == null) ...[  
                _buildOrderSelection(),
              ] else ...[  
                _buildSelectedOrderInfo(),
                const SizedBox(height: 16),
                _buildItemSelection(),
              ],
              
              const SizedBox(height: 24),
              _buildTypeSelection(),
              
              const SizedBox(height: 24),
              _buildReasonField(),
              
              const SizedBox(height: 16),
              _buildAdditionalInfoField(),
              
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn đơn hàng',
          style: AppStyles.heading,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            // Chuyển đến màn hình lịch sử đơn hàng để chọn
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
            );
            
            if (result != null && result is String) {
              final orderService = Provider.of<OrderService>(context, listen: false);
              final order = orderService.getOrderById(result);
              if (order != null) {
                setState(() async {
                  _selectedOrder = await order;
                  _selectedItems = [];
                });
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.receipt_long),
              SizedBox(width: 8),
              Text('Chọn từ lịch sử đơn hàng'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đơn hàng #${_selectedOrder!.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedOrder = null;
                    _selectedItems = [];
                  });
                },
                child: const Text('Thay đổi'),
              ),
            ],
          ),
          const Divider(),
          ..._selectedOrder!.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${item.quantity}x',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item.name),
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
        ],
      ),
    );
  }

  Widget _buildItemSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn sản phẩm cần trả/đổi',
          style: AppStyles.heading,
        ),
        const SizedBox(height: 8),
        ...(_selectedOrder?.items ?? []).map((item) => CheckboxListTile(
              title: Text(item.name),
              subtitle: Text('${_formatCurrency(item.price)} đ x ${item.quantity}'),
              value: _selectedItems.any((selectedItem) => selectedItem.productId == item.productId),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    if (!_selectedItems.any((selectedItem) => selectedItem.productId == item.productId)) {
                      _selectedItems.add(item);
                    }
                  } else {
                    _selectedItems.removeWhere((selectedItem) => selectedItem.productId == item.productId);
                  }
                });
              },
              activeColor: AppColors.primary,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            )),
      ],
    );
  }

  Widget _buildTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loại yêu cầu',
          style: AppStyles.heading,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<ReturnExchangeType>(
                title: const Text('Trả hàng'),
                value: ReturnExchangeType.return_item,
                groupValue: _selectedType,
                onChanged: (ReturnExchangeType? value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<ReturnExchangeType>(
                title: const Text('Đổi hàng'),
                value: ReturnExchangeType.exchange_item,
                groupValue: _selectedType,
                onChanged: (ReturnExchangeType? value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lý do trả/đổi hàng',
          style: AppStyles.heading,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Nhập lý do trả/đổi hàng',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập lý do';
            }
            return null;
          },
          onChanged: (value) {
            _reason = value;
          },
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin bổ sung (không bắt buộc)',
          style: AppStyles.heading,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Nhập thông tin bổ sung',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          maxLines: 3,
          onChanged: (value) {
            _additionalInfo = value;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate() && _selectedOrder != null && _selectedItems.isNotEmpty) {
            // Xử lý gửi yêu cầu trả/đổi hàng
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Yêu cầu của bạn đã được gửi thành công')),
            );
            Navigator.of(context).pop();
          } else if (_selectedOrder == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng chọn đơn hàng')),
            );
          } else if (_selectedItems.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng chọn ít nhất một sản phẩm')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Gửi yêu cầu'),
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