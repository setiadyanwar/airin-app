import 'package:flutter/material.dart';

class HomeQuickCategories extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const HomeQuickCategories({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  static const categories = [
    {'id': 'all', 'label': 'Semua'},
    {'id': 'ai', 'label': 'AI'},
    {'id': 'productivity', 'label': 'Produktivitas'},
    {'id': 'streaming', 'label': 'Hiburan'},
    {'id': 'games', 'label': 'Games'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textUnselected = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF6E6E73);
    final bgUnselected = isDark ? const Color(0xFF242428) : const Color(0xFFF2F2F5);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat['id'];
          final id = cat['id']?.toString() ?? '';
          final label = cat['label']?.toString() ?? '';

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onSelectCategory(id),
              borderRadius: BorderRadius.circular(999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF1D1D1F))
                      : bgUnselected,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? const Color(0xFF111111) : Colors.white)
                        : textUnselected,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
