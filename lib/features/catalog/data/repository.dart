import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'store_data.dart';
import '../../../core/network/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(ref.read(apiServiceProvider));
});

class CatalogRepository {
  final ApiService _apiService;

  CatalogRepository(this._apiService);

  Future<List<ProductItem>> getProducts({
    String? category,
    String? search,
    String? sortBy,
    bool instantOnly = false,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category != 'all') queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['q'] = search;

      final response = await _apiService.get('/products', queryParameters: queryParams);
      if (response['success'] == true && response['products'] is List) {
        final list = (response['products'] as List)
            .map((item) => ProductItem.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();

        return _applyFilters(list, category, search, sortBy, instantOnly);
      }
    } catch (_) {
      // Fallback to rich seed data on connection failure
    }

    // Fallback to local high-fidelity seed data
    return _applyFilters(
      List.from(AirinSeedData.initialProducts),
      category,
      search,
      sortBy,
      instantOnly,
    );
  }

  List<ProductItem> _applyFilters(
    List<ProductItem> list,
    String? category,
    String? search,
    String? sortBy,
    bool instantOnly,
  ) {
    var filtered = list;

    if (category != null && category != 'all') {
      filtered = filtered.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.tagline.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q);
      }).toList();
    }

    if (instantOnly) {
      filtered = filtered.where((p) => p.isInstant).toList();
    }

    if (sortBy != null) {
      switch (sortBy) {
        case 'termurah':
        case 'price_asc':
          filtered.sort((a, b) => a.salePrice.compareTo(b.salePrice));
          break;
        case 'termahal':
        case 'price_desc':
          filtered.sort((a, b) => b.salePrice.compareTo(a.salePrice));
          break;
        case 'terpopuler':
        case 'popular':
          filtered.sort((a, b) => b.soldCount.compareTo(a.soldCount));
          break;
        default:
          break;
      }
    }

    return filtered;
  }

  Future<ProductItem?> getProduct(String id) async {
    final products = await getProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<PatunganItem>> getPatunganList() async {
    try {
      final response = await _apiService.get('/patungan');
      if (response['success'] == true && response['patungan'] is List) {
        return (response['patungan'] as List)
            .map((item) => PatunganItem.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
    } catch (_) {
      // Offline fallback
    }
    return List.from(AirinSeedData.initialPatungan);
  }
}
