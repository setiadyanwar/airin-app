import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BrandLogo extends StatelessWidget {
  final String id;
  final String name;
  final String? imageUrl;
  final double size;

  const BrandLogo({
    super.key,
    required this.id,
    this.name = '',
    this.imageUrl,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Jika ada URL gambar/logo langsung dari API web
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      final url = imageUrl!.trim();
      if (url.startsWith('http://') || url.startsWith('https://')) {
        if (url.toLowerCase().endsWith('.svg')) {
          return _wrap(
            SvgPicture.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.contain,
              placeholderBuilder: (_) => _buildVectorLogo(context),
            ),
          );
        } else {
          return _wrap(
            CachedNetworkImage(
              imageUrl: url,
              width: size,
              height: size,
              fit: BoxFit.contain,
              errorWidget: (_, __, ___) => _buildVectorLogo(context),
            ),
          );
        }
      }
    }

    // 2. Render SVG file resmi persis seperti di web public/logos
    return _buildVectorLogo(context);
  }

  Widget _buildVectorLogo(BuildContext context) {
    final target = '${name.toLowerCase()} ${id.toLowerCase()}';

    // File SVG resmi yang sama persis dengan public/logos di Next.js airin-store
    if (target.contains('gemini')) {
      return _wrap(
        SvgPicture.asset(
          'assets/logos/gemini.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => CustomPaint(size: Size(size, size), painter: _GeminiPainter()),
        ),
      );
    } else if (target.contains('netflix')) {
      return _wrap(
        SvgPicture.asset(
          'assets/logos/netflix.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => CustomPaint(size: Size(size, size), painter: _NetflixPainter()),
        ),
      );
    } else if (target.contains('spotify')) {
      return _wrap(
        SvgPicture.asset(
          'assets/logos/spotify.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => CustomPaint(size: Size(size, size), painter: _SpotifyPainter()),
        ),
      );
    } else if (target.contains('chatgpt') || target.contains('openai')) {
      return _wrap(
        SvgPicture.asset(
          'assets/logos/chatgpt.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => CustomPaint(size: Size(size, size), painter: _ChatGptPainter()),
        ),
      );
    } else if (target.contains('canva')) {
      return _wrap(
        SvgPicture.asset(
          'assets/logos/canva.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => CustomPaint(size: Size(size, size), painter: _CanvaPainter()),
        ),
      );
    } else if (target.contains('claude')) {
      return _wrap(
        SvgPicture.asset(
          'assets/logos/claude.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => CustomPaint(size: Size(size, size), painter: _ClaudePainter()),
        ),
      );
    } else if (target.contains('youtube')) {
      return _wrap(
        SvgPicture.asset(
          'assets/logos/youtube.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => CustomPaint(size: Size(size, size), painter: _YouTubePainter()),
        ),
      );
    } else if (target.contains('perplexity')) {
      return _wrap(
        SvgPicture.asset(
          'assets/logos/perplexity.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      );
    } else if (target.contains('mlbb') || target.contains('mobile legend')) {
      return _wrap(
        Image.asset(
          'assets/icons/mlbb.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      );
    } else if (target.contains('disney')) {
      return _wrap(CustomPaint(size: Size(size, size), painter: _DisneyPainter()));
    } else if (target.contains('vidio')) {
      return _wrap(CustomPaint(size: Size(size, size), painter: _VidioPainter()));
    } else if (target.contains('apple')) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return _wrap(CustomPaint(size: Size(size, size), painter: _ApplePainter(isDark: isDark)));
    } else if (target.contains('prime') || target.contains('amazon')) {
      return _wrap(CustomPaint(size: Size(size, size), painter: _PrimeVideoPainter()));
    } else if (target.contains('duolingo')) {
      return _wrap(CustomPaint(size: Size(size, size), painter: _DuolingoPainter()));
    } else if (target.contains('cursor')) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return _wrap(CustomPaint(size: Size(size, size), painter: _CursorPainter(isDark: isDark)));
    }

    // Default Play/Airin Icon
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF0D9488).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'A',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D9488),
          ),
        ),
      ),
    );
  }

  Widget _wrap(Widget child) {
    return SizedBox(width: size, height: size, child: child);
  }
}

