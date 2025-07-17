import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/cart_badge.dart';
import '../../cart/screens/cart_screen.dart';
import '../../cart/services/cart_service.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  
  const ProductDetailScreen({
    Key? key,
    required this.productId,
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
  
  @override
  void initState() {
    super.initState();
    _loadProduct();
  }
  
  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    
    try {
      final productService = Provider.of<ProductService>(context, listen: false);
      final product = await productService.fetchProductById(widget.productId);
      
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
      variant.price,
      _product!.images.isNotEmpty ? _product!.images[0] : '',
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
      appBar: AppBar(
        title: const Text('Product Details'),
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
          // Product image
          AspectRatio(
            aspectRatio: 1,
            child: _product!.images.isNotEmpty
                ? Image.network(
                    _product!.images[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 60),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image, size: 60),
                    ),
                  ),
          ),
          
          // Product info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_product!.vendor.isNotEmpty)
                  Text(
                    _product!.vendor,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  _product!.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Price section
                if (_product!.variants.isNotEmpty) ...[
                  Row(
                    children: [
                      Text(
                        '${_product!.variants[_selectedVariantIndex].price.toStringAsFixed(0)} VND',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_product!.variants[_selectedVariantIndex].compareAtPrice > 0 &&
                          _product!.variants[_selectedVariantIndex].compareAtPrice > _product!.variants[_selectedVariantIndex].price)
                        Text(
                          '${_product!.variants[_selectedVariantIndex].compareAtPrice.toStringAsFixed(0)} VND',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'In stock: ${_product!.variants[_selectedVariantIndex].inventoryQuantity}',
                    style: TextStyle(
                      color: _product!.variants[_selectedVariantIndex].inventoryQuantity > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
                
                // Variants section
                if (_product!.options.isNotEmpty && _product!.variants.length > 1) ...[
                  const Text(
                    'Options',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Display options
                  for (final option in _product!.options) ...[
                    Text(
                      option.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _getUniqueOptionValues(option.name).map((value) {
                        final isSelected = _isOptionValueSelected(option.name, value);
                        return ChoiceChip(
                          label: Text(value),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              _selectVariantByOption(option.name, value);
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
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
                
                // Quantity selector
                const Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: _decrementQuantity,
                      icon: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(Icons.remove, size: 16),
                      ),
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
                      icon: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Product description
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _product!.bodyPlain.isNotEmpty ? _product!.bodyPlain : _product!.bodyHtml,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomBar() {
    if (_product == null || _product!.variants.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final variant = _product!.variants[_selectedVariantIndex];
    final isOutOfStock = variant.inventoryQuantity <= 0;
    
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${(variant.price * _quantity).toStringAsFixed(0)} VND',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: isOutOfStock ? null : _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: Colors.grey,
              ),
              child: Text(
                isOutOfStock ? 'Out of Stock' : 'Add to Cart',
                style: const TextStyle(
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
  
  // Get unique option values for a specific option name
  List<String> _getUniqueOptionValues(String optionName) {
    final Set<String> uniqueValues = {};
    
    if (_product == null) return [];
    
    for (final variant in _product!.variants) {
      if (optionName == _product!.options[0].name && variant.option1.isNotEmpty) {
        uniqueValues.add(variant.option1);
      } else if (optionName == _product!.options[1].name && variant.option2 != null) {
        uniqueValues.add(variant.option2!);
      } else if (optionName == _product!.options[2].name && variant.option3 != null) {
        uniqueValues.add(variant.option3!);
      }
    }
    
    return uniqueValues.toList();
  }
  
  // Check if an option value is selected in the current variant
  bool _isOptionValueSelected(String optionName, String optionValue) {
    if (_product == null || _selectedVariantIndex >= _product!.variants.length) {
      return false;
    }
    
    final variant = _product!.variants[_selectedVariantIndex];
    
    if (optionName == _product!.options[0].name) {
      return variant.option1 == optionValue;
    } else if (optionName == _product!.options[1].name && variant.option2 != null) {
      return variant.option2 == optionValue;
    } else if (optionName == _product!.options[2].name && variant.option3 != null) {
      return variant.option3 == optionValue;
    }
    
    return false;
  }
  
  // Select a variant based on option value
  void _selectVariantByOption(String optionName, String optionValue) {
    if (_product == null) return;
    
    // Find the variant that matches the current selection but with the new option value
    final currentVariant = _product!.variants[_selectedVariantIndex];
    
    String option1 = currentVariant.option1;
    String? option2 = currentVariant.option2;
    String? option3 = currentVariant.option3;
    
    // Update the option that was selected
    if (optionName == _product!.options[0].name) {
      option1 = optionValue;
    } else if (optionName == _product!.options[1].name) {
      option2 = optionValue;
    } else if (optionName == _product!.options[2].name) {
      option3 = optionValue;
    }
    
    // Find matching variant
    for (int i = 0; i < _product!.variants.length; i++) {
      final variant = _product!.variants[i];
      bool matches = variant.option1 == option1;
      
      if (option2 != null) {
        matches = matches && variant.option2 == option2;
      }
      
      if (option3 != null) {
        matches = matches && variant.option3 == option3;
      }
      
      if (matches) {
        setState(() {
          _selectedVariantIndex = i;
          // Reset quantity if it exceeds the new variant's inventory
          if (_quantity > variant.inventoryQuantity) {
            _quantity = variant.inventoryQuantity > 0 ? 1 : 0;
          }
        });
        return;
      }
    }
  }
}