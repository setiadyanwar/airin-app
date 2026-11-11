import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/airin_theme.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models.dart';
import '../providers.dart';

class CheckoutModal extends ConsumerStatefulWidget {
  final ProductItem product;

  const CheckoutModal({super.key, required this.product});

  @override
  ConsumerState<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends ConsumerState<CheckoutModal> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();

  String _paymentMethod = 'kreapay'; // 'kreapay' | 'qris'
  bool _isQrisActive = false;
  late int _uniqueCode;
  late double _totalAmount;

  @override
  void initState() {
    super.initState();
    _uniqueCode = 100 + (DateTime.now().millisecond % 199);
    _totalAmount = widget.product.salePrice + _uniqueCode;

    // Prefill user data if logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider);
      if (user != null) {
        if (_nameController.text.isEmpty) _nameController.text = user.name;
        if (_emailController.text.isEmpty) _emailController.text = user.email;
        if (_contactController.text.isEmpty && user.phone != null) {
          _contactController.text = user.phone!;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF18181B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final textSecondary = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF6E6E73);
    final border = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08);

    final user = ref.watch(authProvider);
    final kreapayBalance = user?.balance ?? 150000.0;
    final isKreapaySufficient = kreapayBalance >= widget.product.salePrice;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (!_isQrisActive) ...[
              Text(
                'Konfirmasi Pemesanan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.4,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Lengkapi data untuk pengiriman link / akses instan.',
                style: TextStyle(fontSize: 12, color: textSecondary),
              ),

              const SizedBox(height: 14),

              // Product Info Summary Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF202024) : const Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C30) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: BrandLogo(
                        id: widget.product.id,
                        name: widget.product.name,
                        imageUrl: widget.product.image,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.product.durationLabel,
                            style: TextStyle(fontSize: 11, color: textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Formatters.formatRupiah(widget.product.salePrice),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Customer Form Inputs
              TextField(
                controller: _nameController,
                style: TextStyle(fontSize: 13, color: textPrimary),
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'e.g. Setiady',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 13, color: textPrimary),
                decoration: InputDecoration(
                  labelText: 'Email Akun Google / Pribadi',
                  hintText: 'e.g. user@gmail.com',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
                style: TextStyle(fontSize: 13, color: textPrimary),
                decoration: InputDecoration(
                  labelText: 'No. WhatsApp / Telegram',
                  hintText: 'e.g. 08123456789',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // Option 1: KreaPay
              InkWell(
                onTap: () {
                  setState(() => _paymentMethod = 'kreapay');
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _paymentMethod == 'kreapay'
                        ? const Color(0xFF0D9488).withValues(alpha: 0.1)
                        : (isDark ? const Color(0xFF202024) : const Color(0xFFF5F5F7)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _paymentMethod == 'kreapay' ? const Color(0xFF0D9488) : border,
                      width: _paymentMethod == 'kreapay' ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.account_balance_wallet_rounded, size: 18, color: Color(0xFF0D9488)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Saldo KreaPay',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF059669).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text('Instan', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                                ),
                              ],
                            ),
                            Text(
                              'Saldo: ${Formatters.formatRupiah(kreapayBalance)} ${isKreapaySufficient ? '(Cukup)' : '(Saldo kurang)'}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isKreapaySufficient ? textSecondary : const Color(0xFFE11D48),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _paymentMethod == 'kreapay' ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: _paymentMethod == 'kreapay' ? const Color(0xFF0D9488) : textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Option 2: QRIS
              InkWell(
                onTap: () {
                  setState(() => _paymentMethod = 'qris');
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _paymentMethod == 'qris'
                        ? const Color(0xFF0D9488).withValues(alpha: 0.1)
                        : (isDark ? const Color(0xFF202024) : const Color(0xFFF5F5F7)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _paymentMethod == 'qris' ? const Color(0xFF0D9488) : border,
                      width: _paymentMethod == 'qris' ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF28282D) : const Color(0xFFF0F0F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          'assets/logos/qris.svg',
                          colorFilter: ColorFilter.mode(
                            isDark ? Colors.white : const Color(0xFF1D1D1F),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QRIS Semua Bank & E-Wallet',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary),
                            ),
                            Text(
                              'BCA, Mandiri, BRI, GoPay, OVO, ShopeePay',
                              style: TextStyle(fontSize: 10.5, color: textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _paymentMethod == 'qris' ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: _paymentMethod == 'qris' ? const Color(0xFF0D9488) : textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_emailController.text.isEmpty || _contactController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Silakan lengkapi Email dan No WhatsApp/Telegram')),
                    );
                    return;
                  }

                  if (_paymentMethod == 'kreapay') {
                    if (!isKreapaySufficient) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saldo KreaPay Anda tidak mencukupi, silakan isi saldo atau gunakan QRIS')),
                      );
                      return;
                    }
                    _processKreaPayPayment(context);
                  } else {
                    setState(() => _isQrisActive = true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : const Color(0xFF1D1D1F),
                  foregroundColor: isDark ? const Color(0xFF111111) : Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  elevation: 0,
                ),
                child: Text(
                  _paymentMethod == 'kreapay'
                      ? 'Bayar Sekarang (${Formatters.formatRupiah(widget.product.salePrice)})'
                      : 'Lanjut Pembayaran QRIS',
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                ),
              ),
            ] else ...[
              // QRIS Screen
              Center(
                child: Column(
                  children: [
                    Text(
                      'Pembayaran QRIS Instan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Scan dengan BCA, Mandiri, BRI, GoPay, OVO, ShopeePay',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: textSecondary),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: SvgPicture.asset(
                              'assets/logos/qris.svg',
                              height: 18,
                              colorFilter: const ColorFilter.mode(
                                Colors.black87,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Icon(Icons.qr_code_2_rounded, size: 160, color: Colors.black.withValues(alpha: 0.85)),
                          const SizedBox(height: 8),
                          const Text(
                            'AIRIN STORE DIGITAL',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF202024) : const Color(0xFFF5F5F7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nominal Transfer (Tepat):',
                                style: TextStyle(fontSize: 11, color: textSecondary),
                              ),
                              Text(
                                Formatters.formatRupiah(_totalAmount),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0D9488),
                                ),
                              ),
                              Text(
                                'Termasuk kode unik +$_uniqueCode untuk verifikasi otomatis',
                                style: TextStyle(fontSize: 10, color: textSecondary),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 20, color: Color(0xFF0D9488)),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: _totalAmount.toInt().toString()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Nominal disalin ke clipboard')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        _finishOrder(
                          context,
                          paymentMethod: 'QRIS Instan',
                          amount: widget.product.salePrice,
                          total: _totalAmount,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D9488),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 46),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Saya Sudah Membayar',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _processKreaPayPayment(BuildContext context) {
    ref.read(authProvider.notifier).deductKreaPay(widget.product.salePrice);
    _finishOrder(
      context,
      paymentMethod: 'Saldo KreaPay',
      amount: widget.product.salePrice,
      total: widget.product.salePrice,
    );
  }

  void _finishOrder(
    BuildContext context, {
    required String paymentMethod,
    required double amount,
    required double total,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF18181B) : Colors.white;
    final textSecondary = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF6E6E73);

    final newOrder = OrderItem(
      orderId: 'INV-AIRIN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      productId: widget.product.id,
      productName: widget.product.name,
      amount: amount,
      uniqueCode: paymentMethod == 'Saldo KreaPay' ? 0 : _uniqueCode,
      totalAmount: total,
      customerName: _nameController.text.isEmpty ? 'Pelanggan Airin' : _nameController.text,
      customerContact: _contactController.text,
      customerEmail: _emailController.text,
      status: 'paid',
      createdAt: DateTime.now(),
      accountDetails: 'Link aktivasi resmi telah dikirim ke ${_emailController.text}. Dibayar via $paymentMethod.',
      warrantyInfo: widget.product.warranty,
    );

    ref.read(orderHistoryProvider.notifier).addOrder(newOrder);

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Color(0xFF0D9488), size: 24),
            SizedBox(width: 8),
            Text('Pembayaran Berhasil!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Pesanan ${newOrder.orderId} untuk ${widget.product.name} telah lunas via $paymentMethod! Akses layanan segera dikirim.',
          style: TextStyle(color: textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/history');
            },
            child: const Text('Buka Riwayat Pesanan', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