// -------------------------------------------------------------
// 1. Google Gemini: 4-color gradient sparkle flare
// -------------------------------------------------------------
class _GeminiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final rect = const Offset(0, 0) & const Size(24, 24);
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF1BA0E2),
          Color(0xFF4285F4),
          Color(0xFF9B72CB),
          Color(0xFFD96570),
        ],
        stops: [0.0, 0.35, 0.70, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    // SVG d="M11.04 19.32Q12 21.51 12 24q0-2.49.93-4.68.96-2.19 2.58-3.81t3.81-2.55Q21.51 12 24 12q-2.49 0-4.68-.93a12.3 12.3 0 0 1-3.81-2.58 12.3 12.3 0 0 1-2.58-3.81Q12 2.49 12 0q0 2.49-.96 4.68-.93 2.19-2.55 3.81a12.3 12.3 0 0 1-3.81 2.58Q2.49 12 0 12q2.49 0 4.68.96 2.19.93 3.81 2.55t2.55 3.81"
    final path = Path()
      ..moveTo(11.04, 19.32)
      ..quadraticBezierTo(12, 21.51, 12, 24)
      ..quadraticBezierTo(12, 21.51, 12.93, 19.32)
      ..cubicTo(13.89, 17.13, 15.27, 15.75, 16.74, 14.79)
      ..cubicTo(18.21, 13.83, 20.25, 12.96, 24, 12)
      ..cubicTo(20.25, 11.04, 18.21, 10.17, 16.74, 9.21)
      ..cubicTo(15.27, 8.25, 13.89, 6.87, 12.93, 4.68)
      ..quadraticBezierTo(12, 2.49, 12, 0)
      ..quadraticBezierTo(12, 2.49, 11.04, 4.68)
      ..cubicTo(10.11, 6.87, 8.73, 8.25, 7.26, 9.21)
      ..cubicTo(5.79, 10.17, 3.75, 11.04, 0, 12)
      ..cubicTo(3.75, 12.96, 5.79, 13.83, 7.26, 14.79)
      ..cubicTo(8.73, 15.75, 10.11, 17.13, 11.04, 19.32)
      ..close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// 2. Netflix: Official 3D Red Ribbon N
// -------------------------------------------------------------
class _NetflixPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Left shadow post
    final leftPost = Path()
      ..moveTo(5.4, 0)
      ..lineTo(10.1, 0)
      ..lineTo(10.1, 23.6)
      ..lineTo(5.4, 24)
      ..close();
    canvas.drawPath(leftPost, Paint()..color = const Color(0xFFB81D24));

    // Right shadow post
    final rightPost = Path()
      ..moveTo(13.9, 0)
      ..lineTo(18.6, 0)
      ..lineTo(18.6, 23.6)
      ..lineTo(13.9, 23.6)
      ..close();
    canvas.drawPath(rightPost, Paint()..color = const Color(0xFFB81D24));

    // Diagonal bright ribbon
    final diagonal = Path()
      ..moveTo(5.4, 0)
      ..lineTo(10.1, 0)
      ..lineTo(18.6, 23.6)
      ..lineTo(13.9, 23.6)
      ..close();
    canvas.drawPath(diagonal, Paint()..color = const Color(0xFFE50914));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// 3. Spotify: Green circle with 3 curved soundwaves
// -------------------------------------------------------------
class _SpotifyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Green Background Circle
    final bgPaint = Paint()..color = const Color(0xFF1ED760);
    canvas.drawCircle(const Offset(12, 12), 12, bgPaint);

    final wavePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Top wave
    wavePaint.strokeWidth = 2.4;
    final topWave = Path()
      ..moveTo(5.2, 8.8)
      ..cubicTo(9.5, 7.2, 15.0, 7.6, 18.8, 10.2);
    canvas.drawPath(topWave, wavePaint);

    // Middle wave
    wavePaint.strokeWidth = 2.0;
    final midWave = Path()
      ..moveTo(6.0, 12.6)
      ..cubicTo(9.8, 11.2, 14.4, 11.6, 17.6, 13.8);
    canvas.drawPath(midWave, wavePaint);

    // Bottom wave
    wavePaint.strokeWidth = 1.6;
    final botWave = Path()
      ..moveTo(7.0, 16.2)
      ..cubicTo(10.2, 15.0, 13.8, 15.4, 16.5, 17.2);
    canvas.drawPath(botWave, wavePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// 4. Disney+: Official Dark Navy + Script + Cyan Arc
// -------------------------------------------------------------
class _DisneyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Navy rounded rect
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 24, 24),
      const Radius.circular(5.5),
    );
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF04092B));

    // Cyan Disney Arc
    final arcPaint = Paint()
      ..color = const Color(0xFF4CD8FB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final arcPath = Path()
      ..moveTo(3.5, 14.5)
      ..cubicTo(6.5, 5.0, 15.5, 4.5, 20.5, 13.5);
    canvas.drawPath(arcPath, arcPaint);

    // Curved 'D'
    final dPath = Path()
      ..moveTo(6.0, 7.5)
      ..cubicTo(10.5, 7.0, 13.5, 9.5, 13.0, 13.5)
      ..cubicTo(12.5, 17.0, 9.0, 18.0, 5.5, 17.5)
      ..lineTo(7.0, 8.5)
      ..close();
    canvas.drawPath(dPath, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.6);

    // Plus sign '+'
    final plusPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(16.5, 13.0), const Offset(19.5, 13.0), plusPaint);
    canvas.drawLine(const Offset(18.0, 11.5), const Offset(18.0, 14.5), plusPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// 5. YouTube: Red Play Badge
// -------------------------------------------------------------
class _YouTubePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Red rounded badge
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0.8, 3.5, 22.4, 17.0),
      const Radius.circular(5.5),
    );
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFFFF0000));

    // White play triangle
    final path = Path()
      ..moveTo(9.5, 8.4)
      ..lineTo(16.0, 12.0)
      ..lineTo(9.5, 15.6)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.white);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// 6. Canva: Official Turquoise Blue with Script C
