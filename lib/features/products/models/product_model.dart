class Product {
  final String id;
  final String name;
  final int price;
  final String description;
  final String category;
  final List<String> images;
  final double rating;
  final int reviews;
  final bool inStock;
  final bool featured;
  final bool isNew;
  final String productType;
  final String productGroup;
  final List<String> sizes;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.rating,
    required this.reviews,
    required this.inStock,
    required this.featured,
    required this.isNew,
    required this.productType,
    required this.productGroup,
    this.sizes = const [],
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviews: map['reviews'] ?? 0,
      inStock: map['inStock'] ?? false,
      featured: map['featured'] ?? false,
      isNew: map['isNew'] ?? false,
      productType: map['productType'] ?? '',
      productGroup: map['productGroup'] ?? '',
      sizes: List<String>.from(map['sizes'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'images': images,
      'rating': rating,
      'reviews': reviews,
      'inStock': inStock,
      'featured': featured,
      'isNew': isNew,
      'productType': productType,
      'productGroup': productGroup,
      'sizes': sizes,
    };
  }
}