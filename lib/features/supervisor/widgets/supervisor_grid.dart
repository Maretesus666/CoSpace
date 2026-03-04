import 'package:flutter/material.dart';
import 'supervisor_card.dart';
import '../../chat/chat_screen.dart';
import '../../announcements/announcements_screen.dart';
import '../../questions/questions_screen.dart';

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
          icon: Icons.chat_bubble_outline,
          title: "Chat",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatScreen()),
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
              MaterialPageRoute(builder: (_) => const QuestionsScreen()),
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