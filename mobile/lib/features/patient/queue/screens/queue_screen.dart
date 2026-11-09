
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/queue_data.dart';
import '../widgets/queue_progress.dart';
import '../widgets/queue_ticket_card.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: AnimatedBuilder(
        animation: QueueStore.instance,
        builder: (context, child) {
          final tickets = QueueStore.instance.tickets;

          if (tickets.isEmpty) {
            return _buildEmptyState();
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            children: [
              const Text(
                'Suivez votre passage chez le médecin.',
                style: TextStyle(
                  color: AppColors.lightMuted,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              ...tickets.map(
                (ticket) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QueueTicketCard(ticket: ticket),
                      const SizedBox(height: 16),
                      QueueProgress(status: ticket.status),
                    ],
                  ),
                ),
              ),

              _buildInformationCard(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.confirmation_number_outlined,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucun ticket disponible',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.lightText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vos tickets apparaîtront ici après la confirmation de votre rendez-vous.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.lightMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Les positions et les temps d’attente affichés sont des données de démonstration. Ils ne sont pas encore synchronisés avec un cabinet médical.',
              style: TextStyle(
                color: AppColors.lightText,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
