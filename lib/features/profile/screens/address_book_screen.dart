import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import 'add_address_screen.dart';
import 'edit_address_screen.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  final List<Map<String, String>> addresses = [
    {
      'name': 'Nhà riêng',
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'phone': '0901234567'
    },
    {
      'name': 'Văn phòng',
      'address': '456 Đường XYZ, Quận 2, TP.HCM',
      'phone': '0909876543'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sổ địa chỉ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: addresses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 64,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Bạn chưa có địa chỉ nào',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    address['name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditAddressScreen(
                                                address: address,
                                              ),
                                            ),
                                          );
                                          
                                          // Xử lý kết quả trả về
                                          if (result != null && result is Map<String, dynamic>) {
                                            if (result.containsKey('delete')) {
                                              // Xóa địa chỉ
                                              setState(() {
                                                addresses.removeAt(index);
                                              });
                                            } else if (result.containsKey('update')) {
                                              // Cập nhật địa chỉ
                                              setState(() {
                                                addresses[index] = result['update'] as Map<String, String>;
                                              });
                                            }
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          // Delete address logic
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Địa chỉ: ${address['address']}'),
                              const SizedBox(height: 4),
                              Text('Số điện thoại: ${address['phone']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButton(
              text: 'Thêm địa chỉ mới',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAddressScreen(),
                  ),
                );
                
                // Nếu có địa chỉ mới được trả về, thêm vào danh sách
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    addresses.add(result as Map<String, String>);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}