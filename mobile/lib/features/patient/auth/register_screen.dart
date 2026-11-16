import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/session/user_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../shared/widgets/gradient_button.dart';

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
  bool _showPassword = false;
  bool _showConfirm = false;

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

    UserSession.setName(_name.text);
    UserSession.setEmail(_email.text);
    UserSession.setPhone(_phone.text);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Compte créé avec succès')));

    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
  }

  String? _validateName(String? v) {
    if ((v?.trim() ?? '').length < 3) {
      return 'Nom complet obligatoire';
    }
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

    if (!RegExp(r'^\d{8}$').hasMatch(t)) {
      return '8 chiffres requis';
    }

    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Mot de passe obligatoire';

    if (v.length < 6) return 'Minimum 6 caractères';

    return null;
  }

  String? _validateConfirm(String? v) {
    if (v != _password.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  Widget _buildInput({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscure = false,
    Widget? suffix,
  }) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;
    final border = isLight ? AppColors.lightBorder : AppColors.darkBorder;
    final inputSurface = isLight ? AppColors.lightBg : AppColors.darkBg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscure,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: muted, fontSize: 13),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 21),
            suffixIcon: suffix,
            filled: true,
            fillColor: inputSurface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.danger),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;
    final surface = isLight ? AppColors.lightSurface : AppColors.darkSurface;

    return Scaffold(
      backgroundColor: isLight ? AppColors.lightBg : AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            children: [
              // Registration header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 8, 24, 35),
                decoration: const BoxDecoration(
                  gradient: AppColors.headerGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(34),
                    bottomRight: Radius.circular(34),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.16,
                            ),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'MedFlow',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Changer le thème',
                          onPressed: toggleTheme,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.16,
                            ),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.brightness_6_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Rejoignez MedFlow ✨',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Créez votre compte et prenez votre santé en main.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.86),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Registration form
              Transform.translate(
                offset: const Offset(0, -22),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: isLight ? AppColors.cardShadow : null,
                    border: isLight
                        ? null
                        : Border.all(color: AppColors.darkBorder),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Créer un compte',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Quelques informations pour commencer.',
                          style: TextStyle(color: muted, fontSize: 13),
                        ),
                        const SizedBox(height: 23),

                        _buildInput(
                          label: 'Nom complet',
                          hint: 'Votre nom et prénom',
                          icon: Icons.person_outline_rounded,
                          controller: _name,
                          validator: _validateName,
                        ),
                        const SizedBox(height: 17),

                        _buildInput(
                          label: 'Adresse e-mail',
                          hint: 'exemple@email.com',
                          icon: Icons.mail_outline_rounded,
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 17),

                        _buildInput(
                          label: 'Téléphone',
                          hint: '20 123 456',
                          icon: Icons.phone_outlined,
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          validator: _validatePhone,
                        ),
                        const SizedBox(height: 17),

                        _buildInput(
                          label: 'Mot de passe',
                          hint: 'Minimum 6 caractères',
                          icon: Icons.lock_outline_rounded,
                          controller: _password,
                          obscure: !_showPassword,
                          validator: _validatePassword,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() => _showPassword = !_showPassword);
                            },
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: muted,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 17),

                        _buildInput(
                          label: 'Confirmer le mot de passe',
                          hint: 'Saisissez à nouveau le mot de passe',
                          icon: Icons.lock_outline_rounded,
                          controller: _confirm,
                          obscure: !_showConfirm,
                          textInputAction: TextInputAction.done,
                          validator: _validateConfirm,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() => _showConfirm = !_showConfirm);
                            },
                            icon: Icon(
                              _showConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: muted,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        GradientButton(
                          label: 'Créer mon compte',
                          loading: _loading,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Déjà un compte ?',
                              style: TextStyle(color: muted, fontSize: 13),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Se connecter',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user_outlined, size: 15, color: muted),
                    const SizedBox(width: 7),
                    Text(
                      'Inscription simple et sécurisée.',
                      style: TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
