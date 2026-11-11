import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/shell/presentation/pages/shell_page.dart';
import 'features/home/presentation/home_page.dart';
import 'features/catalog/presentation/pages/catalog_page.dart';
import 'features/catalog/presentation/pages/product_detail_page.dart';
import 'features/patungan/presentation/patungan_page.dart';
import 'features/history/presentation/history_page.dart';
import 'features/profile/presentation/profile_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellPage(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
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
            ],
          ),

          // Tab 2: Patungan
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/patungan',
                builder: (context, state) => const PatunganPage(),
              ),
            ],
          ),

          // Tab 3: History
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryPage(),
              ),
            ],
          ),

          // Tab 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
