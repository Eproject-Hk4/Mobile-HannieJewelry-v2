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

  int get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Fetch cart from API
  Future<void> fetchCart() async {
    try {
      final response = await _apiService.get('cart');
      final List<dynamic> cartData = response['items'];
      _items = cartData.map((item) => CartItem.fromMap(item)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching cart: $e');
    }
  }

  // Add product to cart
  Future<void> addItem(String id, String name, int price, String image) async {
    try {
      final response = await _apiService.post('cart/add', {
        'product_id': id,
        'quantity': 1,
      });

      if (response['success']) {
        await fetchCart(); // Update cart from server
      }
    } catch (e) {
      print('Error adding to cart: $e');
      // Fallback: handle offline addition if API fails
      final existingItemIndex = _items.indexWhere((item) => item.id == id);

      if (existingItemIndex >= 0) {
        _items[existingItemIndex].quantity += 1;
      } else {
        _items.add(
          CartItem(
            id: id,
            name: name,
            price: price,
            image: image,
          ),
        );
      }
      notifyListeners();
    }
  }

  // Remove product from cart
  Future<void> removeItem(String id) async {
    try {
      final response = await _apiService.delete('cart/item/$id');
      if (response['success']) {
        await fetchCart(); // Update cart from server
      }
    } catch (e) {
      print('Error removing from cart: $e');
      // Fallback: handle offline removal if API fails
      _items.removeWhere((item) => item.id == id);
      notifyListeners();
    }
  }

  // Update product quantity
  Future<void> updateQuantity(String id, int quantity) async {
    try {
      final response = await _apiService.put('cart/update', {
        'product_id': id,
        'quantity': quantity,
      });

      if (response['success']) {
        await fetchCart(); // Update cart from server
      }
    } catch (e) {
      print('Error updating cart: $e');
      // Fallback: handle offline update if API fails
      final existingItemIndex = _items.indexWhere((item) => item.id == id);
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
      final response = await _apiService.delete('cart/clear');
      if (response['success']) {
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
