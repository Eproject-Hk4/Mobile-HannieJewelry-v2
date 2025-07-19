import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/cart_badge.dart';
import '../../cart/screens/cart_screen.dart';
import '../../cart/services/cart_service.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productHandle;
  
  const ProductDetailScreen({
    Key? key,
    required this.productHandle,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  bool _isLoading = true;
  String _error = '';
  int _selectedVariantIndex = 0;
  int _quantity = 1;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  
  @override
  void initState() {
    super.initState();
    _loadProduct();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    
    try {
      final productService = Provider.of<ProductService>(context, listen: false);
      
      // Use the handle to fetch the product
      final product = await productService.fetchProductByHandle(widget.productHandle);
      
      if (mounted) {
        setState(() {
          _product = product;
          _isLoading = false;
          
          // Set default selected variant to the first one if available
          if (product != null && product.variants.isNotEmpty) {
            _selectedVariantIndex = 0;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading product: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }
  
  void _incrementQuantity() {
    if (_product != null && _selectedVariantIndex < _product!.variants.length) {
      final variant = _product!.variants[_selectedVariantIndex];
      if (_quantity < variant.inventoryQuantity) {
        setState(() {
          _quantity++;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum available quantity reached')),
        );
      }
    }
  }
  
  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }
  
  void _addToCart() {
    if (_product == null || _product!.variants.isEmpty) return;
    
    final variant = _product!.variants[_selectedVariantIndex];
    final cartService = Provider.of<CartService>(context, listen: false);
    
    // Add item to cart
    cartService.addItem(
      variant.id.toString(),
      _product!.title,
      variant.priceAsDouble,
      _product!.images.isNotEmpty ? _product!.images.first.src : '',
      quantity: _quantity,
      variant: variant.title,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${_product!.title} to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<CartService>(
            builder: (context, cartService, child) {
              return CartBadge(
                count: cartService.items.length,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProduct,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _product == null
                  ? const Center(child: Text('Product not found'))
                  : _buildProductDetail(),
      bottomNavigationBar: _isLoading || _error.isNotEmpty || _product == null
          ? null
          : _buildBottomBar(),
    );
  }
  
  Widget _buildProductDetail() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image gallery with page indicator
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _product!.images.isNotEmpty ? _product!.images.length : 1,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    if (_product!.images.isEmpty) {
                      return Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                      );
                    }
                    return Image.network(
                      _product!.images[index].src,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  },
                ),
              ),
              // Page indicator
              if (_product!.images.length > 1)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentImageIndex + 1}/${_product!.images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // Product title and price
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _product!.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (_product!.variants.isNotEmpty) ...[
                  Row(
                    children: [
                      Text(
                        _formatPrice(_product!.variants[_selectedVariantIndex].priceAsDouble),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_product!.variants[_selectedVariantIndex].compareAtPriceAsDouble > 
                          _product!.variants[_selectedVariantIndex].priceAsDouble)
                        Text(
                          _formatPrice(_product!.variants[_selectedVariantIndex].compareAtPriceAsDouble),
                          style: const TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    'Còn ${_product!.variants[_selectedVariantIndex].inventoryQuantity} sản phẩm',
                    style: TextStyle(
                      color: _product!.variants[_selectedVariantIndex].inventoryQuantity > 0
                          ? Colors.green
                          : Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ],
                
                const Divider(height: 32),
                
                // Product details
                const Text(
                  'Chi tiết sản phẩm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Product code
                _buildDetailRow('Mã sản phẩm', _extractProductCode(_product!.title)),
                
                // Product type
                if (_product!.productType.isNotEmpty)
                  _buildDetailRow('Loại sản phẩm', _product!.productType),
                
                // Vendor
                if (_product!.vendor.isNotEmpty)
                  _buildDetailRow('Thương hiệu', _product!.vendor),
                
                // Options
                if (_product!.options.isNotEmpty)
                  ..._product!.options.map((option) => 
                    _buildDetailRow(option.name, option.values.join(', '))
                  ),
                
                const Divider(height: 32),
                
                // Product description
                if (_product!.bodyHtml.isNotEmpty) ...[
                  const Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _product!.bodyHtml,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
                
                // Variants
                if (_product!.variants.length > 1) ...[
                  const Text(
                    'Lựa chọn',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_product!.variants.length, (index) {
                      final variant = _product!.variants[index];
                      final isSelected = _selectedVariantIndex == index;
                      
                      return ChoiceChip(
                        label: Text(variant.title),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedVariantIndex = index;
                            });
                          }
                        },
                        backgroundColor: Colors.white,
                        selectedColor: AppColors.primary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : Colors.grey.shade300,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Quantity selector
                Row(
                  children: [
                    const Text(
                      'Số lượng:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _decrementQuantity,
                            icon: const Icon(Icons.remove, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                          Text(
                            _quantity.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: _incrementQuantity,
                            icon: const Icon(Icons.add, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Thêm vào giỏ hàng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Mua ngay',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper methods to extract product information
  String _extractProductCode(String title) {
    // Extract product code from title (e.g., "Lắc tay LPTB 382" -> "LPTB 382")
    final RegExp regex = RegExp(r'([A-Z]+\s*\d+)');
    final match = regex.firstMatch(title);
    return match != null ? match.group(1)! : title;
  }
  
  String _extractMaterial(String description) {
    // Extract material info from description
    if (description.contains('AU585')) {
      return 'AU585';
    } else if (description.contains('AU750')) {
      return 'AU750';
    } else if (description.contains('Vàng')) {
      return 'Vàng';
    }
    return 'Không có thông tin';
  }
  
  String _extractWeight(String description) {
    // Extract weight info from description
    final RegExp regex = RegExp(r'(\d+[\.,]?\d*)\s*g');
    final match = regex.firstMatch(description);
    return match != null ? '≈${match.group(1)}g' : 'Không có thông tin';
  }
  
  String _extractStoneType(String description) {
    // Extract stone type from description
    if (description.contains('Moissanite')) {
      return 'Moissanite';
    } else if (description.contains('Ruby')) {
      return 'Ruby';
    } else if (description.contains('Sapphire')) {
      return 'Sapphire';
    } else if (description.contains('Diamond')) {
      return 'Diamond';
    }
    return 'Không có thông tin';
  }
  
  String _formatPrice(double price) {
    // Format price as VND currency
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}đ';
  }
}