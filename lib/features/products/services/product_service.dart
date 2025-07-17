import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../models/product_model.dart';
import '../models/product_category_model.dart';
import '../models/product_pagination_model.dart';

class ProductService extends ChangeNotifier {
  final ApiService _apiService;
  
  List<Product> _products = [];
  ProductPagination? _productPagination;
  List<ProductCategory> _categories = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isLoadingCategories = false;
  String _error = '';
  int _currentPage = 0;
  int _pageSize = 10;

  ProductService(this._apiService);

  // Getters
  List<Product> get products => _products;
  ProductPagination? get productPagination => _productPagination;
  List<ProductCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isLoadingCategories => _isLoadingCategories;
  String get error => _error;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get hasMoreProducts => _productPagination != null && 
    _currentPage < _productPagination!.totalPages - 1;

  // Fetch products with pagination
  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _isLoading = true;
    } else if (_isLoadingMore) {
      return;
    } else if (!hasMoreProducts) {
      return;
    } else {
      _isLoadingMore = true;
    }
    
    _error = '';
    notifyListeners();

    try {
      final response = await _apiService.get('/api/products?page=$_currentPage&size=$_pageSize');
      
      if (response['code'] == 200 && response['data'] != null) {
        final productResponse = ProductResponse.fromMap(response);
        final pagination = productResponse.data.result;
        
        if (refresh) {
          _products = pagination.content;
          _productPagination = pagination;
        } else {
          _products.addAll(pagination.content);
          _productPagination = pagination;
          _currentPage++;
        }
        
        _isLoading = false;
        _isLoadingMore = false;
        notifyListeners();
      } else {
        _error = 'Failed to load products: ${response['message'] ?? 'Unknown error'}';
        _isLoading = false;
        _isLoadingMore = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error fetching products: $e';
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Load more products
  Future<void> loadMoreProducts() async {
    if (!hasMoreProducts || _isLoadingMore) {
      return;
    }
    
    _currentPage++;
    await fetchProducts();
  }

  // Fetch product by ID
  Future<Product?> fetchProductById(String id) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await _apiService.get('/api/products/$id');
      
      if (response['code'] == 200 && response['data'] != null) {
        final productJson = response['data'];
        final product = Product.fromMap(productJson);
        
        _isLoading = false;
        notifyListeners();
        return product;
      } else {
        _error = 'Failed to load product: ${response['message'] ?? 'Unknown error'}';
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
    _isLoadingCategories = true;
    _error = '';
    
    try {
      final response = await _apiService.get('/api/product-categories');
      
      if (response['code'] == 200 && response['data'] != null) {
        final List<dynamic> categoriesJson = response['data'];
        final fetchedCategories = categoriesJson.map((json) => ProductCategory.fromMap(json)).toList();
        
        // Update state and notify listeners only once at the end
        _categories = fetchedCategories;
        _isLoadingCategories = false;
        notifyListeners();
        return fetchedCategories;
      } else {
        _error = 'Failed to load categories: ${response['message'] ?? 'Unknown error'}';
        _isLoadingCategories = false;
        notifyListeners();
        return [];
      }
    } catch (e) {
      _error = 'Error fetching categories: $e';
      _isLoadingCategories = false;
      notifyListeners();
      return [];
    }
  }

  // Search products by title
  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) {
      return _products;
    }
    
    try {
      final response = await _apiService.get('/api/products?search=$query&page=0&size=$_pageSize');
      
      if (response['code'] == 200 && response['data'] != null) {
        final productResponse = ProductResponse.fromMap(response);
        return productResponse.data.result.content;
      } else {
        _error = 'Failed to search products: ${response['message'] ?? 'Unknown error'}';
        notifyListeners();
        return [];
      }
    } catch (e) {
      _error = 'Error searching products: $e';
      notifyListeners();
      return [];
    }
  }

  // Filter products by category
  Future<List<Product>> filterByCategory(String category) async {
    if (category.isEmpty) {
      return _products;
    }
    
    try {
      final response = await _apiService.get('/api/products?category=$category&page=0&size=$_pageSize');
      
      if (response['code'] == 200 && response['data'] != null) {
        final productResponse = ProductResponse.fromMap(response);
        return productResponse.data.result.content;
      } else {
        _error = 'Failed to filter products: ${response['message'] ?? 'Unknown error'}';
        notifyListeners();
        return [];
      }
    } catch (e) {
      _error = 'Error filtering products: $e';
      notifyListeners();
      return [];
    }
  }

  // Filter products by price range
  Future<List<Product>> filterByPriceRange(double minPrice, double maxPrice) async {
    try {
      final response = await _apiService.get('/api/products?minPrice=$minPrice&maxPrice=$maxPrice&page=0&size=$_pageSize');
      
      if (response['code'] == 200 && response['data'] != null) {
        final productResponse = ProductResponse.fromMap(response);
        return productResponse.data.result.content;
      } else {
        _error = 'Failed to filter products by price: ${response['message'] ?? 'Unknown error'}';
        notifyListeners();
        return [];
      }
    } catch (e) {
      _error = 'Error filtering products by price: $e';
      notifyListeners();
      return [];
    }
  }

  // Sort products by various criteria
  Future<List<Product>> sortProducts(String sortBy, String direction) async {
    try {
      final response = await _apiService.get('/api/products?sort=$sortBy,$direction&page=0&size=$_pageSize');
      
      if (response['code'] == 200 && response['data'] != null) {
        final productResponse = ProductResponse.fromMap(response);
        return productResponse.data.result.content;
      } else {
        _error = 'Failed to sort products: ${response['message'] ?? 'Unknown error'}';
        notifyListeners();
        return [];
      }
    } catch (e) {
      _error = 'Error sorting products: $e';
      notifyListeners();
      return [];
    }
  }
  
  // Reset pagination
  void resetPagination() {
    _currentPage = 0;
    _products = [];
    _productPagination = null;
    notifyListeners();
  }
}