double _parseDouble(dynamic val, [double def = 0.0]) {
  if (val == null) return def;
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? def;
  return def;
}

int _parseInt(dynamic val, [int def = 0]) {
  if (val == null) return def;
  if (val is num) return val.toInt();
  if (val is String) return int.tryParse(val) ?? def;
  return def;
}

class ProductItem {
  final String id;
  final String name;
  final String category; // 'all' | 'ai' | 'streaming' | 'productivity' | 'games'
  final String tagline;
  final String description;
  final double originalPrice;
  final double salePrice;
  final String durationLabel;
  final List<String> features;
  final String activationMethod;
  final String warranty;
  final String stockStatus; // 'ready' | 'limited' | 'out'
  final int stockCount;
  final bool isPopular;
  final String? itemkuUrl;
  final double rating;
  final int soldCount;
  final bool isInstant;
  final String? image;

  const ProductItem({
    required this.id,
    required this.name,
    required this.category,
    this.tagline = '',
    this.description = '',
    required this.originalPrice,
    required this.salePrice,
    this.durationLabel = '1 bulan',
    this.features = const [],
    this.activationMethod = 'Instan via link / kredensial akun',
    this.warranty = 'Garansi penuh selama masa aktif',
    this.stockStatus = 'ready',
    this.stockCount = 10,
    this.isPopular = false,
    this.itemkuUrl,
    this.rating = 4.9,
    this.soldCount = 150,
    this.isInstant = true,
    this.image,
  });

  bool get isInStock => stockStatus != 'out' && stockCount > 0;

  int get discountPercent {
    if (originalPrice <= 0 || salePrice >= originalPrice) return 0;
    return (((originalPrice - salePrice) / originalPrice) * 100).round();
  }

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? 'ai',
      tagline: json['tagline']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      originalPrice: _parseDouble(json['originalPrice'] ?? json['original_price'], 0.0),
      salePrice: _parseDouble(json['salePrice'] ?? json['price'] ?? json['sale_price'], 0.0),
      durationLabel: json['durationLabel'] ?? json['duration_label']?.toString() ?? '1 bulan',
      features: (json['features'] as List?)?.map((e) => e.toString()).toList() ?? [],
      activationMethod: json['activationMethod'] ?? json['activation_method']?.toString() ?? 'Link aktivasi resmi',
      warranty: json['warranty']?.toString() ?? 'Garansi penuh',
      stockStatus: json['stockStatus'] ?? json['stock_status']?.toString() ?? 'ready',
      stockCount: _parseInt(json['stockCount'] ?? json['stock'], 10),
      isPopular: json['isPopular'] == true,
      itemkuUrl: json['itemkuUrl']?.toString(),
      rating: _parseDouble(json['rating'], 4.9),
      soldCount: _parseInt(json['soldCount'] ?? json['sold_count'], 100),
      isInstant: json['isInstant'] == true || json['is_instant'] == true,
      image: json['image']?.toString() ?? json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'tagline': tagline,
      'description': description,
      'originalPrice': originalPrice,
      'salePrice': salePrice,
      'durationLabel': durationLabel,
      'features': features,
      'activationMethod': activationMethod,
      'warranty': warranty,
      'stockStatus': stockStatus,
      'stockCount': stockCount,
      'isPopular': isPopular,
      'itemkuUrl': itemkuUrl,
      'rating': rating,
      'soldCount': soldCount,
      'isInstant': isInstant,
      'image': image,
    };
  }
}

class PatunganItem {
  final String id;
  final String name;
  final String category;
  final String type; // 'family_official' | 'private_profile' | 'team_workspace'
  final String typeLabel;
  final String tagline;
  final String description;
  final double originalFullPrice;
  final double pricePerUser;
  final String durationLabel;
  final int groupNumber;
  final int totalSlots;
  final int filledSlots;
  final List<String> features;
  final List<String> rules;
  final bool isHot;

  const PatunganItem({
    required this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.typeLabel,
    required this.tagline,
    required this.description,
    required this.originalFullPrice,
    required this.pricePerUser,
    required this.durationLabel,
    required this.groupNumber,
    required this.totalSlots,
    required this.filledSlots,
    required this.features,
    required this.rules,
    this.isHot = false,
  });

  int get remainingSlots => totalSlots - filledSlots;
  bool get isFull => filledSlots >= totalSlots;

  factory PatunganItem.fromJson(Map<String, dynamic> json) {
    return PatunganItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? 'ai',
      type: json['type']?.toString() ?? 'family_official',
      typeLabel: json['typeLabel'] ?? json['type_label']?.toString() ?? 'Resmi Family',
      tagline: json['tagline']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      originalFullPrice: _parseDouble(json['originalFullPrice'] ?? json['official_price'], 0.0),
      pricePerUser: _parseDouble(json['pricePerUser'] ?? json['price'], 0.0),
      durationLabel: json['durationLabel'] ?? json['duration_label']?.toString() ?? '1 bulan',
      groupNumber: _parseInt(json['groupNumber'] ?? json['group_number'], 1),
      totalSlots: _parseInt(json['totalSlots'] ?? json['total_slots'], 4),
      filledSlots: _parseInt(json['filledSlots'] ?? json['filled_slots'], 0),
      features: (json['features'] as List?)?.map((e) => e.toString()).toList() ?? [],
      rules: (json['rules'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isHot: json['isHot'] == true,
    );
  }
}

class OrderItem {
  final String orderId;
  final String productId;
  final String productName;
  final double amount;
  final int uniqueCode;
  final double totalAmount;
  final String customerName;
  final String customerContact;
  final String customerEmail;
  final String status; // 'unpaid' | 'paid' | 'active' | 'completed' | 'expired'
  final DateTime createdAt;
  final String? qrisString;
  final String? accountDetails;
  final String? warrantyInfo;

  const OrderItem({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.amount,
    required this.uniqueCode,
    required this.totalAmount,
    required this.customerName,
    required this.customerContact,
    required this.customerEmail,
    required this.status,
    required this.createdAt,
    this.qrisString,
    this.accountDetails,
    this.warrantyInfo,
  });
}