// -------------------------------------------------------------
class _CanvaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Turquoise Circle
    canvas.drawCircle(const Offset(12, 12), 12, Paint()..color = const Color(0xFF00C4CC));

    // White C cursive script
    final path = Path()
      ..moveTo(16.5, 8.5)
      ..cubicTo(13.0, 5.5, 7.5, 7.5, 7.5, 12.0)
      ..cubicTo(7.5, 16.5, 12.5, 18.5, 16.5, 15.5)
      ..cubicTo(15.0, 16.2, 11.0, 15.5, 10.2, 12.0)
      ..cubicTo(9.5, 8.8, 14.0, 7.5, 16.5, 8.5)
      ..close();

    canvas.drawPath(path, Paint()..color = Colors.white);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// 7. OpenAI / ChatGPT: Official Teal Rosette
// -------------------------------------------------------------
class _ChatGptPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()
      ..color = const Color(0xFF10A37F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final center = const Offset(12, 12);
    final r = 7.2;

    // Draw 6 interlocking petals
    for (int i = 0; i < 6; i++) {
      final angle = i * (math.pi / 3);
      final x1 = center.dx + math.cos(angle) * (r * 0.4);
      final y1 = center.dy + math.sin(angle) * (r * 0.4);
      final x2 = center.dx + math.cos(angle) * r;
      final y2 = center.dy + math.sin(angle) * r;
      final x3 = center.dx + math.cos(angle + math.pi / 3) * r;
      final y3 = center.dy + math.sin(angle + math.pi / 3) * r;

      final p = Path()
        ..moveTo(x1, y1)
        ..lineTo(x2, y2)
        ..arcToPoint(Offset(x3, y3), radius: Radius.circular(r * 0.5))
        ..close();
      canvas.drawPath(p, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// 8. Vidio: Official Red Ribbon V
// -------------------------------------------------------------
class _VidioPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Official Ribbon V in #FC0F3A
    final paint = Paint()
      ..color = const Color(0xFFFC0F3A)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(2.5, 4.0)
      ..cubicTo(5.5, 3.5, 8.5, 6.0, 9.5, 9.5)
      ..cubicTo(10.5, 13.0, 11.5, 17.5, 12.0, 20.0)
      ..cubicTo(14.5, 14.5, 18.0, 8.5, 21.0, 4.0)
      ..cubicTo(22.5, 4.5, 22.0, 7.5, 20.5, 10.5)
      ..cubicTo(17.5, 16.5, 13.5, 21.5, 11.5, 21.5)
      ..cubicTo(9.5, 21.5, 8.5, 17.0, 7.0, 12.0)
      ..cubicTo(5.5, 7.5, 3.5, 5.5, 2.5, 4.0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// 9. Apple: Official Silhouette with Leaf
// -------------------------------------------------------------
class _ApplePainter extends CustomPainter {
  final bool isDark;
  _ApplePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()..color = isDark ? Colors.white : const Color(0xFF1D1D1F);

    // Apple body with bite on right
    final body = Path()
      ..moveTo(12.0, 6.5)
      ..cubicTo(14.5, 6.5, 16.5, 7.8, 17.5, 9.5)
      ..cubicTo(15.2, 10.8, 15.2, 14.2, 17.8, 15.5)
      ..cubicTo(16.5, 18.2, 14.8, 21.5, 12.0, 21.5)
      ..cubicTo(10.2, 21.5, 9.0, 20.2, 7.2, 20.2)
      ..cubicTo(5.2, 20.2, 3.8, 21.5, 2.2, 17.5)
      ..cubicTo(0.8, 13.5, 2.5, 8.5, 6.2, 8.2)
      ..cubicTo(8.0, 8.0, 9.8, 9.5, 11.0, 9.5)
      ..cubicTo(11.5, 9.5, 10.5, 6.5, 12.0, 6.5)
      ..close();
    canvas.drawPath(body, paint);

    // Apple leaf
    final leaf = Path()
      ..moveTo(14.5, 2.5)
      ..cubicTo(15.5, 3.8, 15.2, 5.5, 14.0, 6.2)
      ..cubicTo(13.0, 5.0, 13.2, 3.5, 14.5, 2.5)
      ..close();
    canvas.drawPath(leaf, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ApplePainter oldDelegate) => oldDelegate.isDark != isDark;
}

// -------------------------------------------------------------
// 10. Amazon Prime Video: Navy Badge + Cyan Smile Arrow
// -------------------------------------------------------------
class _PrimeVideoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Navy rounded rect
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 24, 24),
      const Radius.circular(5.5),
    );
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF1A242F));

    // Cyan smile arrow (#00A8E1)
    final arrowPaint = Paint()
      ..color = const Color(0xFF00A8E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final smilePath = Path()
      ..moveTo(5.0, 15.0)
      ..quadraticBezierTo(12.0, 19.5, 19.0, 15.0);
    canvas.drawPath(smilePath, arrowPaint);

    // Arrowhead
    final headPath = Path()
      ..moveTo(17.5, 13.5)
      ..lineTo(19.5, 15.0)
      ..lineTo(18.0, 17.0);
    canvas.drawPath(headPath, arrowPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// 11. Duolingo: Green badge + Owl Mascot Eyes & Beak
// -------------------------------------------------------------
class _DuolingoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Green rounded rect
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 24, 24),
      const Radius.circular(5.5),
    );
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF58CC02));

    // White big eyes
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(8.5, 10.5), 3.5, whitePaint);
    canvas.drawCircle(const Offset(15.5, 10.5), 3.5, whitePaint);

    // Pupils
    final pupilPaint = Paint()..color = const Color(0xFF4B4B4B);
    canvas.drawCircle(const Offset(9.0, 10.5), 1.8, pupilPaint);
    canvas.drawCircle(const Offset(15.0, 10.5), 1.8, pupilPaint);

    // Orange beak
    final beak = Path()
      ..moveTo(10.5, 13.5)
      ..lineTo(13.5, 13.5)
      ..lineTo(12.0, 16.5)
      ..close();
    canvas.drawPath(beak, Paint()..color = const Color(0xFFFF9600));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// 12. Claude by Anthropic: Terracotta Rosette
