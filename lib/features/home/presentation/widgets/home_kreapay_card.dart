import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/formatters.dart';
import '../../../catalog/presentation/providers.dart';

class HomeKreaPayCard extends ConsumerStatefulWidget {
  const HomeKreaPayCard({super.key});

  @override
  ConsumerState<HomeKreaPayCard> createState() => _HomeKreaPayCardState();
}

class _HomeKreaPayCardState extends ConsumerState<HomeKreaPayCard> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider);
    final balance = user?.balance ?? 150000.0;

    const primaryTeal = Color(0xFF0D9488);
    final cardBg = isDark ? const Color(0xFF202024) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.07);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final textSecondary = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A);
    final secondaryButtonBg = isDark ? const Color(0xFF28282D) : const Color(0xFFF5F5F7);

    // Kartu KreaPay Putih Tunggal (Tanpa Container Pembungkus Ganda)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Brand & Aksen Circles Light Soft Primary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    // Icon langsung tanpa kotak pembungkus
                    const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 20,
                      color: primaryTeal,
                    ),
                    const SizedBox(width: 8), // Tepat 8px ke teks
                    Text(
                      'KreaPay',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),

                // Aksen aesthetic dual circle light soft primary (menggantikan badge aktif)
                SizedBox(
                  width: 30,
                  height: 18,
                  child: Stack(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: primaryTeal.withValues(alpha: isDark ? 0.25 : 0.18),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: primaryTeal.withValues(alpha: isDark ? 0.45 : 0.32),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Middle: Saldo & Eye Toggle di Sebelah Kanan Angka
            Text(
              'Saldo Tersedia',
              style: TextStyle(
                fontSize: 11.5,
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _isBalanceVisible ? Formatters.formatRupiah(balance) : 'Rp ••••••••',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isBalanceVisible = !_isBalanceVisible;
                    });
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 18,
                      color: textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Bottom: 2 Action Buttons
            Row(
              children: [
                // Top Up Saldo Button
                Expanded(
                  child: InkWell(
                    onTap: () => _showTopUpBottomSheet(context),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            size: 16,
                            color: isDark ? const Color(0xFF111111) : Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Top Up Saldo',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF111111) : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Bayar QRIS Button
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pemindai QRIS KreaPay siap digunakan')),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: secondaryButtonBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/logos/qris.svg',
                            height: 14,
                            colorFilter: ColorFilter.mode(
                              isDark ? Colors.white : const Color(0xFF1D1D1F),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Bayar',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTopUpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const _TopUpBottomSheet(),
    );
  }
}

class _TopUpBottomSheet extends ConsumerWidget {
  const _TopUpBottomSheet();

  static const amounts = [25000.0, 50000.0, 100000.0, 200000.0];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1C1C20) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final textSecondary = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF86868B);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: textSecondary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Top Up KreaPay',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.4,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pilih nominal instan via QRIS tanpa potongan biaya.',
            style: TextStyle(fontSize: 12, color: textSecondary),
          ),
          const SizedBox(height: 18),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.3,
            children: amounts.map((amt) {
              return InkWell(
                onTap: () {
                  ref.read(authProvider.notifier).topUpKreaPay(amt);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Berhasil top up KreaPay ${Formatters.formatRupiah(amt)}!'),
                      backgroundColor: const Color(0xFF059669),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF28282D) : const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    Formatters.formatRupiah(amt),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
