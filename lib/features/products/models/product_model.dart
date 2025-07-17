class Product {
  final String id;
  final String title;
  final String bodyHtml;
  final String bodyPlain;
  final String handle;
  final List<String> images;
  final bool notAllowPromotion;
  final bool onlyHideFromList;
  final List<ProductOption> options;
  final String productType;
  final String publishedAt;
  final String publishedScope;
  final String tags;
  final String templateSuffix;
  final String updatedAt;
  final String createdAt;
  final List<ProductVariant> variants;
  final String vendor;

  Product({
    required this.id,
    required this.title,
    required this.bodyHtml,
    required this.bodyPlain,
    required this.handle,
    required this.images,
    required this.notAllowPromotion,
    required this.onlyHideFromList,
    required this.options,
    required this.productType,
    required this.publishedAt,
    required this.publishedScope,
    required this.tags,
    required this.templateSuffix,
    required this.updatedAt,
    required this.createdAt,
    required this.variants,
    required this.vendor,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      bodyHtml: map['body_html'] ?? '',
      bodyPlain: map['body_plain'] ?? '',
      handle: map['handle'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      notAllowPromotion: map['not_allow_promotion'] ?? false,
      onlyHideFromList: map['only_hide_from_list'] ?? false,
      options: List<ProductOption>.from(
          (map['options'] ?? []).map((x) => ProductOption.fromMap(x))),
      productType: map['product_type'] ?? '',
      publishedAt: map['published_at'] ?? '',
      publishedScope: map['published_scope'] ?? '',
      tags: map['tags'] ?? '',
      templateSuffix: map['template_suffix'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      createdAt: map['created_at'] ?? '',
      variants: List<ProductVariant>.from(
          (map['variants'] ?? []).map((x) => ProductVariant.fromMap(x))),
      vendor: map['vendor'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body_html': bodyHtml,
      'body_plain': bodyPlain,
      'handle': handle,
      'images': images,
      'not_allow_promotion': notAllowPromotion,
      'only_hide_from_list': onlyHideFromList,
      'options': options.map((x) => x.toMap()).toList(),
      'product_type': productType,
      'published_at': publishedAt,
      'published_scope': publishedScope,
      'tags': tags,
      'template_suffix': templateSuffix,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'variants': variants.map((x) => x.toMap()).toList(),
      'vendor': vendor,
    };
  }
}

class ProductOption {
  final String id;
  final String name;
  final int position;
  final String productId;

  ProductOption({
    required this.id,
    required this.name,
    required this.position,
    required this.productId,
  });

  factory ProductOption.fromMap(Map<String, dynamic> map) {
    return ProductOption(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      position: map['position'] ?? 0,
      productId: map['product_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'product_id': productId,
    };
  }
}

class ProductVariant {
  final int id;
  final String barcode;
  final double compareAtPrice;
  final String createdAt;
  final String fulfillmentService;
  final double grams;
  final String? imageId;
  final InventoryAdvance inventoryAdvance;
  final String inventoryManagement;
  final String inventoryPolicy;
  final int inventoryQuantity;
  final String option1;
  final String? option2;
  final String? option3;
  final int position;
  final double price;
  final String productId;
  final bool requiresShipping;
  final String sku;
  final bool taxable;
  final String title;
  final String updatedAt;

  ProductVariant({
    required this.id,
    required this.barcode,
    required this.compareAtPrice,
    required this.createdAt,
    required this.fulfillmentService,
    required this.grams,
    this.imageId,
    required this.inventoryAdvance,
    required this.inventoryManagement,
    required this.inventoryPolicy,
    required this.inventoryQuantity,
    required this.option1,
    this.option2,
    this.option3,
    required this.position,
    required this.price,
    required this.productId,
    required this.requiresShipping,
    required this.sku,
    required this.taxable,
    required this.title,
    required this.updatedAt,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      id: map['id'] ?? 0,
      barcode: map['barcode'] ?? '',
      compareAtPrice: (map['compare_at_price'] ?? 0.0).toDouble(),
      createdAt: map['created_at'] ?? '',
      fulfillmentService: map['fulfillment_service'] ?? '',
      grams: (map['grams'] ?? 0.0).toDouble(),
      imageId: map['image_id'],
      inventoryAdvance: InventoryAdvance.fromMap(map['inventory_advance'] ?? {}),
      inventoryManagement: map['inventory_management'] ?? '',
      inventoryPolicy: map['inventory_policy'] ?? '',
      inventoryQuantity: map['inventory_quantity'] ?? 0,
      option1: map['option1'] ?? '',
      option2: map['option2'],
      option3: map['option3'],
      position: map['position'] ?? 0,
      price: (map['price'] ?? 0.0).toDouble(),
      productId: map['product_id'] ?? '',
      requiresShipping: map['requires_shipping'] ?? false,
      sku: map['sku'] ?? '',
      taxable: map['taxable'] ?? false,
      title: map['title'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'compare_at_price': compareAtPrice,
      'created_at': createdAt,
      'fulfillment_service': fulfillmentService,
      'grams': grams,
      'image_id': imageId,
      'inventory_advance': inventoryAdvance.toMap(),
      'inventory_management': inventoryManagement,
      'inventory_policy': inventoryPolicy,
      'inventory_quantity': inventoryQuantity,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'position': position,
      'price': price,
      'product_id': productId,
      'requires_shipping': requiresShipping,
      'sku': sku,
      'taxable': taxable,
      'title': title,
      'updated_at': updatedAt,
    };
  }
}

class InventoryAdvance {
  final int qtyAvailable;
  final int qtyCommited;
  final int qtyIncoming;
  final int qtyOnhand;

  InventoryAdvance({
    required this.qtyAvailable,
    required this.qtyCommited,
    required this.qtyIncoming,
    required this.qtyOnhand,
  });

  factory InventoryAdvance.fromMap(Map<String, dynamic> map) {
    return InventoryAdvance(
      qtyAvailable: map['qty_available'] ?? 0,
      qtyCommited: map['qty_commited'] ?? 0,
      qtyIncoming: map['qty_incoming'] ?? 0,
      qtyOnhand: map['qty_onhand'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'qty_available': qtyAvailable,
      'qty_commited': qtyCommited,
      'qty_incoming': qtyIncoming,
      'qty_onhand': qtyOnhand,
    };
  }
}