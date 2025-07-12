import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';

class EditAddressScreen extends StatefulWidget {
  final Map<String, String> address;
  
  const EditAddressScreen({Key? key, required this.address}) : super(key: key);

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _wardController;
  late TextEditingController _addressController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo các controller với dữ liệu hiện có
    _nameController = TextEditingController(text: widget.address['name']);
    _phoneController = TextEditingController(text: widget.address['phone']);
    
    // Phân tích địa chỉ thành các thành phần
    final addressParts = _parseAddress(widget.address['address'] ?? '');
    _addressController = TextEditingController(text: addressParts['specific']);
    _wardController = TextEditingController(text: addressParts['ward']);
    _districtController = TextEditingController(text: addressParts['district']);
    _cityController = TextEditingController(text: addressParts['city']);
    
    // Kiểm tra xem địa chỉ có phải là mặc định không
    _isDefault = widget.address['isDefault'] == 'true';
  }

  // Hàm phân tích địa chỉ thành các thành phần
  Map<String, String> _parseAddress(String fullAddress) {
    final parts = fullAddress.split(', ');
    String specific = '';
    String ward = '';
    String district = '';
    String city = '';
    
    if (parts.length >= 4) {
      specific = parts[0];
      ward = parts[1];
      district = parts[2];
      city = parts[3];
    } else if (parts.length == 3) {
      specific = parts[0];
      district = parts[1];
      city = parts[2];
    } else if (parts.length == 2) {
      specific = parts[0];
      city = parts[1];
    } else if (parts.length == 1) {
      specific = parts[0];
    }
    
    return {
      'specific': specific,
      'ward': ward,
      'district': district,
      'city': city,
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _wardController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa địa chỉ'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Họ và tên',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Số điện thoại',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _cityController,
                label: 'Tỉnh/Thành phố',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tỉnh/thành phố';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _districtController,
                label: 'Quận/Huyện',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập quận/huyện';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _wardController,
                label: 'Phường/Xã',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập phường/xã';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: 'Địa chỉ cụ thể (số nhà, tên tòa nhà, tên đường, tên khu vực)',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ cụ thể';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Switch(
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() {
                        _isDefault = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  const Text('Đặt làm địa chỉ mặc định'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Hiển thị hộp thoại xác nhận xóa
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Xác nhận xóa'),
                            content: const Text('Bạn có chắc chắn muốn xóa địa chỉ này không?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Đóng dialog
                                  Navigator.pop(context, {'delete': true}); // Trả về yêu cầu xóa
                                },
                                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        'Xóa',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Lưu thay đổi',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Tạo đối tượng địa chỉ đã cập nhật
                          final updatedAddress = {
                            'name': _nameController.text,
                            'phone': _phoneController.text,
                            'address': '${_addressController.text}, ${_wardController.text}, ${_districtController.text}, ${_cityController.text}',
                            'isDefault': _isDefault.toString(),
                          };
                          
                          // Trả về địa chỉ đã cập nhật cho màn hình trước đó
                          Navigator.pop(context, {'update': updatedAddress});
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
    );
  }
}