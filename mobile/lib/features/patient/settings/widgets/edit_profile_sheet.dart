import 'package:flutter/material.dart';
import '../../../../core/session/user_session.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/gradient_button.dart';

Future<void> showEditProfileSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _EditProfileForm(),
  );
}

class _EditProfileForm extends StatefulWidget {
  const _EditProfileForm();

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name =
      TextEditingController(text: UserSession.name.value);
  late final TextEditingController _phone =
      TextEditingController(text: UserSession.phone.value);

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if ((v?.trim() ?? '').length < 3) return 'Nom complet obligatoire';
    return null;
  }

  String? _validatePhone(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    if (!RegExp(r'^\d{8}$').hasMatch(t)) return '8 chiffres requis';
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    UserSession.setName(_name.text);
    UserSession.setPhone(_phone.text);
    Navigator.pop(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Profil mis à jour')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Modifier le profil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Nom complet',
              hint: 'Mohamed Haddad',
              icon: Icons.person_outline_rounded,
              controller: _name,
              textInputAction: TextInputAction.next,
              validator: _validateName,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Téléphone',
              hint: '20 123 456',
              icon: Icons.phone_outlined,
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              validator: _validatePhone,
            ),
            const SizedBox(height: 20),
            GradientButton(
              label: 'Enregistrer',
              loading: false,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}