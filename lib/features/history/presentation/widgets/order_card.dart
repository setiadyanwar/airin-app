import 'package:flutter/material.dart';
import '../../../../core/theme/airin_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/utils/formatters.dart';
import '../../../catalog/data/models.dart';

class OrderCard extends StatelessWidget {
  final OrderItem order;
  final VoidCallback onViewDetail;

  const OrderCard({
    super.key,
    required this.order,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AirinColors.darkTextPrimary : AirinColors.lightTextPrimary;
    final textSecondary = isDark ? AirinColors.darkTextSecondary : AirinColors.lightTextSecondary;
    final border = isDark ? AirinColors.darkBorder : AirinColors.lightBorder;

    Color statusColor;
    String statusLabel;

    switch (order.status) {
      case 'active':
        statusColor = const Color(0xFF059669);
        statusLabel = 'Aktif & Bergaransi';
        break;
      case 'paid':
        statusColor = AirinColors.tealBrand;
        statusLabel = 'Sudah Dibayar';
        break;
      case 'unpaid':
        statusColor = const Color(0xFFF59E0B);
        statusLabel = 'Menunggu Pembayaran';
        break;
      default:
        statusColor = Colors.grey;
        statusLabel = 'Selesai';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderId,
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: AirinColors.tealBrand,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Text(
              order.productName,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              'Pemesan: ${order.customerName} (${order.customerEmail})',
              style: TextStyle(fontSize: 11, color: textSecondary),
            ),
            const SizedBox(height: 3),
            Text(
              Formatters.formatDate(order.createdAt),
              style: TextStyle(fontSize: 10, color: textSecondary),
            ),

            const Divider(height: 22),

            // Total and Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Transaksi', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text(
                      Formatters.formatRupiah(order.totalAmount),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: onViewDetail,
                  icon: const Icon(Icons.info_outline_rounded, size: 14),
                  label: const Text('Detail Akun', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textPrimary,
                    side: BorderSide(color: border),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

