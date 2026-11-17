import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/dashboard_data.dart';
import '../models/dashboard_models.dart';

class AppointmentsChart extends StatelessWidget {
  const AppointmentsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final statuses = DashboardData.appointmentStatuses;
    final total = statuses.fold<int>(0, (sum, item) => sum + item.count);

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
          Text(
            'Répartition des rendez-vous',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            'Vue globale des différents statuts',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 165,
                  child: CustomPaint(
                    painter: _DonutChartPainter(statuses),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$total',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const Text(
                            'Total',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 6,
                child: Column(
                  children: statuses.map((item) {
                    final percentage = total == 0
                        ? 0
                        : (item.count / total * 100).round();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: _LegendItem(item: item, percentage: percentage),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final AppointmentStatusData item;
  final int percentage;

  const _LegendItem({required this.item, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item.label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '${item.count}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 5),
        Text(
          '$percentage%',
          style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<AppointmentStatusData> statuses;

  _DonutChartPainter(this.statuses);

  @override
  void paint(Canvas canvas, Size size) {
    final total = statuses.fold<int>(0, (sum, item) => sum + item.count);

    if (total == 0) {
      final emptyPaint = Paint()
        ..color = const Color(0xFFE8EEF5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 19;

      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        55,
        emptyPaint,
      );
      return;
    }

    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 19.0;
    final radius = math.min(size.width, size.height) / 2 - strokeWidth;

    final rect = Rect.fromCircle(center: center, radius: radius);

    const gap = 0.045;
    var startAngle = -math.pi / 2;

    for (final item in statuses) {
      final sweepAngle = (item.count / total) * 2 * math.pi;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle + gap / 2,
        math.max(0, sweepAngle - gap),
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.statuses != statuses;
  }
}
