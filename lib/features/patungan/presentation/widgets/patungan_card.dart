import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/airin_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/utils/formatters.dart';
import '../../../catalog/data/models.dart';

class PatunganCard extends StatelessWidget {
  final PatunganItem group;
  final VoidCallback onJoin;

  const PatunganCard({
    super.key,
    required this.group,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AirinColors.darkTextPrimary : AirinColors.lightTextPrimary;
    final textSecondary = isDark ? AirinColors.darkTextSecondary : AirinColors.lightTextSecondary;
    final border = isDark ? AirinColors.darkBorder : AirinColors.lightBorder;

    final progress = group.filledSlots / group.totalSlots;
    final remaining = group.remainingSlots;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Brand Logo + Group # + Status
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF242428) : const Color(0xFFF4F4F6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border, width: 0.8),
                  ),
                  child: BrandLogo(id: group.id, name: group.name, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              group.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Grup #${group.groupNumber}',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        group.typeLabel,
                        style: TextStyle(fontSize: 11, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: remaining <= 2
                        ? const Color(0xFFD97706).withValues(alpha: 0.12)
                        : AirinColors.tealBrand.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Sisa $remaining slot',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: remaining <= 2 ? const Color(0xFFD97706) : AirinColors.tealBrand,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kapasitas Grup',
                  style: TextStyle(fontSize: 11, color: textSecondary),
                ),
                Text(
                  '${group.filledSlots} dari ${group.totalSlots} orang',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: isDark ? Colors.white10 : Colors.black12,
                valueColor: const AlwaysStoppedAnimation<Color>(AirinColors.tealBrand),
              ),
            ),

            const SizedBox(height: 14),

            // Rules tags
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: group.rules.map((rule) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 12, color: AirinColors.tealBrand),
                    const SizedBox(width: 4),
                    Text(
                      rule,
                      style: TextStyle(fontSize: 11, color: textSecondary),
                    ),
                  ],
                );
              }).toList(),
            ),

            const Divider(height: 24),

            // Bottom: Price & Join Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Iuran per Pengguna', style: TextStyle(fontSize: 10, color: textSecondary)),
                    Text(
                      '${Formatters.formatRupiah(group.pricePerUser)} /bln',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AirinColors.tealBrand,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AirinColors.tealBrand,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Gabung Grup', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
