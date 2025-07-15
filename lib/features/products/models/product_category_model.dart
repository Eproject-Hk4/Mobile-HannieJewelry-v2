class ProductCategory {
  final String id;
  final String name;
  final String image;
  final int count;

  ProductCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.count,
  });

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      count: map['count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'count': count,
    };
  }
}