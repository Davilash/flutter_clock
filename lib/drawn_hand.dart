// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'hand.dart';

class DrawnHand extends Hand {
  const DrawnHand({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
    @required double length,
  })  : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        assert(length != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
          length: length,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            handSize: size,
            lineWidth: thickness,
            angleRadians: angleRadians,
            color: color,
            length: length,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class _HandPainter extends CustomPainter {
  _HandPainter({
    @required this.handSize,
    @required this.lineWidth,
    @required this.angleRadians,
    @required this.color,
    @required this.length,
  })  : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0),
        assert(length != null);

  double handSize;
  double lineWidth;
  double angleRadians;
  Color color;
  double length;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final angle = angleRadians - math.pi / 2.0;

    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, position, linePaint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
