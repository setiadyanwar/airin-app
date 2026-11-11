import 'package:flutter/material.dart';

class HomeFaqSection extends StatefulWidget {
  const HomeFaqSection({super.key});

  @override
  State<HomeFaqSection> createState() => _HomeFaqSectionState();
}

class _HomeFaqSectionState extends State<HomeFaqSection> {
  int? openIndex = 0;

  static const faqs = [
    {
      'q': 'Bagaimana cara kerja aktivasi Gemini Pro 18 bulan?',
      'a': 'Anda menerima link promosi resmi Google One AI Premium. Buka link tersebut di peramban akun Google pribadi Anda. Masa aktif 18 bulan dan penyimpanan 5 TB Google One langsung aktif tanpa perlu memberikan kata sandi akun.',
    },
    {
      'q': 'Apakah data dan email pribadi saya aman?',
      'a': 'Aman sepenuhnya. Karena aktivasi melalui link resmi Google atau undangan tim, kami tidak pernah meminta kata sandi email Anda. Dokumen kerja, file Google Drive, dan riwayat obrolan AI Anda 100% privat.',
    },
    {
      'q': 'Bagaimana jika terjadi kendala pada akun sebelum durasi selesai?',
      'a': 'Seluruh layanan dilindungi garansi. Jika akses terhenti sebelum masa aktif berakhir, hubungi kami di Telegram (@airinappstore_bot) untuk klaim penggantian link atau akun baru tanpa biaya tambahan.',
    },
    {
      'q': 'Mengapa biayanya jauh lebih terjangkau daripada langganan langsung?',
      'a': 'Kami memanfaatkan program kemitraan lisensi resmi regional (seperti promo bundling global) serta skema langganan keluarga legal, sehingga biaya terbagi efisien tanpa mengurangi fungsionalitas dan privasi.',
    },
    {
      'q': 'Metode pembayaran apa saja yang diterima?',
      'a': 'Pembayaran diproses via QRIS instan yang mendukung seluruh bank nasional (BCA, Mandiri, BRI, BNI) dan dompet digital (GoPay, OVO, Dana, ShopeePay).',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final textSecondary = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF6E6E73);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pertanyaan umum.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Transparan mengenai proses aktivasi, keamanan data, dan jaminan garansi.',
            style: TextStyle(fontSize: 12, color: textSecondary, height: 1.3),
          ),
          const SizedBox(height: 16),

          // FAQ Accordion List
          ...faqs.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isOpen = openIndex == idx;

            return Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor, width: 0.8)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        openIndex = isOpen ? null : idx;
                      });
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            item['q']!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: isOpen ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 12),
                      child: Text(
                        item['a']!,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ),
                    crossFadeState: isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
