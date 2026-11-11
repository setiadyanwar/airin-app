import 'package:flutter/material.dart';
import '../theme/airin_theme.dart';

enum BadgeType { success, warning, error, info, brand }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final IconData? icon;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.brand,
    this.icon,
    this.fontSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
  });

  factory StatusBadge.stockReady(int count) {
    return StatusBadge(
      label: count > 0 ? 'Tersedia $count' : 'Tersedia',
      type: BadgeType.success,
    );
  }

  factory StatusBadge.stockOut() {
    return const StatusBadge(
      label: 'Stok Habis',
      type: BadgeType.error,
    );
  }

  factory StatusBadge.discount(int percent) {
    return StatusBadge(
      label: '$percent% OFF',
      type: BadgeType.brand,
    );
  }

  factory StatusBadge.instant() {
    return const StatusBadge(
      label: 'Instan',
      icon: Icons.bolt_rounded,
      type: BadgeType.warning,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color fg;
    BorderSide border;

    switch (type) {
      case BadgeType.success:
        bg = isDark ? const Color(0xFF064E3B).withValues(alpha: 0.5) : const Color(0xFFECFDF5);
        fg = isDark ? const Color(0xFF34D399) : const Color(0xFF059669);
        border = BorderSide(color: fg.withValues(alpha: 0.25), width: 0.8);
        break;
      case BadgeType.error:
        bg = isDark ? const Color(0xFF7F1D1D).withValues(alpha: 0.5) : const Color(0xFFFEF2F2);
        fg = isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626);
        border = BorderSide(color: fg.withValues(alpha: 0.25), width: 0.8);
        break;
      case BadgeType.warning:
        bg = isDark ? const Color(0xFF78350F).withValues(alpha: 0.5) : const Color(0xFFFFFBEB);
        fg = isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
        border = BorderSide(color: fg.withValues(alpha: 0.25), width: 0.8);
        break;
      case BadgeType.info:
        bg = isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.5) : const Color(0xFFEFF6FF);
        fg = isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
        border = BorderSide(color: fg.withValues(alpha: 0.25), width: 0.8);
        break;
      case BadgeType.brand:
        bg = isDark ? AirinColors.tealBrand.withValues(alpha: 0.15) : AirinColors.tealBrand.withValues(alpha: 0.1);
        fg = isDark ? const Color(0xFF5EEAD4) : AirinColors.tealBrand;
        border = BorderSide(color: AirinColors.tealBrand.withValues(alpha: 0.25), width: 0.8);
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.fromBorderSide(border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: fg),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fg,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

