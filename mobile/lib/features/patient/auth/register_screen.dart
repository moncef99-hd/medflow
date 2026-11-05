import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../core/session/user_session.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1)); // TODO: call the API
    if (!mounted) return;
    setState(() => _loading = false);
    
    UserSession.setName(_name.text); // name shown on Home
    UserSession.setEmail(_email.text);
    UserSession.setPhone(_phone.text);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Compte créé avec succès')));
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
  }

  String? _validateName(String? v) {
    if ((v?.trim() ?? '').length < 3) return 'Nom complet obligatoire';
    return null;
  }

  String? _validateEmail(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Email obligatoire';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)) {
      return 'Email invalide';
    }
    return null;
  }

  String? _validatePhone(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Téléphone obligatoire';
    if (!RegExp(r'^\d{8}$').hasMatch(t)) return '8 chiffres requis';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Mot de passe obligatoire';
    if (v.length < 6) return 'Minimum 6 caractères';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v != _password.text) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Créer un compte',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rejoignez MedFlow et réservez en quelques clics',
                  style: TextStyle(color: muted, fontSize: 14),
                ),
                const SizedBox(height: 28),
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
                  label: 'Email',
                  hint: 'exemple@email.com',
                  icon: Icons.mail_outline_rounded,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Téléphone',
                  hint: '20 123 456',
                  icon: Icons.phone_outlined,
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: _validatePhone,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Mot de passe',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  controller: _password,
                  obscure: true,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Confirmer le mot de passe',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  controller: _confirm,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirm,
                ),
                const SizedBox(height: 28),
                GradientButton(
                  label: 'Créer mon compte',
                  loading: _loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Déjà un compte ?', style: TextStyle(color: muted)),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Se connecter'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
