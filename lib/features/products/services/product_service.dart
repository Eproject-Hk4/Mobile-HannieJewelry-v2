import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../app/app_config.dart';
import '../../../core/services/api_service.dart';
import '../models/product_model.dart';
import '../models/product_category_model.dart';
import '../models/product_pagination_model.dart';

class ProductService extends ChangeNotifier {
  final ApiService _apiService;
  
  List<Product> _products = [];
  ProductPagination? _productPagination;
  List<ProductCategory> _categories = [];
  ProductCategory? _selectedCategory;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isLoadingCategories = false;
  String _error = '';
  int _currentPage = 1;
  int _pageSize = 10;

  ProductService(this._apiService);

  // Getters
  List<Product> get products => _products;
  ProductPagination? get productPagination => _productPagination;
  List<ProductCategory> get categories => _categories;
  ProductCategory? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isLoadingCategories => _isLoadingCategories;
  String get error => _error;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get hasMoreProducts => _productPagination != null && 
    _currentPage < _productPagination!.totalPages;

  // Set selected category
  void setSelectedCategory(ProductCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Fetch all collections (categories)
  Future<List<ProductCategory>> fetchCategories() async {
    _isLoadingCategories = true;
    _error = '';
    notifyListeners();
    
    try {
      final response = await _apiService.get('/api/client/collections');
      
      if (response['code'] == 200 && response['data'] != null) {
        final List<dynamic> categoriesJson = response['data'];
        final fetchedCategories = categoriesJson.map((json) => ProductCategory.fromMap(json)).toList();
        
        _categories = fetchedCategories;
        if (_categories.isNotEmpty && _selectedCategory == null) {
          _selectedCategory = _categories.first;
        }
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

  // Fetch products by collection handle with pagination
  Future<void> fetchProductsByCollection(String collectionHandle, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
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
      // Use the correct API endpoint format
      final response = await _apiService.get('/api/client/collections/$collectionHandle/products?page=$_currentPage&size=$_pageSize');
      
      if (response['code'] == 200 && response['data'] != null) {
        final productData = response['data']['result'];
        final List<dynamic> productsJson = productData['content'] ?? [];
        final List<Product> fetchedProducts = productsJson.map((json) => Product.fromMap(json)).toList();
        
        final pagination = ProductPagination(
          content: fetchedProducts,
          page: productData['page'] ?? 1,
          size: productData['size'] ?? 10,
          totalElements: productData['total_elements'] ?? 0,
          totalPages: productData['total_pages'] ?? 0,
          sorts: List<Sort>.from((productData['sorts'] ?? []).map((sort) => Sort.fromMap(sort))),
        );
        
        if (refresh) {
          _products = fetchedProducts;
          _productPagination = pagination;
        } else {
          _products.addAll(fetchedProducts);
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

  // Load more products for the current collection
  Future<void> loadMoreProducts() async {
    if (!hasMoreProducts || _isLoadingMore || _selectedCategory == null) {
      return;
    }
    
    await fetchProductsByCollection(_selectedCategory!.handle);
  }

  // Fetch product details by product handle
  Future<Product?> fetchProductByHandle(String productHandle) async {
    // Set loading state outside of the build phase
    Future.microtask(() {
      _isLoading = true;
      _error = '';
      notifyListeners();
    });
    
    try {
      // Use the correct API endpoint for product details
      final response = await _apiService.get('/api/client/collections/$productHandle');
      
      if (response['code'] == 200 && response['data'] != null) {
        final productJson = response['data'];
        final product = Product.fromMap(productJson);
        return product;
      } else {
        _error = 'Failed to load product: ${response['message'] ?? 'Unknown error'}';
        return null;
      }
    } catch (e) {
      _error = 'Error fetching product: $e';
      return null;
    } finally {
      // Update loading state outside of the build phase
      Future.microtask(() {
        _isLoading = false;
        notifyListeners();
      });
    }
  }
  
  // Fetch product by ID
  Future<Product?> fetchProductById(String id) async {
    // Set loading state outside of the build phase
    Future.microtask(() {
      _isLoading = true;
      _error = '';
      notifyListeners();
    });
    
    try {
      // Use the correct API endpoint for product details by ID
      final response = await _apiService.get('/api/client/products/$id');
      
      if (response['code'] == 200 && response['data'] != null) {
        final productJson = response['data'];
        final product = Product.fromMap(productJson);
        return product;
      } else {
        _error = 'Failed to load product: ${response['message'] ?? 'Unknown error'}';
        return null;
      }
    } catch (e) {
      _error = 'Error fetching product: $e';
      return null;
    } finally {
      // Update loading state outside of the build phase
      Future.microtask(() {
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  // Reset pagination
  void resetPagination() {
    _currentPage = 1;
    _products = [];
    _productPagination = null;
    notifyListeners();
  }
}