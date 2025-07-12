import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/cart_badge.dart';
import '../../cart/screens/cart_screen.dart';
import '../../cart/services/cart_service.dart';
import 'product_detail_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['Lắc Tay', 'Nhẫn Nữ', 'Bông Tai', 'Lắc Chân', 'Bộ Trang Sức PTB', 'Charm Vàng 14K', 'Quà tặng 8/3'];
  
  // Biến lưu trữ trạng thái sắp xếp
  String _sortOption = 'Mới nhất';
  final List<String> _sortOptions = ['Mới nhất', 'Bán chạy nhất', 'Giá từ thấp đến cao', 'Giá từ cao đến thấp'];
  
  // Thêm các biến cho bộ lọc
  final List<String> _productTypes = ['Vàng 18K', 'Vàng 24K', 'Bạc', 'Kim cương'];
  final Set<String> _selectedProductTypes = {}; // Bỏ 'late'
  final List<String> _productGroups = ['Quà tặng', 'Sản phẩm mới', 'Bán chạy', 'Khuyến mãi'];
  final Set<String> _selectedProductGroups = {};
  RangeValues _priceRange = const RangeValues(0, 10000000);
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Hiển thị dialog bộ lọc
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            'Bộ lọc',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 48), // Để cân đối với nút back
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Khoảng giá
                      const Text(
                        'Khoảng giá (đ)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Tối thiểu',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text('—'),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Tối đa',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Thương hiệu
                      const Text(
                        'Thương hiệu',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('Không có dữ liệu'),
                      const SizedBox(height: 24),
                      
                      // Loại sản phẩm
                      const Text(
                        'Loại sản phẩm',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _productTypes.map((type) {
                          final isSelected = _selectedProductTypes.contains(type);
                          return FilterChip(
                            label: Text(type),
                            selected: isSelected,
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primary.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                              ),
                            ),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedProductTypes.add(type);
                                } else {
                                  _selectedProductTypes.remove(type);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Xem thêm',
                              style: TextStyle(color: AppColors.primary),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 16),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Nhóm sản phẩm
                      const Text(
                        'Nhóm sản phẩm',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _productGroups.map((group) {
                          final isSelected = _selectedProductGroups.contains(group);
                          return FilterChip(
                            label: Text(group),
                            selected: isSelected,
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primary.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                              ),
                            ),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedProductGroups.add(group);
                                } else {
                                  _selectedProductGroups.remove(group);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Xem thêm',
                              style: TextStyle(color: AppColors.primary),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 16),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Nút Đặt lại và Áp dụng
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedProductTypes.clear(); // Thay vì gán []
                                  _selectedProductGroups.clear(); // Thay vì gán []
                                  _priceRange = const RangeValues(0, 10000000);
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Đặt lại', style: TextStyle(color: Colors.black)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Áp dụng bộ lọc và đóng dialog
                                Navigator.pop(context);
                                // Cập nhật lại danh sách sản phẩm theo bộ lọc
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Áp dụng', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Chọn sản phẩm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Trong AppBar actions
        actions: [
        IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {},
        ),
        const CartBadge(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.primary,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              tabs: _categories.map((category) => Tab(text: category)).toList(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: const Text('Bộ lọc'),
                    onPressed: _showFilterDialog,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black54,
                      side: const BorderSide(color: Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.sort, size: 18),
                    label: const Text('Sắp xếp'),
                    onPressed: _showSortDialog,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black54,
                      side: const BorderSide(color: Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) => _buildProductGrid(category)).toList(),
            ),
          ),
        ],
      ),
      // Thêm thanh hiển thị giỏ hàng ở dưới cùng
      bottomNavigationBar: Consumer<CartService>(
        builder: (context, cartService, child) {
          // Chỉ hiển thị khi giỏ hàng có sản phẩm
          if (cartService.itemCount == 0) {
            return const SizedBox.shrink();
          }
          return Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${cartService.itemCount} sản phẩm',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${_formatCurrency(cartService.totalAmount)} đ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Xem giỏ hàng',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(String category) {
    // Danh sách sản phẩm mẫu dựa trên danh mục
    List<Map<String, dynamic>> products = [];
    
    if (category == 'Lắc Tay') {
      products = [
        {'id': 'LPTB382', 'name': 'Lắc tay LPTB 382', 'price': 8512000, 'image': 'assets/images/placeholder.png'},
        {'id': 'LPTB381', 'name': 'Lắc tay LPTB 381', 'price': 8653000, 'image': 'assets/images/placeholder.png'},
        {'id': 'LPTB380', 'name': 'Lắc tay LPTB 380', 'price': 9994000, 'image': 'assets/images/placeholder.png'},
        {'id': 'LPTB379', 'name': 'Lắc tay LPTB 379', 'price': 8886000, 'image': 'assets/images/placeholder.png'},
      ];
    } else {
      // Thêm sản phẩm mẫu cho các danh mục khác
      for (int i = 1; i <= 6; i++) {
        products.add({
          'id': '${category.substring(0, 3).toUpperCase()}$i',
          'name': '$category $i',
          'price': 5000000 + (i * 500000),
          'image': 'assets/images/placeholder.png'
        });
      }
    }

    // Áp dụng bộ lọc nếu có
    if (_selectedProductTypes.isNotEmpty) {
      // Lọc theo loại sản phẩm
      // Đây chỉ là mô phỏng, trong thực tế cần có thuộc tính type cho mỗi sản phẩm
    }

    if (_selectedProductGroups.isNotEmpty) {
      // Lọc theo nhóm sản phẩm
      // Đây chỉ là mô phỏng, trong thực tế cần có thuộc tính group cho mỗi sản phẩm
    }

    // Lọc theo khoảng giá
    products = products.where((product) => 
      product['price'] >= _priceRange.start && 
      product['price'] <= _priceRange.end
    ).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(25), // Thay withOpacity bằng withAlpha
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
                product['image'],
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
                    style: AppStyles.bodyText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatCurrency(product['price'])} đ',
                        style: AppStyles.bodyText.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Thêm import



                      
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.add, color: Colors.white, size: 18),
                          onPressed: () {
                            // Thêm sản phẩm vào giỏ hàng
                            final cartService = Provider.of<CartService>(context, listen: false);
                            cartService.addItem(
                              product['id'],
                              product['name'],
                              product['price'],
                              'assets/images/placeholder.png',
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đã thêm ${product["name"]} vào giỏ hàng'),
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
                          },
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

  // Hiển thị dialog sắp xếp
  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Sắp xếp theo',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 48), // Để cân đối với nút back
                  ],
                ),
                const SizedBox(height: 16),
                ...List.generate(_sortOptions.length, (index) {
                  final option = _sortOptions[index];
                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: _sortOption,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        _sortOption = value!;
                      });
                      Navigator.pop(context);
                      // Cập nhật lại danh sách sản phẩm theo sắp xếp
                      this.setState(() {});
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}