import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/session/user_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1)); // TODO: call the API
    if (!mounted) return;
    setState(() => _loading = false);

    UserSession.setFromEmail(_email.text); // name shown on Home

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  String? _validateEmail(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Email obligatoire';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)) {
      return 'Email invalide';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Mot de passe obligatoire';
    if (v.length < 6) return 'Minimum 6 caractères';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.brightness_6_rounded),
                    onPressed: toggleTheme,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Bienvenue 👋',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connectez-vous pour gérer vos rendez-vous',
                  style: TextStyle(color: muted, fontSize: 14),
                ),
                const SizedBox(height: 32),
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
                  label: 'Mot de passe',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  controller: _password,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Mot de passe oublié ?'),
                  ),
                ),
                const SizedBox(height: 8),
                GradientButton(
                  label: 'Se connecter',
                  loading: _loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Pas de compte ?', style: TextStyle(color: muted)),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.register),
                      child: const Text('S\'inscrire'),
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
