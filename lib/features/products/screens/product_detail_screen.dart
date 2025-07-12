import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/cart_badge.dart';
import '../../cart/screens/cart_screen.dart';
import '../../cart/services/cart_service.dart';
import '../../../features/auth/services/auth_service.dart';
import '../../../features/auth/screens/login_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  // Thay đổi từ:
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);
  


  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  final List<String> _dummyImages = [
    'assets/images/placeholder.png',
    'assets/images/placeholder.png',
    'assets/images/placeholder.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Chi tiết sản phẩm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Sửa lỗi: Chỉ sử dụng CartBadge trong actions
        actions: [
          const CartBadge(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm với chỉ báo trang
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: PageView.builder(
                    itemCount: _dummyImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(
                        _dummyImages[index],
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      // Sửa lỗi: Thay withOpacity bằng withValues
                      // Sửa lỗi tham số 'opacity' không được định nghĩa

                      color: Colors.black.withAlpha(128),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentImageIndex + 1}/${_dummyImages.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            
            // Thông tin sản phẩm
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product['name'] ?? 'Lắc tay LPTB 382',
                    style: AppStyles.heading,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_formatCurrency(widget.product['price'] ?? 8512000)} đ',
                    style: AppStyles.heading.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Chi tiết sản phẩm
                  const Text(
                    'Chi tiết sản phẩm',
                    style: AppStyles.heading,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Mã sản phẩm', widget.product['id'] ?? 'LPTB 382'),
                  _buildDetailRow('Chất liệu', 'AU585'),
                  _buildDetailRow('Trọng lượng vàng', '≈1.74g'),
                  _buildDetailRow('Loại đá', 'Moissanite - Đá màu Ruby Lab'),
                  const SizedBox(height: 8),
                  const Text(
                    'Giá tham khảo',
                    style: TextStyle(fontSize: 16),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sản phẩm tương tự
                  const Text(
                    'Sản phẩm tương tự',
                    style: AppStyles.heading,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final similarProducts = [
                          {'id': 'LPTB382', 'name': 'Lắc tay LPTB 382', 'price': 8512000},
                          {'id': 'LPTB381', 'name': 'Lắc tay LPTB 381', 'price': 8653000},
                          {'id': 'LPTB380', 'name': 'Lắc tay LPTB 380', 'price': 9994000},
                        ];
                        return _buildSimilarProductCard(similarProducts[index]);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Nút thêm vào giỏ hàng và mua ngay
                  Row(
                    children: [
                      // Thêm import


                      
                      // Trong phương thức build, thay đổi nút "Thêm vào giỏ hàng"
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            final authService = Provider.of<AuthService>(context, listen: false);
                            
                            // Kiểm tra đăng nhập trước khi thêm vào giỏ hàng
                            if (authService.isAuthenticated) {
                              final cartService = Provider.of<CartService>(context, listen: false);
                              cartService.addItem(
                                widget.product['id'],
                                widget.product['name'],
                                widget.product['price'],
                                'assets/images/placeholder.png',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đã thêm ${widget.product["name"]} vào giỏ hàng'),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'XEM GIỎ HÀNG',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const CartScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              _showLoginRequiredDialog(context);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Thêm vào giỏ hàng', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final authService = Provider.of<AuthService>(context, listen: false);
                            
                            // Kiểm tra đăng nhập trước khi mua ngay
                            if (authService.isAuthenticated) {
                              // Thêm vào giỏ hàng và chuyển đến trang thanh toán
                              final cartService = Provider.of<CartService>(context, listen: false);
                              cartService.addItem(
                                widget.product['id'],
                                widget.product['name'],
                                widget.product['price'],
                                'assets/images/placeholder.png',
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CartScreen(),
                                ),
                              );
                            } else {
                              _showLoginRequiredDialog(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Mua ngay', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: AppStyles.bodyText,
          ),
          Expanded(
            child: Text(
              value,
              style: AppStyles.bodyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarProductCard(Map<String, dynamic> product) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'assets/images/placeholder.png',
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: AppStyles.bodyTextSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatCurrency(product['price'])} đ',
                  style: AppStyles.bodyTextSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int price) {
    String priceString = price.toString();
    final result = StringBuffer();
    for (int i = 0; i < priceString.length; i++) {
      if ((priceString.length - i) % 3 == 0 && i > 0) {
        result.write('.');
      }
      result.write(priceString[i]);
    }
    return result.toString();
  }

  // Thêm phương thức _showLoginRequiredDialog vào lớp _ProductDetailScreenState
  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yêu cầu đăng nhập'),
        content: const Text('Bạn cần đăng nhập để sử dụng tính năng này.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }
}