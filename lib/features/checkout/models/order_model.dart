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
}