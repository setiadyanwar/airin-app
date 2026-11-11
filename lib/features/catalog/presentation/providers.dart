import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../data/repository.dart';

// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark); // Default dark mode ala Airin Store Apple style

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

// Products Filter State
class CatalogFilterState {
  final String category;
  final String searchQuery;
  final String sortBy;
  final bool instantOnly;

  const CatalogFilterState({
    this.category = 'all',
    this.searchQuery = '',
    this.sortBy = 'terpopuler',
    this.instantOnly = false,
  });

  CatalogFilterState copyWith({
    String? category,
    String? searchQuery,
    String? sortBy,
    bool? instantOnly,
  }) {
    return CatalogFilterState(
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      instantOnly: instantOnly ?? this.instantOnly,
    );
  }
}

final catalogFilterProvider = StateNotifierProvider<CatalogFilterNotifier, CatalogFilterState>((ref) {
  return CatalogFilterNotifier();
});

class CatalogFilterNotifier extends StateNotifier<CatalogFilterState> {
  CatalogFilterNotifier() : super(const CatalogFilterState());

  void setCategory(String category) {
    state = state.copyWith(category: category);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void toggleInstantOnly() {
    state = state.copyWith(instantOnly: !state.instantOnly);
  }

  void reset() {
    state = const CatalogFilterState();
  }
}

// Products Provider
final productsProvider = FutureProvider<List<ProductItem>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final filter = ref.watch(catalogFilterProvider);
  return repository.getProducts(
    category: filter.category,
    search: filter.searchQuery,
    sortBy: filter.sortBy,
    instantOnly: filter.instantOnly,
  );
});

// Single Product Provider
final productDetailProvider = FutureProvider.family<ProductItem?, String>((ref, id) async {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.getProduct(id);
});

// Patungan List Provider
final patunganListProvider = FutureProvider<List<PatunganItem>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.getPatunganList();
});

// Local Orders / History Provider
final orderHistoryProvider = StateNotifierProvider<OrderHistoryNotifier, List<OrderItem>>((ref) {
  return OrderHistoryNotifier();
});

class OrderHistoryNotifier extends StateNotifier<List<OrderItem>> {
  OrderHistoryNotifier() : super([
    OrderItem(
      orderId: 'INV-AIRIN-89211',
      productId: 'gemini-pro-18m',
      productName: 'Google Gemini Pro 18 Bulan',
      amount: 23000,
      uniqueCode: 147,
      totalAmount: 23147,
      customerName: 'Setiady',
      customerContact: '081234567890',
      customerEmail: 'setiady@gmail.com',
      status: 'active',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      accountDetails: 'Klaim link aktivasi resmi telah sukses terhubung ke email Anda.',
      warrantyInfo: 'Garansi resmi 18 bulan aktif hingga 2028.',
    ),
  ]);

  void addOrder(OrderItem order) {
    state = [order, ...state];
  }
}

// User Profile & Auth Provider ala airin-store AuthContext
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final double? kreapayBalance;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role = 'customer',
    this.kreapayBalance = 150000.0,
  });

  double get balance => kreapayBalance ?? 150000.0;

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    double? kreapayBalance,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      kreapayBalance: kreapayBalance ?? balance,
    );
  }
}

class AuthNotifier extends StateNotifier<UserProfile?> {
  AuthNotifier()
      : super(const UserProfile(
          id: 'user_1',
          name: 'Setiady',
          email: 'setiady@gmail.com',
          phone: '081234567890',
          role: 'customer',
          kreapayBalance: 150000.0,
        ));

  void login(String name, String email, String? phone) {
    state = UserProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name.isNotEmpty ? name : 'Pelanggan Airin',
      email: email,
      phone: phone,
      role: 'customer',
      kreapayBalance: 150000.0,
    );
  }

  void topUpKreaPay(double amount) {
    if (state != null) {
      state = state!.copyWith(kreapayBalance: state!.balance + amount);
    }
  }

  void deductKreaPay(double amount) {
    if (state != null && state!.balance >= amount) {
      state = state!.copyWith(kreapayBalance: state!.balance - amount);
    }
  }

  void logout() {
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserProfile?>((ref) {
  return AuthNotifier();
});

