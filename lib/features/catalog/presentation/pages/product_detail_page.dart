import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../providers.dart';
import '../../data/models.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  ProductVariant? _selectedVariant;
  int _currentImageIndex = 0;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showStickyCheckout = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollController.hasClients &&
        _scrollController.offset > 300;
    if (show != _showStickyCheckout) {
      setState(() => _showStickyCheckout = show);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncProduct = ref.watch(productDetailProvider(widget.productId));
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121214) : const Color(0xFFF5F5F7);
    final surfaceColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final primaryColor = const Color(0xFF4082E6);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final textSecondary = isDark ? const Color(0xFF86868B) : const Color(0xFF6E6E73);
    final borderColor = isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: asyncProduct.when(
        loading: () => _buildLoading(isDark, surfaceColor),
        error: (error, stack) => _buildError(error, isDark, surfaceColor, textPrimary, textSecondary),
        data: (product) => _buildProductDetail(
          product,
          formatter,
          isDark,
          surfaceColor,
          primaryColor,
          textPrimary,
          textSecondary,
          borderColor,
        ),
      ),
      bottomNavigationBar: _showStickyCheckout
          ? _buildStickyCheckout(
              _selectedVariant?.price ?? ref.read(productDetailProvider(widget.productId)).value?.price ?? 0,
              _selectedVariant?.isInStock ?? ref.read(productDetailProvider(widget.productId)).value?.isInStock ?? false,
              ref.read(productDetailProvider(widget.productId)).value?.type == 'patungan',
              primaryColor,
              isDark,
              surfaceColor,
              textPrimary,
              textSecondary,
              borderColor,
            )
          : null,
    );
  }

  Widget _buildLoading(bool isDark, Color surfaceColor) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121214) : const Color(0xFFF5F5F7),
      body: Center(
        child: CircularProgressIndicator(color: const Color(0xFF4082E6)),
      ),
    );
  }

  Widget _buildError(
    Object error,
    bool isDark,
    Color surfaceColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121214) : const Color(0xFFF5F5F7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text('Error: $error', style: TextStyle(color: textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(productDetailProvider(widget.productId)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4082E6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetail(
    Product product,
    NumberFormat formatter,
    bool isDark,
    Color surfaceColor,
    Color primaryColor,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
  ) {
    final backgroundColor = isDark ? const Color(0xFF121214) : const Color(0xFFF5F5F7);
    final imageUrl = product.imageUrl ?? product.thumbnailUrl;
    final isPatungan = product.type == 'patungan';
    final showQuantity = !isPatungan;
    final price = _selectedVariant?.price ?? product.price;
    final originalPrice = _selectedVariant?.originalPrice ?? product.originalPrice;
    final stock = _selectedVariant?.stock ?? product.stock;
    final isInStock = (_selectedVariant?.isInStock ?? product.isInStock) && stock > 0;
    final images = <String>[];
    if (product.imageUrl != null) images.add(product.imageUrl!);
    if (product.thumbnailUrl != null && product.thumbnailUrl != product.imageUrl) {
      images.add(product.thumbnailUrl!);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with Breadcrumb
          SliverAppBar(
            pinned: true,
            floating: false,
            snap: false,
            elevation: 0,
            backgroundColor: surfaceColor,
            surfaceTintColor: surfaceColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textPrimary),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Detail Produk',
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: surfaceColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _BreadcrumbItem(
                      label: 'Beranda',
                      onTap: () => context.go('/'),
                      isDark: isDark,
                      textSecondary: textSecondary,
                    ),
                    _BreadcrumbSeparator(isDark: isDark, textSecondary: textSecondary),
                    _BreadcrumbItem(
                      label: 'Katalog',
                      onTap: () => context.go('/catalog'),
                      isDark: isDark,
                      textSecondary: textSecondary,
                    ),
                    _BreadcrumbSeparator(isDark: isDark, textSecondary: textSecondary),
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Image Gallery
          SliverToBoxAdapter(
            child: Container(
              color: surfaceColor,
              child: Column(
                children: [
                  // Main Image
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: images.isEmpty ? 1 : images.length,
                          onPageChanged: (index) => setState(() => _currentImageIndex = index),
                          itemBuilder: (context, index) {
                            if (images.isEmpty) {
                              return Container(
                                color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 64,
                                  color: textSecondary.withOpacity(0.5),
                                ),
                              );
                            }
                            return CachedNetworkImage(
                              imageUrl: images[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                                child: Icon(Icons.image_not_supported, size: 64, color: textSecondary.withOpacity(0.5)),
                              ),
                            );
                          },
                        ),
                        // Instan Badge
                        if (product.isInstant)
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.flash_on, size: 14, color: Colors.white),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Instan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        // Patungan Badge
                        if (isPatungan)
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'PATUNGAN',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        // Page Indicator
                        if (images.length > 1)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(images.length, (index) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                  ),
                                );
                              }),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Thumbnail Strip
                  if (images.length > 1)
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final isSelected = _currentImageIndex == index;
                          return GestureDetector(
                            onTap: () => setState(() => _currentImageIndex = index),
                            child: Container(
                              width: 64,
                              height: 64,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? primaryColor : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: images[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                                    child: Icon(Icons.image_not_supported, size: 24, color: textSecondary.withOpacity(0.5)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              color: backgroundColor,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Card (white card)
                  Container(
                    padding: const EdgeInsets.all(16),
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
                        // Name
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Rating & Sold
                        if (product.rating != null && product.rating! > 0) ...[
                          Row(
                            children: [
                              const Icon(Icons.star, size: 18, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                product.rating!.toStringAsFixed(1),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
                              ),
                              if (product.soldCount > 0) ...[
                                const SizedBox(width: 12),
                                Text(
                                  '${product.soldCount} terjual',
                                  style: TextStyle(fontSize: 14, color: textSecondary),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Tagline
                        if (product.tagline != null && product.tagline!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.tagline!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (originalPrice != null && originalPrice > price) ...[
                              Text(
                                formatter.format(originalPrice),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textSecondary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Text(
                              formatter.format(price),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ),
                            if (product.durationLabel != null && product.durationLabel!.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '/ ${product.durationLabel}',
                                  style: TextStyle(fontSize: 14, color: textSecondary),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Stock Status
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isInStock
                                    ? const Color(0xFF10B981).withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isInStock ? Icons.check_circle : Icons.cancel,
                                    size: 14,
                                    color: isInStock ? const Color(0xFF10B981) : Colors.red,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isInStock ? 'Stok tersedia ($stock)' : 'Stok habis',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isInStock ? const Color(0xFF10B981) : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Variant Selection
                  if (product.variants.isNotEmpty)
                    _VariantSelector(
                      variants: product.variants,
                      selectedVariant: _selectedVariant,
                      onVariantSelected: (variant) {
                        setState(() {
                          _selectedVariant = variant;
                          _quantity = 1;
                        });
                      },
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      primaryColor: primaryColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      borderColor: borderColor,
                    ),

                  const SizedBox(height: 16),

                  // Quantity Selector
                  if (showQuantity && isInStock)
                    _QuantitySelector(
                      quantity: _quantity,
                      maxQuantity: stock,
                      onChanged: (value) => setState(() => _quantity = value),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      primaryColor: primaryColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      borderColor: borderColor,
                    ),

                  const SizedBox(height: 16),

                  // Tabs
                  _DescriptionTabs(
                    tabController: _tabController,
                    product: product,
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    primaryColor: primaryColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    borderColor: borderColor,
                  ),

                  const SizedBox(height: 16),

                  // Trust Indicators
                  _TrustIndicators(
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    primaryColor: primaryColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    borderColor: borderColor,
                  ),

                  const SizedBox(height: 16),

                  // Support Info
                  if (product.supportInfo != null && product.supportInfo!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.support_agent, color: primaryColor, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              product.supportInfo!,
                              style: TextStyle(fontSize: 13, color: textSecondary, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Sticky Checkout Placeholder (visible when not sticky)
                  if (!_showStickyCheckout)
                    _buildStickyCheckout(
                      price,
                      isInStock,
                      isPatungan,
                      primaryColor,
                      isDark,
                      surfaceColor,
                      textPrimary,
                      textSecondary,
                      borderColor,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyCheckout(
    double price,
    bool isInStock,
    bool isPatungan,
    Color primaryColor,
    bool isDark,
    Color surfaceColor,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Price
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 12, color: textSecondary),
                ),
                Text(
                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(price * _quantity),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Buy Button
            Expanded(
              child: ElevatedButton(
                onPressed: isInStock ? _handleBuy : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInStock ? primaryColor : (isDark ? Colors.grey[800] : Colors.grey[300]),
                  foregroundColor: isInStock ? Colors.white : (isDark ? Colors.grey[500] : Colors.grey[600]),
                  disabledBackgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                  disabledForegroundColor: isDark ? Colors.grey[500] : Colors.grey[600],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isPatungan ? 'Beli Slot Patungan' : 'Beli Sekarang'),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBuy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checkout untuk ${_selectedVariant?.name ?? 'produk'} x $_quantity - Coming soon'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _BreadcrumbItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final Color textSecondary;

  const _BreadcrumbItem({
    required this.label,
    required this.onTap,
    required this.isDark,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textSecondary,
          ),
        ),
      ),
    );
  }
}

class _BreadcrumbSeparator extends StatelessWidget {
  final bool isDark;
  final Color textSecondary;

  const _BreadcrumbSeparator({required this.isDark, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text('/', style: TextStyle(fontSize: 12, color: textSecondary.withOpacity(0.5))),
    );
  }
}

class _VariantSelector extends StatelessWidget {
  final List<ProductVariant> variants;
  final ProductVariant? selectedVariant;
  final ValueChanged<ProductVariant> onVariantSelected;
  final bool isDark;
  final Color surfaceColor;
  final Color primaryColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;

  const _VariantSelector({
    required this.variants,
    required this.selectedVariant,
    required this.onVariantSelected,
    required this.isDark,
    required this.surfaceColor,
    required this.primaryColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Varian',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: variants.map((variant) {
              final isSelected = selectedVariant?.id == variant.id;
              final variantInStock = variant.isInStock && variant.stock > 0;
              return FilterChip(
                label: Text(
                  variant.name,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                selected: isSelected,
                onSelected: variantInStock
                    ? (selected) {
                        if (selected) onVariantSelected(variant);
                      }
                    : null,
                selectedColor: primaryColor.withOpacity(0.12),
                checkmarkColor: primaryColor,
                labelStyle: TextStyle(
                  color: variantInStock
                      ? (isSelected ? primaryColor : textPrimary)
                      : textSecondary.withOpacity(0.5),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                backgroundColor: variantInStock ? surfaceColor : (isDark ? Colors.grey[800] : Colors.grey[100]),
                side: BorderSide(
                  color: isSelected ? primaryColor : borderColor,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;
  final bool isDark;
  final Color surfaceColor;
  final Color primaryColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;

  const _QuantitySelector({
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
    required this.isDark,
    required this.surfaceColor,
    required this.primaryColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jumlah',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _QtyButton(
                icon: Icons.remove,
                onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
                isDark: isDark,
                surfaceColor: surfaceColor,
                primaryColor: primaryColor,
                textSecondary: textSecondary,
                borderColor: borderColor,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$quantity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ),
              ),
              _QtyButton(
                icon: Icons.add,
                onPressed: quantity < maxQuantity ? () => onChanged(quantity + 1) : null,
                isDark: isDark,
                surfaceColor: surfaceColor,
                primaryColor: primaryColor,
                textSecondary: textSecondary,
                borderColor: borderColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDark;
  final Color surfaceColor;
  final Color primaryColor;
  final Color textSecondary;
  final Color borderColor;

  const _QtyButton({
    required this.icon,
    this.onPressed,
    required this.isDark,
    required this.surfaceColor,
    required this.primaryColor,
    required this.textSecondary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 22),
      style: IconButton.styleFrom(
        backgroundColor: enabled ? surfaceColor : (isDark ? Colors.grey[800] : Colors.grey[100]),
        foregroundColor: enabled ? primaryColor : textSecondary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: enabled ? borderColor : Colors.transparent,
          ),
        ),
        minimumSize: const Size(48, 48),
      ),
    );
  }
}

class _DescriptionTabs extends StatelessWidget {
  final TabController tabController;
  final Product product;
  final bool isDark;
  final Color surfaceColor;
  final Color primaryColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;

  const _DescriptionTabs({
    required this.tabController,
    required this.product,
    required this.isDark,
    required this.surfaceColor,
    required this.primaryColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            labelColor: primaryColor,
            unselectedLabelColor: textSecondary,
            indicatorColor: primaryColor,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            dividerColor: borderColor,
            tabs: const [
              Tab(text: 'Deskripsi'),
              Tab(text: 'Manfaat'),
              Tab(text: 'Spesifikasi'),
            ],
          ),
          SizedBox(
            height: 200,
            child: TabBarView(
              controller: tabController,
              children: [
                _buildTabContent(product.description ?? product.longDescription, 'Belum ada deskripsi tersedia.'),
                _buildBenefits(product),
                _buildSpecs(product),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String? content, String fallback) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        content ?? fallback,
        style: TextStyle(fontSize: 14, height: 1.6, color: textPrimary),
      ),
    );
  }

  Widget _buildBenefits(Product product) {
    final benefits = <String>[];
    if (product.features != null) benefits.addAll(product.features!);
    if (product.longDescription != null && product.longDescription!.isNotEmpty) {
      benefits.add(product.longDescription!);
    }

    if (benefits.isEmpty) {
      return _buildTabContent(null, 'Belum ada informasi manfaat tersedia.');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: benefits.map((benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      benefit,
                      style: TextStyle(fontSize: 14, height: 1.6, color: textPrimary),
                    ),
                  ),
                ],
              ),
            )).toList(),
      ),
    );
  }

  Widget _buildSpecs(Product product) {
    final specs = <_SpecItem>[
      _SpecItem('Kategori', product.categoryName ?? '-'),
      _SpecItem('Tipe', product.type == 'patungan' ? 'Patungan' : 'Regular'),
      _SpecItem('Durasi', product.durationLabel ?? '-'),
      _SpecItem('Status Stok', product.stockStatus),
      _SpecItem('Stok Tersedia', '${product.stock}'),
      _SpecItem('Rating', product.rating != null ? '${product.rating!.toStringAsFixed(1)} / 5.0' : '-'),
      _SpecItem('Terjual', '${product.soldCount}'),
      _SpecItem('Instan', product.isInstant ? 'Ya' : 'Tidak'),
      _SpecItem('Dibuat', _formatDate(product.createdAt)),
      _SpecItem('Diperbarui', _formatDate(product.updatedAt)),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: specs.map((spec) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      spec.label,
                      style: TextStyle(fontSize: 14, color: textSecondary),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      spec.value,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            )).toList(),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _SpecItem {
  final String label;
  final String value;
  _SpecItem(this.label, this.value);
}

class _TrustIndicators extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor;
  final Color primaryColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;

  const _TrustIndicators({
    required this.isDark,
    required this.surfaceColor,
    required this.primaryColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final indicators = [
      _TrustItem(Icons.verified, 'Garansi Resmi', 'Produk asli bergaransi penuh'),
      _TrustItem(Icons.flash_on, 'Pengiriman Instan', 'Otomatis dalam hitungan detik'),
      _TrustItem(Icons.support_agent, 'Support 24/7', 'Live chat & WhatsApp siap bantu'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: indicators.map((item) => Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: primaryColor, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            )).toList(),
      ),
    );
  }
}

class _TrustItem {
  final IconData icon;
  final String title;
  final String subtitle;
  _TrustItem(this.icon, this.title, this.subtitle);
}