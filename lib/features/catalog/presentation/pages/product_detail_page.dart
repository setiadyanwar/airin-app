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

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _quantity = 1;
  ProductVariant? _selectedVariant;

  @override
  Widget build(BuildContext context) {
    final asyncProduct = ref.watch(productDetailProvider(widget.productId));
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        elevation: 0,
      ),
      body: asyncProduct.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(productDetailProvider(widget.productId)),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (product) => _buildProductDetail(product, formatter),
      ),
    );
  }

  Widget _buildProductDetail(Product product, NumberFormat formatter) {
    final imageUrl = product.imageUrl ?? product.thumbnailUrl;
    final isPatungan = product.type == 'patungan';
    final showQuantity = !isPatungan;
    final price = _selectedVariant?.price ?? product.price;
    final originalPrice = _selectedVariant?.originalPrice ?? product.originalPrice;
    final stock = _selectedVariant?.stock ?? product.stock;
    final isInStock = (_selectedVariant?.isInStock ?? product.isInStock) && stock > 0;

    return CustomScrollView(
      slivers: [
        // Image
        SliverToBoxAdapter(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                    ),
                  )
                : Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey)),
                  ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Type
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (isPatungan)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('PATUNGAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Rating & Sold
                if (product.rating != null && product.rating! > 0) ...[
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${product.rating!.toStringAsFixed(1)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      if (product.soldCount > 0)
                        Text('${product.soldCount} terjual', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Price
                Row(
                  children: [
                    if (originalPrice != null && originalPrice > price) ...[
                      Text(
                        formatter.format(originalPrice),
                        style: TextStyle(fontSize: 16, color: Colors.grey[500], decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      formatter.format(price),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4082E6)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isInStock ? 'Stok: $stock' : 'Stok habis',
                  style: TextStyle(
                    fontSize: 13,
                    color: isInStock ? Colors.green[700] : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                // Variant Selection
                if (product.variants.isNotEmpty) ...[
                  const Text('Pilih Varian', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.variants.map((variant) {
                      final isSelected = _selectedVariant?.id == variant.id;
                      final variantInStock = variant.isInStock && variant.stock > 0;
                      return FilterChip(
                        label: Text(variant.name),
                        selected: isSelected,
                        onSelected: variantInStock
                            ? (selected) {
                                setState(() {
                                  _selectedVariant = selected ? variant : null;
                                  _quantity = 1;
                                });
                              }
                            : null,
                        selectedColor: Theme.of(context).colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color: variantInStock
                              ? (isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface)
                              : Colors.grey,
                        ),
                        backgroundColor: variantInStock ? null : Colors.grey[100],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Quantity Selector
                if (showQuantity && isInStock) ...[
                  const Text('Jumlah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
                        onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                      _QuantityButton(
                        icon: Icons.add,
                        onPressed: _quantity < stock ? () => setState(() => _quantity++) : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Description
                if (product.description != null && product.description!.isNotEmpty) ...[
                  const Text('Deskripsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(product.description!, style: const TextStyle(fontSize: 14, height: 1.5)),
                  const SizedBox(height: 16),
                ],

                // Long Description
                if (product.longDescription != null && product.longDescription!.isNotEmpty) ...[
                  const Text('Detail Produk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(product.longDescription!, style: const TextStyle(fontSize: 14, height: 1.5)),
                  const SizedBox(height: 16),
                ],

                // Features
                if (product.features != null && product.features!.isNotEmpty) ...[
                  const Text('Fitur', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...product.features!.map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, size: 18, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(child: Text(feature, style: const TextStyle(fontSize: 14))),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                ],

                // Support Info
                if (product.supportInfo != null && product.supportInfo!.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.support_agent, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            product.supportInfo!,
                            style: TextStyle(fontSize: 13, color: Colors.blue[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Buy Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isInStock ? _handleBuy : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4082E6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      isPatungan ? 'Beli Slot Patungan' : 'Beli Sekarang',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleBuy() {
    // TODO: Navigate to checkout
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checkout untuk ${_selectedVariant?.name ?? 'produk'} x $_quantity - Coming soon')),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: onPressed != null ? Colors.black : Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(44, 44),
      ),
    );
  }
}