import 'dart:math';
import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final double progress;
  final double amplitude;
  final double speedFactor;
  final Color color;
  final double phaseShift;

  WavePainter({
    required this.progress,
    required this.amplitude,
    required this.speedFactor,
    required this.color,
    this.phaseShift = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    final waveOffset = progress * 2 * pi;

    for (double x = 0; x <= size.width; x++) {
      final y = size.height - (amplitude * sin((x / size.width * 2 * pi * speedFactor) + waveOffset + phaseShift));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => oldDelegate.progress != progress;
}