import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../data/repository.dart';

final productsProvider = NotifierProvider<ProductsNotifier, ProductsState>(ProductsNotifier.new);

class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final int lastPage;
  final bool hasMore;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.lastPage = 1,
    this.hasMore = true,
  });

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    int? lastPage,
    bool? hasMore,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ProductsNotifier extends Notifier<ProductsState> {
  late final CatalogRepository _repository;

  @override
  ProductsState build() {
    _repository = ref.read(catalogRepositoryProvider);
    return const ProductsState();
  }

  Future<void> loadProducts({bool refresh = false, String? categoryId, String? search}) async {
    if (refresh) {
      state = state.copyWith(isLoading: true, error: null, products: [], currentPage: 1);
    } else if (state.isLoadingMore || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    try {
      final response = await _repository.getProducts(
        page: refresh ? 1 : state.currentPage,
        categoryId: categoryId,
        search: search,
      );

      final newProducts = refresh ? response.data : [...state.products, ...response.data];
      state = state.copyWith(
        products: newProducts,
        isLoading: false,
        isLoadingMore: false,
        currentPage: response.currentPage,
        lastPage: response.lastPage,
        hasMore: response.currentPage < response.lastPage,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh({String? categoryId, String? search}) async {
    await loadProducts(refresh: true, categoryId: categoryId, search: search);
  }
}

// Product Detail - use FutureProvider.family for simple async loading with parameter
final productDetailProvider = FutureProvider.family<Product, String>((ref, productId) async {
  final repository = ref.read(catalogRepositoryProvider);
  return repository.getProduct(productId);
});

final categoriesProvider = NotifierProvider<CategoriesNotifier, CategoriesState>(CategoriesNotifier.new);

class CategoriesState {
  final List<Category> categories;
  final bool isLoading;
  final String? error;

  const CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoriesState copyWith({
    List<Category>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CategoriesNotifier extends Notifier<CategoriesState> {
  late final CatalogRepository _repository;

  @override
  CategoriesState build() {
    _repository = ref.read(catalogRepositoryProvider);
    loadCategories();
    return const CategoriesState();
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final categories = await _repository.getCategories();
      state = state.copyWith(categories: categories, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}