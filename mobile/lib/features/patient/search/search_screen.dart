import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/doctor_card.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../doctor_profile/data/doctors_data.dart';
import '../doctor_profile/models/doctor.dart';
import '../home/widgets/specialties_row.dart';
import 'search_filter.dart';

enum _Sort { relevance, rating, fee }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  String _query = '';
  _Sort _sort = _Sort.relevance;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _sortLabel(_Sort sort) {
    switch (sort) {
      case _Sort.relevance:
        return 'Pertinence';
      case _Sort.rating:
        return 'Meilleure note';
      case _Sort.fee:
        return 'Tarif croissant';
    }
  }

  String _nextSlot(Doctor doctor) {
    final start = doctor.workingHours.split(' - ').first;

    if (doctor.availableDays.isEmpty) {
      return start;
    }

    return '${doctor.availableDays.first} $start';
  }

  List<Doctor> _results(String? specialty) {
    final query = SearchFilter.normalize(_query.trim());

    final selectedSpecialty = specialty == null
        ? null
        : SearchFilter.normalize(specialty);

    final results = demoDoctors.where((doctor) {
      if (selectedSpecialty != null &&
          !SearchFilter.normalize(
            doctor.specialty,
          ).contains(selectedSpecialty)) {
        return false;
      }

      if (query.isEmpty) return true;

      final searchableText = SearchFilter.normalize(
        '${doctor.fullName} '
        '${doctor.specialty} '
        '${doctor.city} '
        '${doctor.clinicName}',
      );

      return query
          .split(' ')
          .where((word) => word.isNotEmpty)
          .every(searchableText.contains);
    }).toList();

    if (_sort == _Sort.rating) {
      results.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sort == _Sort.fee) {
      results.sort((a, b) => a.consultationFee.compareTo(b.consultationFee));
    }

    return results;
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => _query = '');
  }

  void _reset() {
    _controller.clear();

    setState(() {
      _query = '';
      _sort = _Sort.relevance;
    });

    SearchFilter.specialty.value = null;
  }

  Widget _buildHeader() {
    return GradientHeader(
      title: 'Recherche',
      subtitle: 'Trouvez le spécialiste qui vous convient.',
      bottom: _buildSearchField(),
      bottomPadding: 24,
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) => setState(() => _query = value),
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          color: Color(0xFF111827),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Médecin, spécialité, ville...',
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 23,
          ),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF6B7280),
                  ),
                ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildResultsHeader(
    int count,
    String? specialty,
    bool isLight,
    Color muted,
    Color textColor,
  ) {
    final countLabel = count == 1
        ? '1 médecin trouvé'
        : '$count médecins trouvés';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  specialty ?? 'Médecins disponibles',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  countLabel,
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<_Sort>(
            initialValue: _sort,
            onSelected: (value) => setState(() => _sort = value),
            itemBuilder: (context) => [
              for (final sort in _Sort.values)
                PopupMenuItem<_Sort>(
                  value: sort,
                  child: Text(_sortLabel(sort)),
                ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: isLight ? Colors.white : AppColors.darkSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.tune_rounded,
                    size: 17,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _sortLabel(_sort),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color muted, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: AppColors.softLavender,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 42,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Aucun médecin trouvé',
            style: TextStyle(
              color: textColor,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez un autre nom, une autre spécialité ou une autre ville.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Réinitialiser la recherche'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final background = isLight ? AppColors.lightBg : AppColors.darkBg;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;
    final textColor = isLight ? AppColors.lightText : AppColors.darkText;

    return Container(
      color: background,
      child: SafeArea(
        top: false,
        child: ValueListenableBuilder<String?>(
          valueListenable: SearchFilter.specialty,
          builder: (context, specialty, _) {
            final results = _results(specialty);

            final resultWidgets = <Widget>[];

            for (var index = 0; index < results.length; index++) {
              final doctor = results[index];

              resultWidgets.add(
                DoctorCard(
                  name: doctor.fullName,
                  specialty: doctor.specialty,
                  location: '${doctor.clinicName}, ${doctor.city}',
                  rating: doctor.rating,
                  nextSlot: _nextSlot(doctor),
                  imageUrl: doctor.imageUrl,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.doctorProfile,
                      arguments: doctor,
                    );
                  },
                ),
              );

              if (index < results.length - 1) {
                resultWidgets.add(const SizedBox(height: 12));
              }
            }

            return CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: _buildHeader(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildSectionTitle(
                    'Explorer par spécialité',
                    textColor,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SpecialtiesRow(
                    onTap: (selectedSpecialty) {
                      SearchFilter.specialty.value =
                          selectedSpecialty == specialty
                          ? null
                          : selectedSpecialty;
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildResultsHeader(
                    results.length,
                    specialty,
                    isLight,
                    muted,
                    textColor,
                  ),
                ),
                if (results.isEmpty)
                  SliverToBoxAdapter(child: _buildEmptyState(muted, textColor))
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      4,
                      20,
                      MediaQuery.viewInsetsOf(context).bottom + 24,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(resultWidgets),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
