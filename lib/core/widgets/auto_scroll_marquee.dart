import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/airin_theme.dart';
import 'brand_logo.dart';

class AutoScrollMarquee extends StatefulWidget {
  const AutoScrollMarquee({super.key});

  @override
  State<AutoScrollMarquee> createState() => _AutoScrollMarqueeState();
}

class _AutoScrollMarqueeState extends State<AutoScrollMarquee> {
  late final ScrollController _scrollController;
  Timer? _timer;
  bool _isPaused = false;

  final List<Map<String, dynamic>> _items = [
    {'id': 'gemini', 'name': 'Gemini', 'angle': -0.10},
    {'id': 'netflix', 'name': 'Netflix', 'angle': 0.05},
    {'id': 'disney', 'name': 'Disney+', 'angle': -0.05},
    {'id': 'spotify', 'name': 'Spotify', 'angle': 0.10},
    {'id': 'youtube', 'name': 'YouTube', 'angle': -0.03},
    {'id': 'canva', 'name': 'Canva', 'angle': 0.07},
    {'id': 'vidio', 'name': 'Vidio', 'angle': -0.07},
    {'id': 'chatgpt', 'name': 'ChatGPT', 'angle': 0.06},
    {'id': 'apple', 'name': 'Apple', 'angle': -0.04},
    // Duplicate for seamless infinite loop
    {'id': 'gemini', 'name': 'Gemini', 'angle': -0.10},
    {'id': 'netflix', 'name': 'Netflix', 'angle': 0.05},
    {'id': 'disney', 'name': 'Disney+', 'angle': -0.05},
    {'id': 'spotify', 'name': 'Spotify', 'angle': 0.10},
    {'id': 'youtube', 'name': 'YouTube', 'angle': -0.03},
    {'id': 'canva', 'name': 'Canva', 'angle': 0.07},
    {'id': 'vidio', 'name': 'Vidio', 'angle': -0.07},
    {'id': 'chatgpt', 'name': 'ChatGPT', 'angle': 0.06},
    {'id': 'apple', 'name': 'Apple', 'angle': -0.04},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted || _isPaused || !_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      const step = 1.0; // Smooth continuous step

      if (currentScroll + step >= maxScroll) {
        _scrollController.jumpTo(0.0);
      } else {
        _scrollController.jumpTo(currentScroll + step);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AirinColors.darkBorder : AirinColors.lightBorder;
    final cardBg = isDark ? AirinColors.darkCardElevated : Colors.white;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        height: 60,
        margin: const EdgeInsets.only(top: 8, bottom: 16),
        // Gradient mask on sides (mask-image: linear-gradient ala airin-store)
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: [0.0, 0.15, 0.85, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isPaused = true),
            onExit: (_) => setState(() => _isPaused = false),
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final item = _items[index];
                final angle = item['angle'] as double;

                return Transform.rotate(
                  angle: angle,
                  child: Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: BrandLogo(
                        id: item['id'] as String,
                        name: item['name'] as String,
                        size: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

