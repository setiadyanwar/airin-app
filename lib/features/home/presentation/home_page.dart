import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/section_header.dart';
import '../../catalog/presentation/providers.dart';
import '../../catalog/presentation/widgets/product_card.dart';
import '../../catalog/presentation/widgets/product_grid.dart';
import 'widgets/home_header.dart';
import 'widgets/home_kreapay_card.dart';
import 'widgets/home_quick_categories.dart';
import 'widgets/home_patungan_section.dart';
import 'widgets/home_why_us_bento.dart';
import 'widgets/home_faq_section.dart';
import 'widgets/home_footer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productsAsync = ref.watch(productsProvider);
    final bg = isDark ? const Color(0xFF121214) : const Color(0xFFFBFBFD);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF0D9488),
          onRefresh: () async {
            ref.invalidate(productsProvider);
            ref.invalidate(patunganListProvider);
          },
          child: CustomScrollView(
            slivers: [
              // 1. Mobile Header
              const SliverToBoxAdapter(
                child: HomeHeader(),
              ),

              // 2. KreaPay Wallet Section (Latar section abu-abu dengan pendaran soft primary light)
              SliverToBoxAdapter(
                child: Container(
                  color: isDark ? const Color(0xFF16161A) : const Color(0xFFF2F2F5),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Sedikit pendaran cahaya warna primary soft di latar section
                      Positioned(
                        top: -20,
                        right: 20,
                        child: IgnorePointer(
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF0D9488).withValues(alpha: isDark ? 0.20 : 0.14),
                                  const Color(0xFF0D9488).withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Kartu KreaPay Putih Tunggal
                      const HomeKreaPayCard(),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // 3. Section Header: Layanan Unggulan (Simple & Clean)
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Layanan Unggulan',
                  actionLabel: 'Lihat Semua',
                  onAction: () => context.go('/catalog'),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // 4. Category Filter Tabs
              SliverToBoxAdapter(
                child: HomeQuickCategories(
                  selectedCategory: _selectedCategory,
                  onSelectCategory: (cat) => setState(() => _selectedCategory = cat),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // 5. Highlight Products Grid (Clean & Spacious)
              productsAsync.when(
                data: (products) {
                  var filtered = products;
                  if (_selectedCategory != 'all') {
                    filtered = filtered.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
                  }
                  final topProducts = filtered.take(8).toList();

                  if (topProducts.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            'Tidak ada produk di kategori ini',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  }

                  final screenWidth = MediaQuery.of(context).size.width;
                  final crossAxisCount = screenWidth >= 1100 ? 4 : (screenWidth >= 700 ? 3 : 2);

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.2,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ProductCard(product: topProducts[index]);
                        },
                        childCount: topProducts.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator(color: Color(0xFF0D9488))),
                  ),
                ),
                error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),

              // 6. Bento Grid: Kenapa harus airin?
              const SliverToBoxAdapter(
                child: HomeWhyUsBento(),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),

              // 7. Patungan Section Teaser
              const SliverToBoxAdapter(
                child: HomePatunganSection(),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),

              // 8. FAQ Section
              const SliverToBoxAdapter(
                child: HomeFaqSection(),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),

              // 9. Footer Minimalis Resmi
              const SliverToBoxAdapter(
                child: HomeFooter(),
              ),

              // Bottom padding for floating navigation bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 96),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
