import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/airin_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../catalog/data/models.dart';
import '../../catalog/presentation/providers.dart';
import 'widgets/patungan_card.dart';

class PatunganPage extends ConsumerStatefulWidget {
  const PatunganPage({super.key});

  @override
  ConsumerState<PatunganPage> createState() => _PatunganPageState();
}

class _PatunganPageState extends ConsumerState<PatunganPage> {
  String _selectedCategory = 'all';

  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'label': 'Semua Grup'},
    {'id': 'ai', 'label': 'AI & Team'},
    {'id': 'productivity', 'label': 'Produktivitas'},
    {'id': 'streaming', 'label': 'Streaming'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patunganAsync = ref.watch(patunganListProvider);

    final bg = isDark ? AirinColors.darkBg : AirinColors.lightSecondaryBg;
    final textPrimary = isDark ? AirinColors.darkTextPrimary : AirinColors.lightTextPrimary;
    final textSecondary = isDark ? AirinColors.darkTextSecondary : AirinColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AirinColors.tealBrand,
          onRefresh: () async {
            ref.invalidate(patunganListProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Container(
                  color: isDark ? AirinColors.darkCard : Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pt-Pt • Mari kita patungan',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Patungan Langganan',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Beli langganan resmi bersama pengguna lain. Bayar sebagian kecil, nikmati fitur penuh legal.',
                        style: TextStyle(
                          fontSize: 13,
                          color: textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Category Pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories.map((cat) {
                            final isSelected = _selectedCategory == cat['id'];
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
                                  setState(() {
                                    _selectedCategory = cat['id']!;
                                  });
                                },
                                selectedColor: isDark ? Colors.white : const Color(0xFF1D1D1F),
                                backgroundColor: isDark ? AirinColors.darkCardSecondary : const Color(0xFFF2F2F7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: isSelected ? Colors.transparent : (isDark ? AirinColors.darkBorder : AirinColors.lightBorder),
                                  ),
                                ),
                                showCheckmark: false,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Group List
              patunganAsync.when(
                data: (groups) {
                  final filtered = _selectedCategory == 'all'
                      ? groups
                      : groups.where((g) => g.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

                  if (filtered.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Text('Tidak ada grup patungan aktif', style: TextStyle(color: textSecondary)),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final group = filtered[index];
                          return PatunganCard(
                            group: group,
                            onJoin: () => _showJoinDialog(context, group),
                          );
                        },
                        childCount: filtered.length,
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
                error: (_, __) => const SliverToBoxAdapter(
                  child: Center(child: Text('Gagal memuat data patungan')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showJoinDialog(BuildContext context, PatunganItem group) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Gabung ${group.name}'),
        content: Text(
          'Slot Grup #${group.groupNumber} akan dialokasikan untuk Anda seharga ${Formatters.formatRupiah(group.pricePerUser)}. Lanjutkan pemesanan?',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.push('/product/${group.id}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AirinColors.tealBrand,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Lanjut Checkout'),
          ),
        ],
      ),
    );
  }
}
