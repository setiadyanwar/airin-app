import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/airin_theme.dart';
import '../../catalog/data/models.dart';
import '../../catalog/presentation/providers.dart';
import 'widgets/order_card.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final TextEditingController _lookupController = TextEditingController();
  String _searchFilter = '';

  @override
  void dispose() {
    _lookupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orders = ref.watch(orderHistoryProvider);

    final bg = isDark ? AirinColors.darkBg : AirinColors.lightSecondaryBg;
    final textPrimary = isDark ? AirinColors.darkTextPrimary : AirinColors.lightTextPrimary;
    final textSecondary = isDark ? AirinColors.darkTextSecondary : AirinColors.lightTextSecondary;

    final filteredOrders = orders.where((o) {
      if (_searchFilter.isEmpty) return true;
      final q = _searchFilter.toLowerCase();
      return o.orderId.toLowerCase().contains(q) ||
          o.customerContact.toLowerCase().contains(q) ||
          o.productName.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
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
                      'STATUS PESANAN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: AirinColors.tealBrand,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Riwayat & Lacak',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cek status pembayaran QRIS, link aktivasi akun, dan klaim garansi transaksi Anda.',
                      style: TextStyle(
                        fontSize: 13,
                        color: textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Input
                    TextField(
                      controller: _lookupController,
                      style: TextStyle(fontSize: 13, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Cari No Invoice (INV-...) atau WhatsApp',
                        hintStyle: TextStyle(fontSize: 13, color: textSecondary),
                        prefixIcon: Icon(Icons.search, size: 18, color: textSecondary),
                        suffixIcon: _lookupController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 16),
                                onPressed: () {
                                  _lookupController.clear();
                                  setState(() {
                                    _searchFilter = '';
                                  });
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
                        setState(() {
                          _searchFilter = val.trim();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Orders list
            if (filteredOrders.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 48, color: textSecondary),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada transaksi ditemukan',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Transaksi Anda yang telah dipesan akan muncul di sini.',
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final order = filteredOrders[index];
                      return OrderCard(
                        order: order,
                        onViewDetail: () => _showOrderDetail(context, order),
                      );
                    },
                    childCount: filteredOrders.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetail(BuildContext context, OrderItem order) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF18181B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Detail Pengiriman Akun',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text('Invoice: ${order.orderId}', style: const TextStyle(fontSize: 12, color: AirinColors.tealBrand)),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AirinColors.darkCardElevated : const Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  order.accountDetails ?? 'Kredensial atau link aktivasi instan telah terverifikasi.',
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87, height: 1.4),
                ),
              ),

              const SizedBox(height: 14),
              Text('Garansi: ${order.warrantyInfo ?? "Garansi 100% penuh"}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menghubungkan ke Tim Support Telegram...')),
                  );
                },
                icon: const Icon(Icons.support_agent_rounded, size: 18),
                label: const Text('Bantuan CS WhatsApp / Telegram'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AirinColors.tealBrand,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
