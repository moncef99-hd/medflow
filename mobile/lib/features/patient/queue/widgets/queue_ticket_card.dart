import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/queue_ticket.dart';
import 'queue_status_badge.dart';

class QueueTicketCard extends StatelessWidget {
  final QueueTicket ticket;

  const QueueTicketCard({
    super.key,
    required this.ticket,
  });

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year à $hour:$minute';
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.lightMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.lightMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.lightText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = ticket.appointment.doctor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MON TICKET',
                style: TextStyle(
                  color: AppColors.lightMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              QueueStatusBadge(status: ticket.status),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const Text(
                  'Numéro de passage',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ticket.ticketNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.lightBg,
                backgroundImage: doctor.imageUrl != null
                    ? NetworkImage(doctor.imageUrl!)
                    : null,
                child: doctor.imageUrl == null
                    ? const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 27,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.fullName,
                      style: const TextStyle(
                        color: AppColors.lightText,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(
                        color: AppColors.lightMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: AppColors.lightBorder),
          const SizedBox(height: 14),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date du rendez-vous',
            value: _formatDate(ticket.appointment.dateTime),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.local_hospital_outlined,
            label: 'Cabinet médical',
            value: doctor.clinicName,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Adresse',
            value: '${doctor.address}, ${doctor.city}',
          ),
          const SizedBox(height: 18),
          const Divider(color: AppColors.lightBorder),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildQueueMetric(
                  icon: Icons.people_outline,
                  label: 'Position',
                  value: '${ticket.position}',
                  suffix: 'e',
                ),
              ),
              Container(
                width: 1,
                height: 45,
                color: AppColors.lightBorder,
              ),
              Expanded(
                child: _buildQueueMetric(
                  icon: Icons.access_time,
                  label: 'Attente estimée',
                  value: '${ticket.estimatedWaitMinutes}',
                  suffix: ' min',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQueueMetric({
    required IconData icon,
    required String label,
    required String value,
    required String suffix,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 21),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.lightMuted,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value$suffix',
          style: const TextStyle(
            color: AppColors.lightText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
