
import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../data/family_data.dart';
import '../models/family_member.dart';

Future<void> showFamilyMemberForm(
  BuildContext context, {
  FamilyMember? member,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _FamilyMemberForm(member: member),
  );
}

class _FamilyMemberForm extends StatefulWidget {
  final FamilyMember? member;

  const _FamilyMemberForm({this.member});

  @override
  State<_FamilyMemberForm> createState() => _FamilyMemberFormState();
}

class _FamilyMemberFormState extends State<_FamilyMemberForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;

  static const List<String> _relationships = [
    'P\u00e8re',
    'M\u00e8re',
    'Conjoint(e)',
    'Fils',
    'Fille',
    'Fr\u00e8re',
    'S\u0153ur',
    'Autre',
  ];

  late String _relationship;
  late DateTime _dateOfBirth;

  bool get _isEditing => widget.member != null;

  @override
  void initState() {
    super.initState();

    final member = widget.member;

    _name = TextEditingController(text: member?.fullName ?? '');
    _phone = TextEditingController(text: member?.phone ?? '');
    _email = TextEditingController(text: member?.email ?? '');

    _relationship = member?.relationship ?? _relationships.first;
    _dateOfBirth = member?.dateOfBirth ?? DateTime(2000, 1, 1);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if ((value?.trim() ?? '').length < 3) {
      return 'Nom complet obligatoire (3 caract\u00e8res minimum)';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) return null;

    if (!RegExp(r'^\d{8}$').hasMatch(phone)) {
      return '8 chiffres requis';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) return null;

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Adresse e-mail invalide';
    }

    return null;
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Date de naissance',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
    );

    if (selected != null) {
      setState(() => _dateOfBirth = selected);
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final store = FamilyStore.instance;
    final existingMember = widget.member;

    if (existingMember == null) {
      final member = FamilyMember(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        fullName: _name.text.trim(),
        relationship: _relationship,
        dateOfBirth: _dateOfBirth,
        phone: _phone.text.trim(),
        email: _email.text.trim(),
      );

      store.addMember(member);
    } else {
      final updatedMember = FamilyMember(
        id: existingMember.id,
        fullName: _name.text.trim(),
        relationship: _relationship,
        dateOfBirth: _dateOfBirth,
        phone: _phone.text.trim(),
        email: _email.text.trim(),
      );

      store.updateMember(updatedMember);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditing ? 'Modifier le membre' : 'Ajouter un membre',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              AppTextField(
                label: 'Nom complet',
                hint: 'Ex. Ahmed Ben Ali',
                icon: Icons.person_outline_rounded,
                controller: _name,
                textInputAction: TextInputAction.next,
                validator: _validateName,
              ),
              const SizedBox(height: 16),

              const Text(
                'Lien familial',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
  initialValue: _relationship,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.family_restroom_rounded),
                ),
                items: _relationships.map((relationship) {
                  return DropdownMenuItem(
                    value: relationship,
                    child: Text(relationship),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _relationship = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Date de naissance',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),

              OutlinedButton.icon(
                onPressed: _selectDate,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(_formatDate(_dateOfBirth)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  alignment: Alignment.centerLeft,
                ),
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'T\u00e9l\u00e9phone (facultatif)',
                hint: '20 123 456',
                icon: Icons.phone_outlined,
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'E-mail (facultatif)',
                hint: 'exemple@email.com',
                icon: Icons.email_outlined,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: _validateEmail,
              ),
              const SizedBox(height: 24),

              GradientButton(
                label: 'Enregistrer',
                icon: Icons.check_rounded,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

