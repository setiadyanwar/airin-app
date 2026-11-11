import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../data/models.dart';
import '../../../core/network/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(ref.read(apiServiceProvider));
});

class CatalogRepository {
  final ApiService _apiService;

  CatalogRepository(this._apiService);

  Future<PaginatedResponse<Product>> getProducts({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (categoryId != null) queryParams['category_id'] = categoryId;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await _apiService.get('/products', queryParameters: queryParams);
    return PaginatedResponse.fromJson(
      response,
      (json) => Product.fromJson(json),
    );
  }

  Future<Product> getProduct(String id) async {
    final response = await _apiService.get('/products/$id');
    return Product.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<List<Category>> getCategories() async {
    final response = await _apiService.get('/categories');
    final data = response['data'] as List?;
    return data?.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList() ?? [];
  }
}