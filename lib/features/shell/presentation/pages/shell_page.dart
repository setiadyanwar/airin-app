import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/airin_theme.dart';
import '../../../../core/widgets/airin_logo.dart';
import '../../../catalog/presentation/providers.dart';

class ShellPage extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ShellPage({super.key, required this.navigationShell});

  @override
  ConsumerState<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends ConsumerState<ShellPage> {
  final TextEditingController _desktopSearchController = TextEditingController();

  @override
  void dispose() {
    _desktopSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768; // Matching Tailwind md breakpoint

    final bg = isDark ? AirinColors.darkBg : AirinColors.lightBg;
    final border = isDark ? AirinColors.darkBorder : AirinColors.lightBorder;
    final textPrimary = isDark ? AirinColors.darkTextPrimary : AirinColors.lightTextPrimary;
    final textSecondary = isDark ? AirinColors.darkTextSecondary : AirinColors.lightTextSecondary;
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: bg,
      // Desktop Top Header ala Navbar.tsx (hanya tampil jika lebar layar >= 768px)
      appBar: isDesktop
          ? PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Container(
                decoration: BoxDecoration(
                  color: (isDark ? const Color(0xFF121214) : const Color(0xFFFBFBFD)).withValues(alpha: 0.92),
                  border: Border(bottom: BorderSide(color: border)),
                ),
                child: SafeArea(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          // Brand Logo
                          GestureDetector(
                            onTap: () => _goBranch(0),
                            child: Row(
                              children: [
                                const AirinLogoMark(size: 26),
                                const SizedBox(width: 8),
                                Text(
                                  'airin',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 28),

                          // Global Search Bar in Middle ala airin-store GlobalSearch.tsx
                          Expanded(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 460),
                              height: 38,
                              child: TextField(
                                controller: _desktopSearchController,
                                style: TextStyle(fontSize: 12, color: textPrimary),
                                decoration: InputDecoration(
                                  hintText: 'Cari aplikasi atau produk...',
                                  hintStyle: TextStyle(fontSize: 12, color: textSecondary),
                                  prefixIcon: Icon(Icons.search, size: 16, color: textSecondary),
                                  filled: true,
                                  fillColor: isDark ? const Color(0xFF202024) : const Color(0xFFF2F2F7),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onSubmitted: (val) {
                                  ref.read(catalogFilterProvider.notifier).setSearchQuery(val);
                                  _goBranch(1);
                                },
                              ),
                            ),
                          ),

                          const SizedBox(width: 24),

                          // Desktop Links: Home, Katalog, Pt-Pt, Riwayat
                          _DesktopNavLink(
                            label: 'Home',
                            isActive: widget.navigationShell.currentIndex == 0,
                            onTap: () => _goBranch(0),
                          ),
                          _DesktopNavLink(
                            label: 'Katalog',
                            isActive: widget.navigationShell.currentIndex == 1,
                            onTap: () => _goBranch(1),
                          ),
                          _DesktopNavLink(
                            label: 'Pt-Pt',
                            badge: 'Baru',
                            isActive: widget.navigationShell.currentIndex == 2,
                            onTap: () => _goBranch(2),
                          ),
                          _DesktopNavLink(
                            label: 'Riwayat',
                            isActive: widget.navigationShell.currentIndex == 3,
                            onTap: () => _goBranch(3),
                          ),

                          const SizedBox(width: 12),

                          // Theme Toggle Button
                          IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              size: 18,
                              color: textSecondary,
                            ),
                            onPressed: () {
                              ref.read(themeModeProvider.notifier).toggleTheme();
                            },
                            tooltip: 'Ganti Tema',
                          ),

                          const SizedBox(width: 6),

                          // User Avatar / Profile
                          GestureDetector(
                            onTap: () => _goBranch(4),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4EBD0),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: widget.navigationShell.currentIndex == 4
                                      ? AirinColors.tealBrand
                                      : border,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  user != null && user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D1D1F),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,

      body: Stack(
        children: [
          widget.navigationShell,

          // Pure Floating Glassmorphic Bottom Bar (Lebar sejajar margin 16px layout utama)
          if (!isDesktop)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SafeArea(
                top: false,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF18181B).withValues(alpha: 0.75)
                            : Colors.white.withValues(alpha: 0.78),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.black.withValues(alpha: 0.08),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _FloatingNavItem(
                            index: 0,
                            icon: Icons.home_outlined,
                            activeIcon: Icons.home_rounded,
                            label: 'Home',
                            currentIndex: widget.navigationShell.currentIndex,
                            onTap: () => _goBranch(0),
                          ),
                          _FloatingNavItem(
                            index: 1,
                            icon: Icons.grid_view_outlined,
                            activeIcon: Icons.grid_view_rounded,
                            label: 'Katalog',
                            currentIndex: widget.navigationShell.currentIndex,
                            onTap: () => _goBranch(1),
                          ),
                          _FloatingNavItem(
                            index: 2,
                            icon: Icons.people_alt_outlined,
                            activeIcon: Icons.people_alt_rounded,
                            label: 'Patungan',
                            currentIndex: widget.navigationShell.currentIndex,
                            onTap: () => _goBranch(2),
                          ),
                          _FloatingNavItem(
                            index: 3,
                            icon: Icons.history_rounded,
                            activeIcon: Icons.history_rounded,
                            label: 'Riwayat',
                            currentIndex: widget.navigationShell.currentIndex,
                            onTap: () => _goBranch(3),
                          ),
                          _FloatingNavItem(
                            index: 4,
                            icon: Icons.person_outline,
                            activeIcon: Icons.person_rounded,
                            label: 'Profil',
                            currentIndex: widget.navigationShell.currentIndex,
                            onTap: () => _goBranch(4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: null,
      );
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}

class _DesktopNavLink extends StatelessWidget {
  final String label;
  final String? badge;
  final bool isActive;
  final VoidCallback onTap;

  const _DesktopNavLink({
    required this.label,
    this.badge,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isActive
                ? AirinColors.tealBrand.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive
                      ? AirinColors.tealBrand
                      : (isDark ? const Color(0xFFA1A1AA) : const Color(0xFF64748B)),
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive ? AirinColors.tealBrand : (isDark ? Colors.white12 : Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingNavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int currentIndex;
  final VoidCallback onTap;

  const _FloatingNavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.white.withValues(alpha: 0.14) : Colors.black.withValues(alpha: 0.06))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 21,
                color: isSelected
                    ? (isDark ? Colors.white : const Color(0xFF1D1D1F))
                    : const Color(0xFF86868B),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: -0.1,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF1D1D1F))
                      : const Color(0xFF86868B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
