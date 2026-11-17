import 'package:flutter/material.dart';

import '../data/dashboard_data.dart';
import '../models/dashboard_models.dart';

class ConsultationsChart extends StatelessWidget {
  const ConsultationsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final consultations = DashboardData.weeklyConsultations;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EEF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activité hebdomadaire',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Nombre de consultations par jour',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Cette semaine',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 190,
            width: double.infinity,
            child: CustomPaint(
              painter: _ConsultationsChartPainter(consultations),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'Consultations',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConsultationsChartPainter extends CustomPainter {
  final List<WeeklyConsultation> consultations;

  _ConsultationsChartPainter(this.consultations);

  @override
  void paint(Canvas canvas, Size size) {
    if (consultations.isEmpty) return;

    const leftPadding = 25.0;
    const rightPadding = 8.0;
    const topPadding = 15.0;
    const bottomPadding = 27.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    const maxValue = 20.0;
    const gridLines = 4;

    final gridPaint = Paint()
      ..color = const Color(0xFFEFF3F8)
      ..strokeWidth = 1;

    final labelStyle = const TextStyle(color: Color(0xFF94A3B8), fontSize: 10);

    for (var i = 0; i <= gridLines; i++) {
      final value = i * 5;
      final y = topPadding + chartHeight - (value / maxValue) * chartHeight;

      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );

      _drawText(canvas, '$value', Offset(0, y - 6), labelStyle, width: 19);
    }

    final slotWidth = chartWidth / consultations.length;
    final barWidth = slotWidth * 0.48;

    for (var i = 0; i < consultations.length; i++) {
      final item = consultations[i];
      final barHeight = (item.count / maxValue) * chartHeight;
      final centerX = leftPadding + slotWidth * (i + 0.5);

      final barRect = Rect.fromLTWH(
        centerX - barWidth / 2,
        topPadding + chartHeight - barHeight,
        barWidth,
        barHeight,
      );

      final isHighest =
          item.count ==
          consultations.map((e) => e.count).reduce((a, b) => a > b ? a : b);

      final barPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isHighest
              ? const [Color(0xFF06B6D4), Color(0xFF2563EB)]
              : const [Color(0xFF60A5FA), Color(0xFF2563EB)],
        ).createShader(barRect);

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          barRect,
          topLeft: const Radius.circular(7),
          topRight: const Radius.circular(7),
        ),
        barPaint,
      );

      _drawText(
        canvas,
        item.day,
        Offset(centerX - slotWidth / 2, size.height - 19),
        labelStyle,
        width: slotWidth,
        align: TextAlign.center,
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style, {
    double width = 40,
    TextAlign align = TextAlign.left,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout(maxWidth: width);

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _ConsultationsChartPainter oldDelegate) {
    return oldDelegate.consultations != consultations;
  }
}
