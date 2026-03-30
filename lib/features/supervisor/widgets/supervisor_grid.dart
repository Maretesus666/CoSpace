import 'package:flutter/material.dart';
import 'supervisor_card.dart';
import '../../notifications/notifications_screen.dart';
import '../../announcements/announcements_screen.dart';
import '../../seguimiento/seguimiento_screen.dart';

class SupervisorGrid extends StatelessWidget {
  const SupervisorGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.5,
      children: [
        SupervisorCard(
          icon: Icons.notifications_outlined,
          title: "Notificaciones",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationsScreen()),
            );
          },
        ),
        SupervisorCard(
          icon: Icons.campaign_outlined,
          title: "Anuncios",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
            );
          },
        ),
        SupervisorCard(
          icon: Icons.help_outline,
          title: "Preguntas",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SeguimientoScreen()),
            );
          },
        ),
        SupervisorCard(
          icon: Icons.newspaper,
          title: "Noticias",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
            );
          },
        ),
      ],
    );
  }
}