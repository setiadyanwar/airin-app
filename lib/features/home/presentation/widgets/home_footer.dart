import 'package:flutter/material.dart';
import '../../../../core/widgets/airin_logo.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF86868B);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121214) : const Color(0xFFFBFBFD),
        border: Border(top: BorderSide(color: borderColor, width: 0.8)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AirinLogoMark(size: 20),
              const SizedBox(width: 6),
              Text(
                'airin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                  color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Layanan akses aplikasi kerja, riset, dan hiburan melalui skema berlangganan bersama dan lisensi resmi. Transparan, aman, dan bergaransi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '© 2026 airin app. Hak cipta dilindungi.',
            style: TextStyle(
              fontSize: 10,
              color: textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
