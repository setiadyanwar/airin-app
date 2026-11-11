import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShellPage extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ShellPage({super.key, required this.navigationShell});

  @override
  ConsumerState<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends ConsumerState<ShellPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121214) : const Color(0xFFF5F5F7);
    final surfaceColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final primaryColor = const Color(0xFF4082E6);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Beranda',
                  currentIndex: widget.navigationShell.currentIndex,
                  primaryColor: primaryColor,
                  onTap: () => _goBranch(0),
                ),
                _NavItem(
                  index: 1,
                  icon: Icons.grid_view_outlined,
                  activeIcon: Icons.grid_view,
                  label: 'Katalog',
                  currentIndex: widget.navigationShell.currentIndex,
                  primaryColor: primaryColor,
                  onTap: () => _goBranch(1),
                ),
                _NavItem(
                  index: 2,
                  icon: Icons.shopping_cart_outlined,
                  activeIcon: Icons.shopping_cart,
                  label: 'Keranjang',
                  currentIndex: widget.navigationShell.currentIndex,
                  primaryColor: primaryColor,
                  onTap: () => _goBranch(2),
                ),
                _NavItem(
                  index: 3,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profil',
                  currentIndex: widget.navigationShell.currentIndex,
                  primaryColor: primaryColor,
                  onTap: () => _goBranch(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int currentIndex;
  final Color primaryColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.currentIndex,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 26,
                color: isSelected
                    ? primaryColor
                    : isDark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black.withOpacity(0.5),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? primaryColor
                      : isDark
                          ? Colors.white.withOpacity(0.5)
                          : Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}