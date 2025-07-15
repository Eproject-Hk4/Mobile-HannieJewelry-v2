import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../models/product_model.dart';
import '../models/product_category_model.dart';

class ProductService extends ChangeNotifier {
  final ApiService _apiService;
  
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  List<Product> _newProducts = [];
  List<ProductCategory> _categories = [];
  bool _isLoading = false;
  String _error = '';

  ProductService(this._apiService);

  // Getters
  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  List<Product> get newProducts => _newProducts;
  List<ProductCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Fetch all products
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await _apiService.get('products');
      
      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        _products = productsJson.map((json) => Product.fromMap(json)).toList();
        
        // Filter featured and new products
        _featuredProducts = _products.where((product) => product.featured).toList();
        _newProducts = _products.where((product) => product.isNew).toList();
        
        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'Failed to load products: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error fetching products: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch product by ID
  Future<Product?> fetchProductById(String id) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await _apiService.get('products/$id');
      
      if (response.statusCode == 200) {
        final productJson = json.decode(response.body);
        final product = Product.fromMap(productJson);
        
        _isLoading = false;
        notifyListeners();
        return product;
      } else {
        _error = 'Failed to load product: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'Error fetching product: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Fetch product categories
  Future<List<ProductCategory>> fetchCategories() async {
    // Set loading state without notifying listeners immediately
    _isLoading = true;
    _error = '';
    
    try {
      // Using the correct endpoint based on JSON server structure
      final response = await _apiService.get('categories');
      
      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = json.decode(response.body);
        final fetchedCategories = categoriesJson.map((json) => ProductCategory.fromMap(json)).toList();
        
        // Update state and notify listeners only once at the end
        _categories = fetchedCategories;
        _isLoading = false;
        // Use Future.microtask to avoid calling notifyListeners during build
        Future.microtask(() => notifyListeners());
        return fetchedCategories;
      } else {
        _error = 'Failed to load categories: ${response.statusCode}';
        _isLoading = false;
        // Use Future.microtask to avoid calling notifyListeners during build
        Future.microtask(() => notifyListeners());
        return [];
      }
    } catch (e) {
      _error = 'Error fetching categories: $e';
      _isLoading = false;
      // Use Future.microtask to avoid calling notifyListeners during build
      Future.microtask(() => notifyListeners());
      return [];
    }
  }

  // Search products by name
  List<Product> searchProducts(String query) {
    if (query.isEmpty) {
      return _products;
    }
    
    final lowercaseQuery = query.toLowerCase();
    return _products.where((product) => 
      product.name.toLowerCase().contains(lowercaseQuery) ||
      product.description.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }

  // Filter products by category
  List<Product> filterByCategory(String category) {
    if (category.isEmpty) {
      return _products;
    }
    
    return _products.where((product) => 
      product.category.toLowerCase() == category.toLowerCase()
    ).toList();
  }

  // Filter products by price range
  List<Product> filterByPriceRange(double minPrice, double maxPrice) {
    return _products.where((product) => 
      product.price >= minPrice && product.price <= maxPrice
    ).toList();
  }

  // Sort products by price (ascending or descending)
  List<Product> sortByPrice(bool ascending) {
    final sortedProducts = List<Product>.from(_products);
    if (ascending) {
      sortedProducts.sort((a, b) => a.price.compareTo(b.price));
    } else {
      sortedProducts.sort((a, b) => b.price.compareTo(a.price));
    }
    return sortedProducts;
  }

  // Sort products by rating
  List<Product> sortByRating() {
    final sortedProducts = List<Product>.from(_products);
    sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedProducts;
  }
  
  // Fetch products by category
  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    // Set loading state without notifying listeners immediately
    _isLoading = true;
    _error = '';
    
    try {
      // Use the correct query parameter format for filtering by category
      final response = await _apiService.get('products?category=$categoryId');
      
      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        final categoryProducts = productsJson.map((json) => Product.fromMap(json)).toList();
        
        _isLoading = false;
        // Use Future.microtask to avoid calling notifyListeners during build
        Future.microtask(() => notifyListeners());
        return categoryProducts;
      } else {
        _error = 'Failed to load category products: ${response.statusCode}';
        _isLoading = false;
        // Use Future.microtask to avoid calling notifyListeners during build
        Future.microtask(() => notifyListeners());
        return [];
      }
    } catch (e) {
      _error = 'Error fetching category products: $e';
      _isLoading = false;
      // Use Future.microtask to avoid calling notifyListeners during build
      Future.microtask(() => notifyListeners());
      return [];
    }
  }
  
  // Get categories (alias for categories getter to match method naming convention)
  List<ProductCategory> getCategories() {
    return _categories;
  }
  
  // Get products by category (alias for fetchProductsByCategory)
  Future<List<Product>> getProductsByCategory(String category) async {
    return fetchProductsByCategory(category);
  }
}