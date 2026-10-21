import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Angular color bands echo the artwork used throughout the reference kit.
class BrandBackdrop extends StatelessWidget {
  const BrandBackdrop({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppPalette.plum, Color(0xFF251B49), Color(0xFF113A66)],
      ),
    ),
    child: CustomPaint(
      painter: _LightBandsPainter(),
      child: child ?? const SizedBox.expand(),
    ),
  );
}

class _LightBandsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bands = <(double, double, double, Color)>[
      (-.28, .15, .26, const Color(0xFF9D36C8)),
      (.10, .36, .19, const Color(0xFF4F35AB)),
      (.48, .47, .18, const Color(0xFF4164B5)),
      (.78, .70, .13, const Color(0xFF16A6C0)),
    ];
    for (final (start, end, width, color) in bands) {
      final path = Path()
        ..moveTo(size.width * start, size.height)
        ..lineTo(size.width * (start + width), size.height)
        ..lineTo(size.width * (end + width), 0)
        ..lineTo(size.width * end, 0)
        ..close();
      canvas.drawPath(path, Paint()..color = color.withValues(alpha: .24));
    }
    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppPalette.violetLight.withValues(alpha: .23),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * .76, size.height * .55),
              radius: size.width * .55,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * .76, size.height * .55),
      size.width * .55,
      glow,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
