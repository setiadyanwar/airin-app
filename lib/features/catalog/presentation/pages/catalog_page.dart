import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../providers.dart';
import '../../data/models.dart';

class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key});

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedCategoryId;
  String _searchQuery = '';
  String _sortBy = 'terbaru';
  bool _filterInstantOnly = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsProvider.notifier).loadProducts();
      ref.read(categoriesProvider.notifier).loadCategories();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(productsProvider.notifier).loadProducts(
        categoryId: _selectedCategoryId,
        search: _searchQuery,
        sortBy: _sortBy,
        instantOnly: _filterInstantOnly,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final categoriesState = ref.watch(categoriesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121214) : const Color(0xFFF5F5F7);
    final surfaceColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final primaryColor = const Color(0xFF4082E6);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final textSecondary = isDark ? const Color(0xFF86868B) : const Color(0xFF6E6E73);
    final borderColor = isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Airin Store'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(productsProvider.notifier).refresh(
              categoryId: _selectedCategoryId,
              search: _searchQuery,
              sortBy: _sortBy,
              instantOnly: _filterInstantOnly,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(productsProvider.notifier).refresh(
          categoryId: _selectedCategoryId,
          search: _searchQuery,
          sortBy: _sortBy,
          instantOnly: _filterInstantOnly,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Hero Section
            SliverToBoxAdapter(
              child: Container(
                color: surfaceColor,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumb
                    Row(
                      children: [
                        Text(
                          'Beranda',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
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
                            fontWeight: FontWeight.w500,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      'Katalog',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.96,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Eksplor seluruh produk aplikasi dan hiburan premium dengan stok & harga live.',
                      style: TextStyle(
                        fontSize: 15,
                        color: textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Search Bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari produk...',
                        prefixIcon: Icon(Icons.search, color: textSecondary),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _searchQuery = value;
                      },
                      onSubmitted: (value) {
                        _searchQuery = value;
                        ref.read(productsProvider.notifier).refresh(
                          categoryId: _selectedCategoryId,
                          search: value,
                          sortBy: _sortBy,
                          instantOnly: _filterInstantOnly,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Filter Bar
                    _FilterBar(
                      selectedCategoryId: _selectedCategoryId,
                      categories: categoriesState.categories,
                      sortBy: _sortBy,
                      filterInstantOnly: _filterInstantOnly,
                      onCategoryChanged: (id) {
                        setState(() => _selectedCategoryId = id);
                        ref.read(productsProvider.notifier).refresh(
                          categoryId: id,
                          search: _searchQuery,
                          sortBy: _sortBy,
                          instantOnly: _filterInstantOnly,
                        );
                      },
                      onSortChanged: (value) {
                        setState(() => _sortBy = value);
                        ref.read(productsProvider.notifier).refresh(
                          categoryId: _selectedCategoryId,
                          search: _searchQuery,
                          sortBy: value,
                          instantOnly: _filterInstantOnly,
                        );
                      },
                      onInstantToggle: (value) {
                        setState(() => _filterInstantOnly = value);
                        ref.read(productsProvider.notifier).refresh(
                          categoryId: _selectedCategoryId,
                          search: _searchQuery,
                          sortBy: _sortBy,
                          instantOnly: value,
                        );
                      },
                      primaryColor: primaryColor,
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      borderColor: borderColor,
                    ),
                  ],
                ),
              ),
            ),

            // Products Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: _buildProductsGrid(productsState, isDark, surfaceColor, textPrimary, textSecondary, borderColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(
    ProductsState state,
    bool isDark,
    Color surfaceColor,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
  ) {
    if (state.isLoading && state.products.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: const Color(0xFF4082E6))),
      );
    }

    if (state.error != null && state.products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text('Error: ${state.error}', style: TextStyle(color: textSecondary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(productsProvider.notifier).refresh(
                  categoryId: _selectedCategoryId,
                  search: _searchQuery,
                  sortBy: _sortBy,
                  instantOnly: _filterInstantOnly,
                ),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.filter_alt_outlined,
                size: 48,
                color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ada produk ditemukan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Coba pilih kategori lain atau reset pencarian',
                style: TextStyle(fontSize: 14, color: textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= state.products.length) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(strokeWidth: 2),
            ));
          }
          final product = state.products[index];
          return _ProductCard(
            product: product,
            isDark: isDark,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            borderColor: borderColor,
          );
        },
        childCount: state.products.length + (state.isLoadingMore ? 1 : 0),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String? selectedCategoryId;
  final List<Category> categories;
  final String sortBy;
  final bool filterInstantOnly;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<bool> onInstantToggle;
  final Color primaryColor;
  final bool isDark;
  final Color surfaceColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;

  const _FilterBar({
    required this.selectedCategoryId,
    required this.categories,
    required this.sortBy,
    required this.filterInstantOnly,
    required this.onCategoryChanged,
    required this.onSortChanged,
    required this.onInstantToggle,
    required this.primaryColor,
    required this.isDark,
    required this.surfaceColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category Chips
        if (categories.isNotEmpty)
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              children: [
                _CategoryChip(
                  label: 'Semua',
                  isSelected: selectedCategoryId == null,
                  onTap: () => onCategoryChanged(null),
                  primaryColor: primaryColor,
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                ),
                const SizedBox(width: 8),
                ...categories.map((category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _CategoryChip(
                        label: category.name,
                        isSelected: selectedCategoryId == category.id,
                        onTap: () => onCategoryChanged(category.id),
                        primaryColor: primaryColor,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        borderColor: borderColor,
                      ),
                    )),
              ],
            ),
          ),

        const SizedBox(height: 12),

        // Sort + Instant Filter Row
        Row(
          children: [
            // Sort Dropdown
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: sortBy,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, size: 20, color: textSecondary),
                    style: TextStyle(fontSize: 13, color: textPrimary, fontWeight: FontWeight.w500),
                    dropdownColor: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    items: const [
                      DropdownMenuItem(value: 'terbaru', child: Text('Terbaru')),
                      DropdownMenuItem(value: 'termurah', child: Text('Termurah')),
                      DropdownMenuItem(value: 'termahal', child: Text('Termahal')),
                      DropdownMenuItem(value: 'terlaris', child: Text('Terlaris')),
                    ],
                    onChanged: (value) => onSortChanged(value!),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Instant Filter Toggle
            InkWell(
              onTap: () => onInstantToggle(!filterInstantOnly),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: filterInstantOnly ? primaryColor.withOpacity(0.1) : surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: filterInstantOnly ? primaryColor : borderColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.flash_on,
                      size: 18,
                      color: filterInstantOnly ? primaryColor : textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Instan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: filterInstantOnly ? primaryColor : textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color primaryColor;
  final bool isDark;
  final Color surfaceColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
    required this.isDark,
    required this.surfaceColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label, style: TextStyle(fontSize: 13)),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: primaryColor.withOpacity(0.12),
      checkmarkColor: primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? primaryColor : textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      backgroundColor: surfaceColor,
      side: BorderSide(
        color: isSelected ? primaryColor : borderColor,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final bool isDark;
  final Color surfaceColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;

  const _ProductCard({
    required this.product,
    required this.isDark,
    required this.surfaceColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final imageUrl = product.thumbnailUrl ?? product.imageUrl;
    final isInstant = product.type == 'instant' || product.name.toLowerCase().contains('instan');
    final isOutOfStock = !product.isInStock;
    final savingsPercent = product.originalPrice != null && product.originalPrice! > product.price
        ? ((product.originalPrice! - product.price) / product.originalPrice! * 100).round()
        : 0;

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + Badges
            Stack(
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                              child: Icon(Icons.image_not_supported, size: 48, color: textSecondary.withOpacity(0.5)),
                            ),
                          )
                        : Container(
                            color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                            child: Icon(Icons.image_not_supported, size: 48, color: textSecondary.withOpacity(0.5)),
                          ),
                  ),
                ),
                // Instan Badge
                if (isInstant)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.flash_on, size: 10, color: Colors.white),
                          const SizedBox(width: 3),
                          const Text(
                            'Instan',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Out of Stock Overlay
                if (isOutOfStock)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Stok Habis',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo/Icon Container (like web)
                    if (imageUrl != null && !isInstant) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.extension,
                              size: 18,
                              color: textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Name
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Tagline (if available)
                    if (product.tagline != null && product.tagline!.isNotEmpty)
                      Text(
                        product.tagline!,
                        style: TextStyle(
                          fontSize: 11,
                          color: textSecondary,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    const Spacer(),

                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.originalPrice != null && product.originalPrice! > product.price) ...[
                          Text(
                            formatter.format(product.originalPrice!),
                            style: TextStyle(
                              fontSize: 11,
                              color: textSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Row(
                          children: [
                            Text(
                              formatter.format(product.price),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF4082E6),
                              ),
                            ),
                            if (savingsPercent > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Hemat $savingsPercent%',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (product.durationLabel != null && product.durationLabel!.isNotEmpty)
                          Text(
                            '/ ${product.durationLabel}',
                            style: TextStyle(
                              fontSize: 11,
                              color: textSecondary,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Rating & Sold Count
                    if ((product.rating != null && product.rating! > 0) || product.soldCount > 0)
                      Row(
                        children: [
                          if (product.rating != null && product.rating! > 0) ...[
                            const Icon(Icons.star, size: 13, color: Colors.amber),
                            const SizedBox(width: 3),
                            Text(
                              product.rating!.toStringAsFixed(1),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textPrimary),
                            ),
                            if (product.soldCount > 0) ...[
                              const SizedBox(width: 4),
                              Text(
                                '(${product.soldCount} terjual)',
                                style: TextStyle(fontSize: 11, color: textSecondary),
                              ),
                            ],
                          ] else if (product.soldCount > 0) ...[
                            Text(
                              '${product.soldCount} terjual',
                              style: TextStyle(fontSize: 11, color: textSecondary),
                            ),
                          ],
                        ],
                      ),

                    const SizedBox(height: 12),

                    // CTA Button - "Lihat detail"
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isOutOfStock ? null : () => context.push('/product/${product.id}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOutOfStock
                              ? (isDark ? Colors.grey[800] : Colors.grey[200])
                              : const Color(0xFF4082E6),
                          foregroundColor: isOutOfStock
                              ? (isDark ? Colors.grey[500] : Colors.grey[600])
                              : Colors.white,
                          disabledBackgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                          disabledForegroundColor: isDark ? Colors.grey[500] : Colors.grey[600],
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(isOutOfStock ? 'Stok Habis' : 'Lihat detail'),
                            if (!isOutOfStock) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward, size: 16),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}