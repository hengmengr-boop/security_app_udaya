import 'package:flutter/material.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

/// Udaya Technology logo drawn in code (no image asset needed, stays sharp at any size).
final class UdayaLogo extends StatelessWidget {
  const UdayaLogo({super.key, this.width = 200});

  final double width;

  static const _w = 253.0;
  static const _h = 108.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * _h / _w,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _w,
          height: _h,
          child: Stack(
            children: [
              // * Navy plate with the name
              Positioned(
                left: 0,
                top: 13,
                width: _w,
                height: 68,
                child: Container(
                  color: AppColors.logoNavy,
                  padding: const EdgeInsets.fromLTRB(10, 0, 40, 0),
                  alignment: Alignment.centerLeft,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'UDΛYΛ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          height: 1),
                    ),
                  ),
                ),
              ),
              // * Red slash
              const Positioned.fill(
                  child: CustomPaint(painter: _SlashPainter())),
              // * Sub title
              const Positioned(
                left: 6,
                top: 82,
                child: Text(
                  'TECHNOLOGY',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _SlashPainter extends CustomPainter {
  const _SlashPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(222, 0)
      ..lineTo(241, 0)
      ..lineTo(253, 68)
      ..lineTo(234, 68)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.accent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
