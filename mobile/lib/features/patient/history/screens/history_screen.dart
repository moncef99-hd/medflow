import 'package:flutter/material.dart';
import '../data/consultations_data.dart';
import '../models/consultation.dart';
import '../widgets/consultation_card.dart';
import 'consultation_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Consultation> _allConsultations = ConsultationsData.getConsultations();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completed = _allConsultations.where((c) => c.status == ConsultationStatus.completed).toList();
    final upcoming = _allConsultations.where((c) => c.status == ConsultationStatus.upcoming).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Historique', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0EA5E9),
          unselectedLabelColor: Colors.grey.shade500,
          indicatorColor: const Color(0xFF0EA5E9),
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          tabs: const [
            Tab(text: 'Terminées'),
            Tab(text: 'À venir'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(completed, 'Aucune consultation terminée.'),
          _buildList(upcoming, 'Aucun rendez-vous à venir.'),
        ],
      ),
    );
  }

  Widget _buildList(List<Consultation> list, String emptyMessage) {
    if (list.isEmpty) {
      return Center(
        child: Text(emptyMessage, style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return ConsultationCard(
          consultation: item,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ConsultationDetailScreen(consultation: item)),
            );
          },
        );
      },
    );
  }
}