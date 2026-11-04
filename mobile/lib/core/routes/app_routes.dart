import 'package:flutter/material.dart';

import '../../features/patient/auth/login_screen.dart';
import '../../features/patient/auth/register_screen.dart';
import '../../features/patient/patient_shell.dart';
import '../../features/patient/doctor_profile/models/doctor.dart';
import '../../features/patient/doctor_profile/screens/doctor_profile_screen.dart';
import '../../features/patient/appointments/screens/booking_screen.dart';
import '../../features/patient/appointments/screens/appointments_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const doctorProfile = '/doctor-profile';
  static const booking = '/booking';
  static const appointments = '/appointments';

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
          builder: (_) => const PatientShell(),
          settings: settings,
        );

      case doctorProfile:
        final argument = settings.arguments;

        if (argument is! Doctor) {
          return MaterialPageRoute(
            builder: (_) =>
                const _PlaceholderScreen('Profil médecin indisponible'),
          );
        }

        return MaterialPageRoute(
          builder: (context) => DoctorProfileScreen(
            doctor: argument,
            onBookAppointment: () {
              Navigator.pushNamed(context, booking, arguments: argument);
            },
          ),
          settings: settings,
        );

      case booking:
        final argument = settings.arguments;

        if (argument is! Doctor) {
          return MaterialPageRoute(
            builder: (_) =>
                const _PlaceholderScreen('Réservation indisponible'),
          );
        }

        return MaterialPageRoute(
          builder: (_) => BookingScreen(doctor: argument),
          settings: settings,
        );

      case appointments:
        return MaterialPageRoute(
          builder: (_) => const AppointmentsScreen(),
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
