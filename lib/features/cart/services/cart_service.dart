import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../../../core/services/api_service.dart';

class CartService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Fetch cart from API
  Future<void> fetchCart() async {
    try {
      final response = await _apiService.get('/api/cart');
      
      if (response['code'] == 200 && response['data'] != null) {
        final List<dynamic> cartData = response['data']['items'] ?? [];
        _items = cartData.map((item) => CartItem.fromMap(item)).toList();
        notifyListeners();
      } else {
        print('Error fetching cart: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error fetching cart: $e');
    }
  }

  // Add product to cart
  Future<void> addItem(String id, String name, double price, String image, {String? variant, int quantity = 1}) async {
    try {
      final response = await _apiService.post('/api/cart/add', {
        'productId': id,
        'quantity': quantity,
        if (variant != null) 'variant': variant,
      });

      if (response['code'] == 200) {
        await fetchCart(); // Update cart from server
      }
    } catch (e) {
      print('Error adding to cart: $e');
      // Fallback: handle offline addition if API fails
      final existingItemIndex = _items.indexWhere((item) => 
          item.id == id && item.variant == variant);

      if (existingItemIndex >= 0) {
        _items[existingItemIndex].quantity += quantity;
      } else {
        _items.add(
          CartItem(
            id: id,
            name: name,
            price: price,
            image: image,
            variant: variant,
            quantity: quantity,
          ),
        );
      }
      notifyListeners();
    }
  }

  // Remove product from cart
  Future<void> removeItem(String id, {String? variant}) async {
    try {
      final String endpoint = variant != null 
          ? '/api/cart/item/$id?variant=$variant' 
          : '/api/cart/item/$id';
      
      final response = await _apiService.delete(endpoint);
      if (response['code'] == 200) {
        await fetchCart(); // Update cart from server
      }
    } catch (e) {
      print('Error removing from cart: $e');
      // Fallback: handle offline removal if API fails
      if (variant != null) {
        _items.removeWhere((item) => item.id == id && item.variant == variant);
      } else {
        _items.removeWhere((item) => item.id == id);
      }
      notifyListeners();
    }
  }

  // Update product quantity
  Future<void> updateQuantity(String id, int quantity, {String? variant}) async {
    try {
      final response = await _apiService.put('/api/cart/update', {
        'id': id,
        'quantity': quantity,
        if (variant != null) 'variant': variant,
      });

      if (response['code'] == 200) {
        await fetchCart(); // Update cart from server
      }
    } catch (e) {
      print('Error updating cart: $e');
      // Fallback: handle offline update if API fails
      final existingItemIndex = variant != null
          ? _items.indexWhere((item) => item.id == id && item.variant == variant)
          : _items.indexWhere((item) => item.id == id);
          
      if (existingItemIndex >= 0) {
        if (quantity <= 0) {
          _items.removeAt(existingItemIndex);
        } else {
          _items[existingItemIndex].quantity = quantity;
        }
        notifyListeners();
      }
    }
  }

  // Clear entire cart
  Future<void> clear() async {
    try {
      final response = await _apiService.delete('/api/cart/clear');
      if (response['code'] == 200) {
        _items = [];
        notifyListeners();
      }
    } catch (e) {
      print('Error clearing cart: $e');
      // Fallback: handle offline clear if API fails
      _items.clear();
      notifyListeners();
    }
  }
}
