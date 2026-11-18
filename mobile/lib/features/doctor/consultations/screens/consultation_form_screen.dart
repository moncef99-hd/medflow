import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/soft_card.dart';
import '../data/doctor_consultations_store.dart';
import '../models/doctor_consultation.dart';

class ConsultationFormScreen extends StatefulWidget {
  final DoctorConsultation consultation;

  const ConsultationFormScreen({super.key, required this.consultation});

  @override
  State<ConsultationFormScreen> createState() => _ConsultationFormScreenState();
}

class _ConsultationFormScreenState extends State<ConsultationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _reasonController;
  late final TextEditingController _observationsController;
  late final TextEditingController _reportController;
  late final TextEditingController _recommendationsController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController(text: widget.consultation.reason);
    _observationsController = TextEditingController(
      text: widget.consultation.observations,
    );
    _reportController = TextEditingController(text: widget.consultation.report);
    _recommendationsController = TextEditingController(
      text: widget.consultation.recommendations,
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _observationsController.dispose();
    _reportController.dispose();
    _recommendationsController.dispose();
    super.dispose();
  }

  DoctorConsultation _buildUpdatedConsultation() {
    return widget.consultation.copyWith(
      reason: _reasonController.text.trim(),
      observations: _observationsController.text.trim(),
      report: _reportController.text.trim(),
      recommendations: _recommendationsController.text.trim(),
    );
  }

  void _save({required bool complete}) {
    if (!_formKey.currentState!.validate()) return;

    var updated = _buildUpdatedConsultation();

    if (complete) {
      updated = updated.copyWith(status: DoctorConsultationStatus.completed);
    }

    DoctorConsultationsStore.instance.updateConsultation(updated);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          complete
              ? 'Consultation terminée et enregistrée.'
              : 'Consultation enregistrée.',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context, true);
  }

  Widget _sectionTitle(String title, String subtitle, IconData icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _textField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required int maxLines,
    bool requiredField = false,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 9),
        TextFormField(
          controller: controller,
          minLines: maxLines,
          maxLines: maxLines,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: hint,
            alignLabelWithHint: true,
            filled: true,
            fillColor: theme.brightness == Brightness.light
                ? AppColors.lightBg
                : AppColors.darkBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: theme.brightness == Brightness.light
                    ? AppColors.lightBorder
                    : AppColors.darkBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
          validator: requiredField
              ? (value) => value == null || value.trim().isEmpty
                    ? 'Ce champ est obligatoire.'
                    : null
              : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = widget.consultation.dateTime;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consultation médicale',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 27,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.10,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.consultation.patientName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.consultation.patientPhone,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.success,
                        ),
                      ],
                    ),
                    const Divider(height: 25),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${date.day.toString().padLeft(2, '0')}/'
                          '${date.month.toString().padLeft(2, '0')}/'
                          '${date.year}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(
                      'Motif de consultation',
                      'Pourquoi le patient consulte-t-il ?',
                      Icons.assignment_outlined,
                    ),
                    const SizedBox(height: 20),
                    _textField(
                      label: 'Motif',
                      hint: 'Saisir le motif de consultation...',
                      controller: _reasonController,
                      maxLines: 2,
                      requiredField: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(
                      'Observations médicales',
                      'Informations recueillies pendant la consultation',
                      Icons.medical_information_outlined,
                    ),
                    const SizedBox(height: 20),
                    _textField(
                      label: 'Observations',
                      hint: 'Saisir les observations...',
                      controller: _observationsController,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(
                      'Compte rendu',
                      'Résumé de la consultation',
                      Icons.description_outlined,
                    ),
                    const SizedBox(height: 20),
                    _textField(
                      label: 'Compte rendu',
                      hint: 'Rédiger le compte rendu...',
                      controller: _reportController,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(
                      'Recommandations',
                      'Conseils et recommandations pour le patient',
                      Icons.checklist_rounded,
                    ),
                    const SizedBox(height: 20),
                    _textField(
                      label: 'Recommandations',
                      hint: 'Ajouter les recommandations...',
                      controller: _recommendationsController,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GradientButton(
                label: 'Enregistrer la consultation',
                icon: Icons.save_rounded,
                onPressed: () => _save(complete: false),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _save(complete: true),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text(
                    'Terminer la consultation',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                    side: const BorderSide(color: AppColors.success),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
