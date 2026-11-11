class Product {
  final String id;
  final String name;
  final String? description;
  final String? longDescription;
  final String? imageUrl;
  final String? thumbnailUrl;
  final double price;
  final double? originalPrice;
  final int stock;
  final String stockStatus;
  final double? rating;
  final int soldCount;
  final bool isInstant;
  final String type;
  final String? categoryId;
  final String? categoryName;
  final List<String>? features;
  final List<ProductVariant> variants;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? supportInfo;

  const Product({
    required this.id,
    required this.name,
    this.description,
    this.longDescription,
    this.imageUrl,
    this.thumbnailUrl,
    required this.price,
    this.originalPrice,
    required this.stock,
    required this.stockStatus,
    this.rating,
    this.soldCount = 0,
    required this.isInstant,
    required this.type,
    this.categoryId,
    this.categoryName,
    this.features,
    this.variants = const [],
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.supportInfo,
  });

  bool get isPatungan => type == 'patungan';
  bool get isInStock => stock > 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      longDescription: json['long_description']?.toString(),
      imageUrl: json['image_url']?.toString(),
      thumbnailUrl: json['thumbnail_url']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      stockStatus: json['stock_status']?.toString() ?? 'out_of_stock',
      rating: (json['rating'] as num?)?.toDouble(),
      soldCount: (json['sold_count'] as num?)?.toInt() ?? 0,
      isInstant: json['is_instant'] == true,
      type: json['type']?.toString() ?? 'regular',
      categoryId: json['category_id']?.toString(),
      categoryName: json['category_name']?.toString(),
      features: (json['features'] as List?)?.map((e) => e.toString()).toList(),
      variants: (json['variants'] as List?)
          ?.map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      isActive: json['is_active'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      supportInfo: json['support_info']?.toString(),
    );
  }
}

class ProductVariant {
  final String id;
  final String productId;
  final String name;
  final String? sku;
  final double price;
  final double? originalPrice;
  final int stock;
  final bool isActive;
  final Map<String, dynamic>? attributes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductVariant({
    required this.id,
    required this.productId,
    required this.name,
    this.sku,
    required this.price,
    this.originalPrice,
    required this.stock,
    required this.isActive,
    this.attributes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isInStock => stock > 0;

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] == true,
      attributes: json['attributes'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class Category {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? parentId;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.parentId,
    required this.sortOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
      parentId: json['parent_id']?.toString(),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? prevPageUrl;

  const PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
      firstPageUrl: json['first_page_url']?.toString(),
      lastPageUrl: json['last_page_url']?.toString(),
      nextPageUrl: json['next_page_url']?.toString(),
      prevPageUrl: json['prev_page_url']?.toString(),
    );
  }
}