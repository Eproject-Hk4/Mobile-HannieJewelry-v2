class CartItem {
  final String id;
  final String name;
  final int price;
  final String image;
  final String? size;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.size,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'size': size,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'] ?? 'assets/images/placeholder.png',
      size: map['size'],
      quantity: map['quantity'] ?? 1,
    );
  }
}