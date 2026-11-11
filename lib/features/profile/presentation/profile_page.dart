import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/airin_theme.dart';
import '../../../core/widgets/airin_logo.dart';
import '../../catalog/presentation/providers.dart';
import 'widgets/auth_modal.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);
    final user = ref.watch(authProvider);
    final orderCount = ref.watch(orderHistoryProvider).length;

    final bg = isDark ? AirinColors.darkBg : AirinColors.lightSecondaryBg;
    final cardBg = isDark ? AirinColors.darkCardElevated : Colors.white;
    final textPrimary = isDark ? AirinColors.darkTextPrimary : AirinColors.lightTextPrimary;
    final textSecondary = isDark ? AirinColors.darkTextSecondary : AirinColors.lightTextSecondary;
    final border = isDark ? AirinColors.darkBorder : AirinColors.lightBorder;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Akun & Pengaturan',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // User Info Card or Guest Card
              if (user != null)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Notionist Style Avatar
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4EBD0),
                              shape: BoxShape.circle,
                              border: Border.all(color: AirinColors.tealBrand, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'A',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D1D1F),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        user.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AirinColors.tealBrand.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        user.role.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: AirinColors.tealBrand,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user.email,
                                  style: TextStyle(fontSize: 12, color: textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '$orderCount',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              Text('Pesanan', style: TextStyle(fontSize: 11, color: textSecondary)),
                            ],
                          ),
                          Container(width: 1, height: 24, color: border),
                          Column(
                            children: [
                              const Text(
                                'Aktif',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF059669),
                                ),
                              ),
                              Text('Status Garansi', style: TextStyle(fontSize: 11, color: textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    children: [
                      const AirinLogoMark(size: 40),
                      const SizedBox(height: 12),
                      Text(
                        'Masuk ke Akun Airin',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kelola pesanan, klaim garansi, dan bergabung ke grup patungan dengan mudah.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: textSecondary, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _showAuthModal(context, ref, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AirinColors.tealBrand,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text('Masuk atau Daftar', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Setting Section: Tampilan & Preferensi
              Text(
                'TAMPILAN & PREFERENSI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AirinColors.tealBrand,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        'Mode Gelap (Dark Mode)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
                      ),
                      subtitle: Text(
                        isDark ? 'Tema gelap aktif' : 'Tema terang aktif',
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                      secondary: Icon(
                        isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                        color: AirinColors.tealBrand,
                      ),
                      activeColor: AirinColors.tealBrand,
                      value: themeMode == ThemeMode.dark,
                      onChanged: (_) {
                        ref.read(themeModeProvider.notifier).toggleTheme();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Setting Section: Bantuan & Informasi
              Text(
                'BANTUAN & INFORMASI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AirinColors.tealBrand,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.send_rounded, color: AirinColors.tealBrand),
                      title: Text('Bot Telegram Resmi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      subtitle: Text('@airinappstore_bot', style: TextStyle(fontSize: 12, color: textSecondary)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Membuka Telegram @airinappstore_bot')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.security_rounded, color: AirinColors.tealBrand),
                      title: Text('Jaminan Privasi & Keamanan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      subtitle: Text('100% tanpa meminta password akun pribadi', style: TextStyle(fontSize: 12, color: textSecondary)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description_outlined, color: AirinColors.tealBrand),
                      title: Text('Syarat & Ketentuan Layanan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              if (user != null) ...[
                const SizedBox(height: 20),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Berhasil keluar dari akun')),
                      );
                    },
                    icon: const Icon(Icons.logout_rounded, size: 16, color: Color(0xFFEF4444)),
                    label: const Text(
                      'Keluar dari Akun',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // App Version Branding Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    const AirinLogoMark(size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Airin Store Mobile App', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)),
                          Text('Versi 1.0.0 (Build 2026.11) • Gemini Dual Flare', style: TextStyle(fontSize: 11, color: textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAuthModal(BuildContext context, WidgetRef ref, bool isLogin) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AuthModal(),
    );
  }
}
