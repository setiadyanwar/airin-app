import 'package:flutter/material.dart';
import '../theme/airin_theme.dart';

class AirinLogoMark extends StatelessWidget {
  final double size;
  final Color? leftColor;
  final Color? rightColor;

  const AirinLogoMark({
    super.key,
    this.size = 24,
    this.leftColor,
    this.rightColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveLeft = leftColor ?? (isDark ? Colors.white : AirinColors.lightTextPrimary);
    final effectiveRight = rightColor ?? AirinColors.tealBrand;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AirinLogoPainter(
          leftColor: effectiveLeft,
          rightColor: effectiveRight,
        ),
      ),
    );
  }
}

class _AirinLogoPainter extends CustomPainter {
  final Color leftColor;
  final Color rightColor;

  _AirinLogoPainter({required this.leftColor, required this.rightColor});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Left petal: d="M 11.2 2.5 C 11.2 7.7 7.2 12 2.5 12 C 7.2 12 11.2 16.3 11.2 21.5 C 11.2 16.3 11.2 12 11.2 2.5 Z"
    final leftPath = Path()
      ..moveTo(11.2, 2.5)
      ..cubicTo(11.2, 7.7, 7.2, 12.0, 2.5, 12.0)
      ..cubicTo(7.2, 12.0, 11.2, 16.3, 11.2, 21.5)
      ..cubicTo(11.2, 16.3, 11.2, 12.0, 11.2, 2.5)
      ..close();

    final leftPaint = Paint()
      ..color = leftColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(leftPath, leftPaint);

    // Right petal: d="M 12.8 2.5 C 12.8 7.7 16.8 12 21.5 12 C 16.8 12 12.8 16.3 12.8 21.5 C 12.8 16.3 12.8 12 12.8 2.5 Z"
    final rightPath = Path()
      ..moveTo(12.8, 2.5)
      ..cubicTo(12.8, 7.7, 16.8, 12.0, 21.5, 12.0)
      ..cubicTo(16.8, 12.0, 12.8, 16.3, 12.8, 21.5)
      ..cubicTo(12.8, 16.3, 12.8, 12.0, 12.8, 2.5)
      ..close();

    final rightPaint = Paint()
      ..color = rightColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(rightPath, rightPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AirinLogoPainter oldDelegate) {
    return oldDelegate.leftColor != leftColor || oldDelegate.rightColor != rightColor;
  }
}

