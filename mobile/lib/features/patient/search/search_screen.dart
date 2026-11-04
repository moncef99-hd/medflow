import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/doctor_card.dart';
import '../doctor_profile/data/doctors_data.dart';
import '../doctor_profile/models/doctor.dart';
import 'search_filter.dart';

enum _Sort { relevance, rating, fee }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  _Sort _sort = _Sort.relevance;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _sortLabel(_Sort s) {
    switch (s) {
      case _Sort.relevance:
        return 'Pertinence';
      case _Sort.rating:
        return 'Meilleure note';
      case _Sort.fee:
        return 'Tarif croissant';
    }
  }

  String _nextSlot(Doctor d) {
    final start = d.workingHours.split(' - ').first;
    if (d.availableDays.isEmpty) return start;
    return '${d.availableDays.first} $start';
  }

  List<Doctor> _results(String? specialty) {
    final q = SearchFilter.normalize(_query.trim());
    final s = specialty == null ? null : SearchFilter.normalize(specialty);

    final list = demoDoctors.where((d) {
      if (s != null && !SearchFilter.normalize(d.specialty).contains(s)) {
        return false;
      }
      if (q.isEmpty) return true;
      final haystack = SearchFilter.normalize(
          '${d.fullName} ${d.specialty} ${d.city} ${d.clinicName}');
      return q
          .split(' ')
          .where((w) => w.isNotEmpty)
          .every((w) => haystack.contains(w));
    }).toList();

    if (_sort == _Sort.rating) {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sort == _Sort.fee) {
      list.sort((a, b) => a.consultationFee.compareTo(b.consultationFee));
    }
    return list;
  }

  void _reset() {
    _controller.clear();
    setState(() {
      _query = '';
      _sort = _Sort.relevance;
    });
    SearchFilter.specialty.value = null;
  }

  Widget _chips(String? specialty) {
    final labels = ['Tous', ...SearchFilter.specialtyLabels];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final label = labels[i];
          final isAll = i == 0;
          final selected = isAll ? specialty == null : specialty == label;
          return ChoiceChip(
            label: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : null,
              ),
            ),
            selected: selected,
            showCheckmark: false,
            selectedColor: AppColors.primary,
            onSelected: (_) =>
                SearchFilter.specialty.value = isAll ? null : label,
          );
        },
      ),
    );
  }

  Widget _empty(Color muted) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: muted),
            const SizedBox(height: 12),
            const Text(
              'Aucun médecin trouvé',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Essayez un autre nom, une autre spécialité ou une autre ville.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _reset,
              child: const Text('Réinitialiser'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;
    final surface = isLight ? AppColors.lightSurface : AppColors.darkSurface;
    final border = isLight ? AppColors.lightBorder : AppColors.darkBorder;

    OutlineInputBorder outline(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c),
        );

    return SafeArea(
      child: ValueListenableBuilder<String?>(
        valueListenable: SearchFilter.specialty,
        builder: (context, specialty, _) {
          final results = _results(specialty);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Text(
                  'Rechercher',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  onChanged: (v) => setState(() => _query = v),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Médecin, spécialité, ville...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _controller.clear();
                              setState(() => _query = '');
                            },
                          ),
                    filled: true,
                    fillColor: surface,
                    border: outline(border),
                    enabledBorder: outline(border),
                    focusedBorder: outline(AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _chips(specialty),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Row(
                  children: [
                    Text(
                      results.length <= 1
                          ? '${results.length} médecin trouvé'
                          : '${results.length} médecins trouvés',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                    const Spacer(),
                    PopupMenuButton<_Sort>(
                      initialValue: _sort,
                      onSelected: (v) => setState(() => _sort = v),
                      itemBuilder: (_) => <PopupMenuEntry<_Sort>>[
                        for (final s in _Sort.values)
                          PopupMenuItem<_Sort>(
                            value: s,
                            child: Text(_sortLabel(s)),
                          ),
                      ],
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sort_rounded,
                              size: 18, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            _sortLabel(_sort),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: results.isEmpty
                    ? _empty(muted)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final d = results[i];
                          return DoctorCard(
                            name: d.fullName,
                            specialty: d.specialty,
                            location: '${d.clinicName}, ${d.city}',
                            rating: d.rating,
                            nextSlot: _nextSlot(d),
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.doctorProfile,
                              arguments: d,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}