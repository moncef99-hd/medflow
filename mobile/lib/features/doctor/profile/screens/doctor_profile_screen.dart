import 'package:flutter/material.dart';

import '../../../../core/session/user_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../data/doctor_photo_service.dart';
import '../data/doctor_profile_store.dart';
import '../models/doctor_profile.dart';
import '../widgets/profile_edit_section.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final DoctorProfileStore _store = DoctorProfileStore();
  final DoctorPhotoService _photoService = DoctorPhotoService();

  DoctorProfile _profile = const DoctorProfile();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _store.load();

    if (!mounted) return;

    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  Future<void> _saveProfile(DoctorProfile updatedProfile) async {
    setState(() => _isSaving = true);

    try {
      final success = await _store.save(updatedProfile);

      if (!mounted) return;

      if (success) {
        setState(() => _profile = updatedProfile);
        _showMessage('Profil enregistré avec succès.');
      } else {
        _showMessage('Impossible d’enregistrer le profil.');
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Une erreur est survenue pendant la sauvegarde.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _changePhoto() async {
    try {
      final newPhotoPath = await _photoService.pickAndSavePhoto();

      if (newPhotoPath == null || !mounted) return;

      final oldPhotoPath = _profile.photoPath;

      final updatedProfile = _profile.copyWith(photoPath: newPhotoPath);

      final success = await _store.save(updatedProfile);

      if (!mounted) return;

      if (success) {
        setState(() => _profile = updatedProfile);

        if (oldPhotoPath != null && oldPhotoPath != newPhotoPath) {
          await _photoService.deletePhoto(oldPhotoPath);
        }

        if (mounted) {
          _showMessage('Photo de profil mise à jour.');
        }
      } else {
        await _photoService.deletePhoto(newPhotoPath);
        _showMessage('Impossible de sauvegarder la photo.');
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Impossible de sélectionner cette photo.');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Widget _buildPersonalInformation() {
    return ProfileInfoCard(
      title: 'Informations personnelles',
      icon: Icons.person_outline_rounded,
      items: [
        ProfileInfoItem(
          label: 'Nom complet',
          value: UserSession.name.value,
          icon: Icons.badge_outlined,
        ),
        ProfileInfoItem(
          label: 'Adresse e-mail',
          value: UserSession.email.value,
          icon: Icons.email_outlined,
        ),
        ProfileInfoItem(
          label: 'Téléphone',
          value: UserSession.phone.value,
          icon: Icons.phone_outlined,
        ),
      ],
    );
  }

  Widget _buildProfessionalInformation() {
    return ProfileInfoCard(
      title: 'Résumé professionnel',
      icon: Icons.medical_information_outlined,
      items: [
        ProfileInfoItem(
          label: 'Spécialité',
          value: _profile.specialty,
          icon: Icons.medical_services_outlined,
        ),
        ProfileInfoItem(
          label: 'Expérience',
          value: _profile.experienceYears > 0
              ? '${_profile.experienceYears} ans'
              : '',
          icon: Icons.work_outline_rounded,
        ),
        ProfileInfoItem(
          label: 'Diplômes et formations',
          value: _profile.education,
          icon: Icons.school_outlined,
        ),
        ProfileInfoItem(
          label: 'Numéro professionnel',
          value: _profile.licenseNumber,
          icon: Icons.verified_user_outlined,
        ),
        ProfileInfoItem(
          label: 'Présentation',
          value: _profile.bio,
          icon: Icons.description_outlined,
        ),
      ],
    );
  }

  Widget _buildClinicInformation() {
    return ProfileInfoCard(
      title: 'Cabinet médical',
      icon: Icons.local_hospital_outlined,
      items: [
        ProfileInfoItem(
          label: 'Nom du cabinet',
          value: _profile.clinicName,
          icon: Icons.business_outlined,
        ),
        ProfileInfoItem(
          label: 'Adresse',
          value: _profile.clinicAddress,
          icon: Icons.location_on_outlined,
        ),
        ProfileInfoItem(
          label: 'Téléphone',
          value: _profile.clinicPhone,
          icon: Icons.phone_outlined,
        ),
      ],
    );
  }

  Widget _buildConsultationInformation() {
    return ProfileInfoCard(
      title: 'Consultations et disponibilités',
      icon: Icons.calendar_month_outlined,
      items: [
        ProfileInfoItem(
          label: 'Tarif de consultation',
          value: _profile.consultationFee > 0
              ? '${_profile.consultationFee} DT'
              : '',
          icon: Icons.payments_outlined,
        ),
        ProfileInfoItem(
          label: 'Services proposés',
          value: _profile.services.join(', '),
          icon: Icons.medical_services_outlined,
        ),
        ProfileInfoItem(
          label: 'Langues parlées',
          value: _profile.languages.join(', '),
          icon: Icons.language_rounded,
        ),
        ProfileInfoItem(
          label: 'Horaires et disponibilités',
          value: _profile.availability,
          icon: Icons.access_time_rounded,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Mon profil',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (_isSaving)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<String>(
                valueListenable: UserSession.name,
                builder: (context, name, _) {
                  return ValueListenableBuilder<String>(
                    valueListenable: UserSession.email,
                    builder: (context, email, _) {
                      return ProfileHeader(
                        name: name,
                        email: email,
                        specialty: _profile.specialty,
                        photoPath: _profile.photoPath,
                        onChangePhoto: _changePhoto,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 22),
              _buildPersonalInformation(),
              const SizedBox(height: 16),
              _buildProfessionalInformation(),
              const SizedBox(height: 16),
              _buildClinicInformation(),
              const SizedBox(height: 16),
              _buildConsultationInformation(),
              const SizedBox(height: 16),
              ProfileEditSection(
                key: ValueKey(_profile.toJson().toString()),
                profile: _profile,
                onSave: _saveProfile,
              ),
              const SizedBox(height: 28),
              Center(
                child: Text(
                  'MedFlow • Espace professionnel',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
