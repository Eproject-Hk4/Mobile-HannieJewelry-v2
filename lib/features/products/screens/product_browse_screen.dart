import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/cart_badge.dart';
import '../../cart/services/cart_service.dart';
import '../models/product_model.dart';
import '../models/product_category_model.dart';
import '../services/product_service.dart';
import 'product_detail_screen.dart';
import '../widgets/product_card.dart';

class ProductBrowseScreen extends StatefulWidget {
  const ProductBrowseScreen({Key? key}) : super(key: key);

  @override
  State<ProductBrowseScreen> createState() => _ProductBrowseScreenState();
}

class _ProductBrowseScreenState extends State<ProductBrowseScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    // Initialize data loading
    Future.microtask(() {
      _loadData();
    });
    
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadData() async {
    final productService = Provider.of<ProductService>(context, listen: false);
    
    // Load categories first
    final categories = await productService.fetchCategories();
    
    if (categories.isNotEmpty) {
      // Initialize tab controller once we know how many tabs we need
      setState(() {
        _tabController = TabController(
          length: categories.length,
          vsync: this,
        );
        
        // Listen for tab changes
        _tabController!.addListener(_handleTabChange);
      });
      
      // Load products for the first category
      if (productService.selectedCategory != null) {
        await productService.fetchProductsByCollection(
          productService.selectedCategory!.handle,
          refresh: true,
        );
      }
    }
  }

  void _handleTabChange() {
    if (_tabController != null && _tabController!.indexIsChanging == false) {
      final productService = Provider.of<ProductService>(context, listen: false);
      final categories = productService.categories;
      
      if (categories.isNotEmpty && _tabController!.index < categories.length) {
        final selectedCategory = categories[_tabController!.index];
        productService.setSelectedCategory(selectedCategory);
        productService.resetPagination();
        productService.fetchProductsByCollection(selectedCategory.handle, refresh: true);
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final productService = Provider.of<ProductService>(context, listen: false);
      if (!productService.isLoadingMore && productService.hasMoreProducts) {
        productService.loadMoreProducts();
      }
    }
  }

  Future<void> _refreshProducts() async {
    final productService = Provider.of<ProductService>(context, listen: false);
    if (productService.selectedCategory != null) {
      await productService.fetchProductsByCollection(
        productService.selectedCategory!.handle,
        refresh: true,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController?.removeListener(_handleTabChange);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn sản phẩm'),
        actions: [
          Consumer<CartService>(
            builder: (context, cartService, child) {
              return CartBadge(
                count: cartService.items.length,
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
        bottom: _buildTabBar(),
      ),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget? _buildTabBar() {
    final productService = Provider.of<ProductService>(context);
    
    if (productService.isLoadingCategories) {
      return null;
    }
    
    if (productService.categories.isEmpty) {
      return null;
    }
    
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primary,
      tabs: productService.categories.map((category) {
        return Tab(text: category.title);
      }).toList(),
    );
  }

  Widget _buildBody() {
    return Consumer<ProductService>(
      builder: (context, productService, child) {
        if (productService.isLoadingCategories) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (productService.categories.isEmpty) {
          return const Center(child: Text('No categories found'));
        }
        
        if (productService.isLoading && productService.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (productService.error.isNotEmpty && productService.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${productService.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshProducts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        return Column(
          children: [
            _buildFiltersRow(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshProducts,
                child: productService.products.isEmpty
                    ? const Center(child: Text('No products found'))
                    : _buildProductGrid(productService),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFiltersRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Filter button
          OutlinedButton.icon(
            onPressed: () {
              // Show filter dialog
            },
            icon: const Icon(Icons.filter_list),
            label: const Text('Bộ lọc'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          // Sort button
          OutlinedButton.icon(
            onPressed: () {
              // Show sort options
            },
            icon: const Icon(Icons.sort),
            label: const Text('Sắp xếp'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(ProductService productService) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: productService.isLoadingMore 
          ? productService.products.length + 2 
          : productService.products.length,
      itemBuilder: (context, index) {
        // Show loading indicators at the end while loading more
        if (index >= productService.products.length) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final product = productService.products[index];
        return ProductCard(
          product: product,
          onTap: () => _navigateToProductDetail(product),
          onAddToCart: () => _addToCart(product),
        );
      },
    );
  }

  void _navigateToProductDetail(Product product) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: {'productHandle': product.handle},
    );
  }

  void _addToCart(Product product) {
    final cartService = Provider.of<CartService>(context, listen: false);
    // Add product to cart
    // This will depend on your CartService implementation
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }
} 