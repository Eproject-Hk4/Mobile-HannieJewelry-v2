class OrderItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'name': name,
      'image_url': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['product_id'],
      name: map['name'],
      imageUrl: map['image_url'] ?? 'assets/images/placeholder.png',
      price: (map['price'] is int) ? map['price'].toDouble() : map['price'],
      quantity: map['quantity'],
    );
  }
}

enum DeliveryMethod { delivery, pickup }
enum PaymentMethod { cod, bankTransfer }

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final double shippingFee;
  final DeliveryMethod deliveryMethod;
  final PaymentMethod paymentMethod;
  final String recipientName;
  final String recipientPhone;
  final String recipientAddress;
  final String? note;
  final String? pickupLocation;
  final DateTime? pickupTime;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.shippingFee,
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.recipientName,
    required this.recipientPhone,
    required this.recipientAddress,
    this.note,
    this.pickupLocation,
    this.pickupTime,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'total_amount': totalAmount,
      'shipping_fee': shippingFee,
      'delivery_method': deliveryMethod.toString().split('.').last,
      'payment_method': paymentMethod.toString().split('.').last,
      'recipient_name': recipientName,
      'recipient_phone': recipientPhone,
      'recipient_address': recipientAddress,
      'note': note,
      'pickup_location': pickupLocation,
      'pickup_time': pickupTime?.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      items: (map['items'] as List)
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      totalAmount: (map['total_amount'] is int)
          ? map['total_amount'].toDouble()
          : map['total_amount'],
      shippingFee: (map['shipping_fee'] is int)
          ? map['shipping_fee'].toDouble()
          : map['shipping_fee'],
      deliveryMethod: map['delivery_method'] == 'pickup'
          ? DeliveryMethod.pickup
          : DeliveryMethod.delivery,
      paymentMethod: map['payment_method'] == 'bankTransfer'
          ? PaymentMethod.bankTransfer
          : PaymentMethod.cod,
      recipientName: map['recipient_name'],
      recipientPhone: map['recipient_phone'],
      recipientAddress: map['recipient_address'] ?? '',
      note: map['note'],
      pickupLocation: map['pickup_location'],
      pickupTime: map['pickup_time'] != null
          ? DateTime.parse(map['pickup_time'])
          : null,
    );
  }
}