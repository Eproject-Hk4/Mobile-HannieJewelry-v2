import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;


  

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  int get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem(String id, String name, int price, String image) {
    final existingItemIndex = _items.indexWhere((item) => item.id == id);

    if (existingItemIndex >= 0) {
      // Sản phẩm đã tồn tại trong giỏ hàng, tăng số lượng
      _items[existingItemIndex].quantity += 1;
    } else {
      // Thêm sản phẩm mới vào giỏ hàng
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

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    final existingItemIndex = _items.indexWhere((item) => item.id == id);
    if (existingItemIndex >= 0) {
      if (quantity <= 0) {
        removeItem(id);
      } else {
        _items[existingItemIndex].quantity = quantity;
        notifyListeners();
      }
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}