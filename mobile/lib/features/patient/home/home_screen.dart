import 'package:flutter/material.dart';
import '../../../core/session/user_session.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/next_appointment_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSearchTap;
  const HomeScreen({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          ValueListenableBuilder<String>(
            valueListenable: UserSession.name,
            builder: (_, name, __) => HomeHeader(fullName: name),
          ),
          const SizedBox(height: 20),
          HomeSearchBar(onTap: onSearchTap),
          const SizedBox(height: 20),
          const NextAppointmentCard(),
        ],
      ),
    );
  }
}