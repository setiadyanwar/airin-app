import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/shell/presentation/pages/shell_page.dart';
import 'features/catalog/presentation/pages/catalog_page.dart';
import 'features/catalog/presentation/pages/product_detail_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellPage(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home (redirects to Catalog)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const CatalogPage(),
              ),
              GoRoute(
                path: '/product/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ProductDetailPage(productId: id);
                },
              ),
            ],
          ),
          // Tab 1: Catalog
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/catalog',
                builder: (context, state) => const CatalogPage(),
              ),
              GoRoute(
                path: '/catalog/product/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ProductDetailPage(productId: id);
                },
              ),
            ],
          ),
          // Tab 2: Cart (placeholder)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const _PlaceholderPage(
                  title: 'Keranjang',
                  icon: Icons.shopping_cart_outlined,
                  message: 'Fitur keranjang akan segera hadir',
                ),
              ),
            ],
          ),
          // Tab 3: Profile (placeholder)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const _PlaceholderPage(
                  title: 'Profil',
                  icon: Icons.person_outline,
                  message: 'Silakan login untuk mengakses profil',
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;

  const _PlaceholderPage({
    required this.title,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 80,
                color: isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark
                      ? Colors.white.withOpacity(0.5)
                      : Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}