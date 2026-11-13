import 'package:flutter/material.dart';

enum FlagType { uk, cambodia }

/// Round flag drawn in code, so it renders the same on Android, iOS, Windows,
/// macOS and Linux (emoji flags do not render on Windows).
final class FlagIcon extends StatelessWidget {
  const FlagIcon({super.key, required this.type, this.size = 36});

  final FlagType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
            painter: type == FlagType.uk
                ? const _UkFlagPainter()
                : const _CambodiaFlagPainter()),
      ),
    );
  }
}

final class _UkFlagPainter extends CustomPainter {
  const _UkFlagPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const blue = Color(0xFF012169);
    const red = Color(0xFFC8102E);

    Paint stroke(Color color, double width) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    canvas.drawRect(Offset.zero & size, Paint()..color = blue);
    // * Diagonals
    for (final p in [stroke(Colors.white, w * 0.2), stroke(red, w * 0.07)]) {
      canvas.drawLine(Offset.zero, Offset(w, h), p);
      canvas.drawLine(Offset(w, 0), Offset(0, h), p);
    }
    // * Crosses
    for (final p in [stroke(Colors.white, w * 0.32), stroke(red, w * 0.18)]) {
      canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, h), p);
      canvas.drawLine(Offset(0, h / 2), Offset(w, h / 2), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

final class _CambodiaFlagPainter extends CustomPainter {
  const _CambodiaFlagPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const blue = Color(0xFF032EA1);
    const red = Color(0xFFE00025);

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.25), Paint()..color = blue);
    canvas.drawRect(
        Rect.fromLTWH(0, h * 0.25, w, h * 0.5), Paint()..color = red);
    canvas.drawRect(
        Rect.fromLTWH(0, h * 0.75, w, h * 0.25), Paint()..color = blue);

    // * Simplified Angkor Wat
    final white = Paint()..color = Colors.white;
    canvas.drawRect(
        Rect.fromLTRB(w * 0.26, h * 0.64, w * 0.74, h * 0.69), white);
    canvas.drawRect(
        Rect.fromLTRB(w * 0.33, h * 0.52, w * 0.67, h * 0.64), white);
    void tower(double cx, double top, double width) {
      final path = Path()
        ..moveTo(cx - width / 2, h * 0.52)
        ..lineTo(cx, top)
        ..lineTo(cx + width / 2, h * 0.52)
        ..close();
      canvas.drawPath(path, white);
    }

    tower(w * 0.36, h * 0.36, w * 0.13);
    tower(w * 0.50, h * 0.28, w * 0.15);
    tower(w * 0.64, h * 0.36, w * 0.13);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
