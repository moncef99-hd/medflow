import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/doctor_profile.dart';

class ProfileEditSection extends StatefulWidget {
  final DoctorProfile profile;
  final ValueChanged<DoctorProfile> onSave;

  const ProfileEditSection({
    super.key,
    required this.profile,
    required this.onSave,
  });

  @override
  State<ProfileEditSection> createState() => _ProfileEditSectionState();
}

class _ProfileEditSectionState extends State<ProfileEditSection> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _specialtyController;
  late final TextEditingController _experienceController;
  late final TextEditingController _licenseController;
  late final TextEditingController _educationController;
  late final TextEditingController _bioController;
  late final TextEditingController _clinicController;
  late final TextEditingController _addressController;
  late final TextEditingController _clinicPhoneController;
  late final TextEditingController _feeController;
  late final TextEditingController _servicesController;
  late final TextEditingController _languagesController;
  late final TextEditingController _availabilityController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    final profile = widget.profile;

    _specialtyController = TextEditingController(text: profile.specialty);
    _experienceController = TextEditingController(
      text: profile.experienceYears == 0
          ? ''
          : profile.experienceYears.toString(),
    );
    _licenseController = TextEditingController(text: profile.licenseNumber);
    _educationController = TextEditingController(text: profile.education);
    _bioController = TextEditingController(text: profile.bio);
    _clinicController = TextEditingController(text: profile.clinicName);
    _addressController = TextEditingController(text: profile.clinicAddress);
    _clinicPhoneController = TextEditingController(text: profile.clinicPhone);
    _feeController = TextEditingController(
      text: profile.consultationFee == 0
          ? ''
          : profile.consultationFee.toString(),
    );
    _servicesController = TextEditingController(
      text: profile.services.join(', '),
    );
    _languagesController = TextEditingController(
      text: profile.languages.join(', '),
    );
    _availabilityController = TextEditingController(text: profile.availability);
  }

  @override
  void dispose() {
    _specialtyController.dispose();
    _experienceController.dispose();
    _licenseController.dispose();
    _educationController.dispose();
    _bioController.dispose();
    _clinicController.dispose();
    _addressController.dispose();
    _clinicPhoneController.dispose();
    _feeController.dispose();
    _servicesController.dispose();
    _languagesController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final updatedProfile = widget.profile.copyWith(
      specialty: _specialtyController.text.trim(),
      experienceYears: int.tryParse(_experienceController.text.trim()) ?? 0,
      licenseNumber: _licenseController.text.trim(),
      education: _educationController.text.trim(),
      bio: _bioController.text.trim(),
      clinicName: _clinicController.text.trim(),
      clinicAddress: _addressController.text.trim(),
      clinicPhone: _clinicPhoneController.text.trim(),
      consultationFee:
          double.tryParse(_feeController.text.trim().replaceAll(',', '.')) ?? 0,
      services: _parseList(_servicesController.text),
      languages: _parseList(_languagesController.text),
      availability: _availabilityController.text.trim(),
    );

    widget.onSave(updatedProfile);

    setState(() => _isEditing = false);
  }

  List<String> _parseList(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 9),
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: _isEditing
              ? Theme.of(context).cardColor
              : AppColors.lightBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Informations professionnelles',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  tooltip: _isEditing ? 'Annuler' : 'Modifier',
                  onPressed: () {
                    setState(() => _isEditing = !_isEditing);
                  },
                  icon: Icon(
                    _isEditing ? Icons.close_rounded : Icons.edit_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            _sectionTitle('Profil professionnel', Icons.medical_services),
            _field('Spécialité', _specialtyController),
            _field(
              'Années d’expérience',
              _experienceController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    int.tryParse(value) == null) {
                  return 'Entrez un nombre entier valide';
                }
                return null;
              },
            ),
            _field('Numéro professionnel', _licenseController),
            _field('Diplômes et formations', _educationController, maxLines: 2),
            _field('Présentation', _bioController, maxLines: 4),
            _sectionTitle('Cabinet médical', Icons.local_hospital_outlined),
            _field('Nom du cabinet', _clinicController),
            _field('Adresse du cabinet', _addressController, maxLines: 2),
            _field(
              'Téléphone du cabinet',
              _clinicPhoneController,
              keyboardType: TextInputType.phone,
            ),
            _sectionTitle('Consultations', Icons.calendar_month_outlined),
            _field(
              'Tarif de consultation (DT)',
              _feeController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    double.tryParse(value.replaceAll(',', '.')) == null) {
                  return 'Entrez un tarif valide';
                }
                return null;
              },
            ),
            _field(
              'Services proposés',
              _servicesController,
              hint: 'Consultation, suivi, diagnostic...',
              maxLines: 2,
            ),
            _field(
              'Langues parlées',
              _languagesController,
              hint: 'Français, Arabe, Anglais',
            ),
            _field(
              'Disponibilités et horaires',
              _availabilityController,
              hint: 'Lundi - Vendredi : 08h00 - 17h00',
              maxLines: 2,
            ),
            if (_isEditing) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.save_rounded),
                  label: const Text(
                    'Enregistrer les modifications',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
