import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class DishGenieWordmark extends StatelessWidget {
  final double fontSize;
  final bool showAccent;
  final bool showUnderline;
  final MainAxisSize mainAxisSize;

  const DishGenieWordmark({
    super.key,
    this.fontSize = 26,
    this.showAccent = true,
    this.showUnderline = false,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) {
    final text = GoogleFonts.nunito(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: AppColors.primary,
      letterSpacing: -1.1,
      height: 0.95,
    );

    return Column(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Dish', style: text),
                  TextSpan(
                    text: 'Genie',
                    style: text.copyWith(color: AppColors.primaryDark),
                  ),
                ],
              ),
            ),
            if (showAccent) ...[
              const SizedBox(width: 4),
              Padding(
                padding: EdgeInsets.only(top: fontSize * 0.14),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: fontSize * 0.42,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ],
        ),
        if (showUnderline)
          Container(
            margin: EdgeInsets.only(top: fontSize * 0.06, left: 2),
            width: fontSize * 2.55,
            height: fontSize * 0.1,
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(fontSize),
            ),
          ),
      ],
    );
  }
}

class DishGenieBurst extends StatelessWidget {
  final double size;
  final Color color;
  final Alignment alignment;
  final bool reverse;

  const DishGenieBurst({
    super.key,
    required this.size,
    required this.color,
    this.alignment = Alignment.center,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DishGenieBurstPainter(
          color: color,
          reverse: reverse,
          alignment: alignment,
        ),
      ),
    );
  }
}

class DishGenieLoadingView extends StatelessWidget {
  final String subtitle;

  const DishGenieLoadingView({
    super.key,
    this.subtitle = 'Preparing Khmer flavors for you',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -30,
          left: -42,
          child: DishGenieBurst(
            size: 138,
            color: AppColors.primarySoft,
            alignment: Alignment.topLeft,
          ),
        ),
        Positioned(
          bottom: -54,
          right: -28,
          child: DishGenieBurst(
            size: 248,
            color: AppColors.primaryLight.withValues(alpha: 0.95),
            alignment: Alignment.bottomRight,
            reverse: true,
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DishGenieWordmark(fontSize: 34, showUnderline: true),
              const SizedBox(height: 18),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.primary,
                  backgroundColor: AppColors.primarySoft,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DishGenieBurstPainter extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool reverse;

  const _DishGenieBurstPainter({
    required this.color,
    required this.alignment,
    required this.reverse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = math.max(3, size.shortestSide * 0.022)
      ..strokeCap = StrokeCap.round;

    final center = Offset(
      alignment.x < 0 ? 0 : size.width,
      alignment.y < 0 ? 0 : size.height,
    );
    final radius = size.shortestSide * 0.92;
    final startAngle = reverse ? math.pi : -math.pi / 2;
    final sweep = math.pi / 2;

    for (int i = 0; i <= 22; i++) {
      final angle = startAngle + (sweep / 22) * i;
      final end = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(center, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DishGenieBurstPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.alignment != alignment ||
        oldDelegate.reverse != reverse;
  }
}
