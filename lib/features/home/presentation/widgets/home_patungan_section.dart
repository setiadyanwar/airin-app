import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/section_header.dart';

class HomePatunganSection extends StatelessWidget {
  const HomePatunganSection({super.key});

  static const teaserGroups = [
    {
      'id': 'chatgpt',
      'name': 'ChatGPT Plus Team',
      'group': 'Grup #18',
      'filled': 3,
      'total': 4,
      'price': 'Rp 75.000',
      'official': 'Rp 350.000',
      'note': 'Sisa 1 slot',
    },
    {
      'id': 'apple-one',
      'name': 'Apple One Family',
      'group': 'Grup #22',
      'filled': 4,
      'total': 5,
      'price': 'Rp 45.000',
      'official': 'Rp 155.000',
      'note': 'Sisa 1 slot',
    },
    {
      'id': 'netflix',
      'name': 'Netflix 4K (1P 1U)',
      'group': 'Grup #35',
      'filled': 3,
      'total': 4,
      'price': 'Rp 38.000',
      'official': 'Rp 186.000',
      'note': 'Sisa 1 slot',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final textSecondary = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF86868B);
    final cardBg = isDark ? const Color(0xFF202024) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          tag: 'Pt-Pt • Mari kita patungan',
          title: 'Patungan langganan resmi.\nBayar sebagian kecil.',
          subtitle: 'Bagi biaya paket Family & Team resmi bersama anggota lain.',
          actionLabel: 'Jelajahi grup',
          onAction: () => context.go('/patungan'),
        ),
        const SizedBox(height: 14),

        SizedBox(
          height: 195,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: teaserGroups.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final g = teaserGroups[index];
              final filled = (g['filled'] as num?)?.toInt() ?? 3;
              final total = (g['total'] as num?)?.toInt() ?? 4;
              final progress = total > 0 ? filled / total : 0.0;
              final id = g['id']?.toString() ?? '';
              final name = g['name']?.toString() ?? '';
              final note = g['note']?.toString() ?? '';
              final group = g['group']?.toString() ?? '';
              final price = g['price']?.toString() ?? '';
              final official = g['official']?.toString() ?? '';

              return Container(
                width: 250,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top: Logo + Sisa Slot Pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2C2C30) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor),
                          ),
                          child: BrandLogo(id: id, name: name, size: 22),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF022C22).withValues(alpha: 0.4) : const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isDark ? const Color(0xFF059669).withValues(alpha: 0.3) : const Color(0xFFA7F3D0),
                            ),
                          ),
                          child: Text(
                            note,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Title & Group
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                            color: textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          group,
                          style: TextStyle(fontSize: 11, color: textSecondary),
                        ),
                      ],
                    ),

                    // Price Block
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '/ user',
                          style: TextStyle(fontSize: 10, color: textSecondary),
                        ),
                        const Spacer(),
                        Text(
                          'Resmi $official',
                          style: TextStyle(
                            fontSize: 9.5,
                            color: isDark ? const Color(0xFF71717A) : const Color(0xFFA1A1A6),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),

                    // Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: isDark ? const Color(0xFF2C2C30) : const Color(0xFFE4E4E7),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$filled dari $total slot terisi',
                          style: TextStyle(fontSize: 9.5, color: textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
