import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/airin_theme.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models.dart';
import '../providers.dart';
import '../widgets/product_card.dart';

class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key});

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'Semua'},
    {'id': 'ai', 'label': 'AI & Dev'},
    {'id': 'productivity', 'label': 'Produktivitas'},
    {'id': 'streaming', 'label': 'Hiburan'},
    {'id': 'games', 'label': 'Games'},
  ];

  final List<Map<String, String>> _sortOptions = [
    {'id': 'terpopuler', 'label': 'Terpopuler'},
    {'id': 'termurah', 'label': 'Harga Terendah'},
    {'id': 'termahal', 'label': 'Harga Tertinggi'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filter = ref.watch(catalogFilterProvider);
    final productsAsync = ref.watch(productsProvider);

    final bg = isDark ? AirinColors.darkBg : AirinColors.lightSecondaryBg;
    final textPrimary = isDark ? AirinColors.darkTextPrimary : AirinColors.lightTextPrimary;
    final textSecondary = isDark ? AirinColors.darkTextSecondary : AirinColors.lightTextSecondary;
    final border = isDark ? AirinColors.darkBorder : AirinColors.lightBorder;
    final cardBg = isDark ? AirinColors.darkCardElevated : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AirinColors.tealBrand,
          onRefresh: () async {
            ref.invalidate(productsProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Atlassian-Style Hero Header
              SliverToBoxAdapter(
                child: Container(
                  color: isDark ? AirinColors.darkCard : Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Breadcrumb
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.go('/'),
                            child: const Text(
                              'Beranda',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AirinColors.tealBrand,
                              ),
                            ),
                          ),
                          Text(
                            ' / ',
                            style: TextStyle(fontSize: 12, color: textSecondary),
                          ),
                          Text(
                            'Katalog',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Title
                      Text(
                        'Katalog',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Eksplor seluruh produk aplikasi dan hiburan premium dengan stok & harga live.',
                        style: TextStyle(
                          fontSize: 13,
                          color: textSecondary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Live price badge
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AirinColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Harga live diperbarui · Terverifikasi resmi',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Search Input
                      TextField(
                        controller: _searchController,
                        style: TextStyle(fontSize: 13, color: textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Cari aplikasi (Gemini, Netflix, Canva...)',
                          hintStyle: TextStyle(fontSize: 13, color: textSecondary),
                          prefixIcon: Icon(Icons.search, size: 18, color: textSecondary),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 16),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref.read(catalogFilterProvider.notifier).setSearchQuery('');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: isDark ? AirinColors.darkCardSecondary : const Color(0xFFF2F2F7),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          ref.read(catalogFilterProvider.notifier).setSearchQuery(val);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Filter Controls (Sticky-like bar)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Column(
                    children: [
                      // Category Filter Pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories.map((cat) {
                            final isSelected = filter.category == cat['id'];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(
                                  cat['label']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: isSelected
                                        ? (isDark ? Colors.black : Colors.white)
                                        : textPrimary,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (_) {
                                  ref.read(catalogFilterProvider.notifier).setCategory(cat['id']!);
                                },
                                backgroundColor: cardBg,
                                selectedColor: isDark ? Colors.white : const Color(0xFF1D1D1F),
                                showCheckmark: false,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: border),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Controls Row: Instant Switch & Sort By
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Instant Delivery Toggle
                          GestureDetector(
                            onTap: () {
                              ref.read(catalogFilterProvider.notifier).toggleInstantOnly();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: filter.instantOnly
                                    ? AirinColors.tealBrand.withValues(alpha: 0.15)
                                    : cardBg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: filter.instantOnly ? AirinColors.tealBrand : border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bolt_rounded,
                                    size: 14,
                                    color: filter.instantOnly ? AirinColors.tealBrand : textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Pengiriman Instan',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: filter.instantOnly ? FontWeight.bold : FontWeight.normal,
                                      color: filter.instantOnly ? AirinColors.tealBrand : textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Sort Dropdown
                          PopupMenuButton<String>(
                            initialValue: filter.sortBy,
                            onSelected: (val) {
                              ref.read(catalogFilterProvider.notifier).setSortBy(val);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: cardBg,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: border),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.sort_rounded, size: 14, color: textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    _sortOptions.firstWhere((s) => s['id'] == filter.sortBy)['label']!,
                                    style: TextStyle(fontSize: 11, color: textPrimary),
                                  ),
                                  Icon(Icons.arrow_drop_down, size: 16, color: textSecondary),
                                ],
                              ),
                            ),
                            itemBuilder: (context) {
                              return _sortOptions.map((opt) {
                                return PopupMenuItem<String>(
                                  value: opt['id'],
                                  child: Text(
                                    opt['label']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: filter.sortBy == opt['id'] ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Product Grid
              productsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(Icons.search_off_rounded, size: 48, color: textSecondary),
                            const SizedBox(height: 12),
                            Text(
                              'Produk tidak ditemukan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Coba gunakan kata kunci lain atau ubah filter.',
                              style: TextStyle(fontSize: 12, color: textSecondary),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final screenWidth = MediaQuery.of(context).size.width;
                  final crossAxisCount = screenWidth >= 1100 ? 4 : (screenWidth >= 700 ? 3 : 2);

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.95,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return ProductCard(product: product);
                        },
                        childCount: products.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(60),
                    child: Center(
                      child: CircularProgressIndicator(color: AirinColors.tealBrand),
                    ),
                  ),
                ),
                error: (err, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          const Text('Gagal memuat katalog produk'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => ref.invalidate(productsProvider),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