// -------------------------------------------------------------
class _ClaudePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()..color = const Color(0xFFD97757);
    final center = const Offset(12, 12);

    for (int i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);
      final r1 = (i % 2 == 0) ? 9.5 : 6.5;
      final x = center.dx + math.cos(angle) * r1;
      final y = center.dy + math.sin(angle) * r1;
      canvas.drawCircle(Offset(x, y), 2.2, paint);
    }
    canvas.drawCircle(center, 3.2, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// 13. Cursor: Official Isometric Cube
// -------------------------------------------------------------
class _CursorPainter extends CustomPainter {
  final bool isDark;
  _CursorPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()
      ..color = isDark ? Colors.white : const Color(0xFF1D1D1F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // Outer hexagon cube
    final path = Path()
      ..moveTo(12.0, 3.0)
      ..lineTo(20.0, 7.5)
      ..lineTo(20.0, 16.5)
      ..lineTo(12.0, 21.0)
      ..lineTo(4.0, 16.5)
      ..lineTo(4.0, 7.5)
      ..close();
    canvas.drawPath(path, paint);

    // Inner 3 isometric lines connecting to center
    canvas.drawLine(const Offset(12.0, 12.0), const Offset(12.0, 3.0), paint);
    canvas.drawLine(const Offset(12.0, 12.0), const Offset(20.0, 16.5), paint);
    canvas.drawLine(const Offset(12.0, 12.0), const Offset(4.0, 16.5), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CursorPainter oldDelegate) => oldDelegate.isDark != isDark;
}
