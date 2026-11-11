import 'package:flutter/material.dart';
import '../../data/models.dart';
import 'product_card.dart';

/// Grid produk adaptif berbasis konten (Content-driven).
/// Ukuran dan tinggi kartu 100% ditentukan oleh [ProductCard],
/// tanpa perlu mengatur `childAspectRatio` secara manual di parent page.
class AdaptiveProductGrid extends StatelessWidget {
  final List<ProductItem> products;
  final EdgeInsetsGeometry padding;

  const AdaptiveProductGrid({
    super.key,
    required this.products,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth >= 1100 ? 4 : (screenWidth >= 700 ? 3 : 2);
    final rowCount = (products.length / crossAxisCount).ceil();

    return SliverPadding(
      padding: padding,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, rowIndex) {
            final startIndex = rowIndex * crossAxisCount;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(crossAxisCount, (colIndex) {
                    final itemIndex = startIndex + colIndex;
                    final hasItem = itemIndex < products.length;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: colIndex < crossAxisCount - 1 ? 14 : 0,
                        ),
                        child: hasItem
                            ? ProductCard(product: products[itemIndex])
                            : const SizedBox.shrink(),
                      ),
                    );
                  }),
                ),
              ),
            );
          },
          childCount: rowCount,
        ),
      ),
    );
  }
}

