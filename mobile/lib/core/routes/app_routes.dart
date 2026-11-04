import 'package:flutter/material.dart';
import '../../features/patient/auth/login_screen.dart';
import '../../features/patient/auth/register_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen('Accueil'),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen('Page introuvable'),
        );
    }
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title : bientôt disponible')),
    );
  }
}