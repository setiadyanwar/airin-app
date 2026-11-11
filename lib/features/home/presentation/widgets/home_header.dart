import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/airin_logo.dart';
import '../../../catalog/presentation/providers.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final textSecondary = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF86868B);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08);
    final inputBg = isDark ? const Color(0xFF202024) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF121214) : const Color(0xFFFBFBFD)).withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(color: borderColor, width: 0.8),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        children: [
          // Baris Atas: Logo Brand + Quick Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo 'airin' persis web
              Row(
                children: [
                  const AirinLogoMark(size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'airin',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),

              // Theme toggle & CS Support
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: inputBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                        color: textSecondary,
                        size: 16,
                      ),
                      onPressed: () {
                        ref.read(themeModeProvider.notifier).toggleTheme();
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: inputBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor),
                    ),
                    child: IconButton(
                      tooltip: 'Bantuan Customer Service',
                      icon: const Icon(
                        Icons.support_agent_rounded,
                        color: Color(0xFF0D9488),
                        size: 17,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Menghubungi Customer Service @airinappstore_bot'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Search Box (Rounded-full, persis web GlobalSearch)
          GestureDetector(
            onTap: () => context.go('/catalog'),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, size: 16, color: textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cari produk (Netflix, Canva, Gemini)...',
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondary,
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
