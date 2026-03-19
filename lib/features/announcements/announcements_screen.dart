import 'package:flutter/material.dart';
import 'models/announcement_model.dart';
import 'create_announcement_step1_screen.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final List<AnnouncementModel> _announcements = [];

  void _navigateToCreate() async {
    final result = await Navigator.push<AnnouncementModel>(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateAnnouncementStep1Screen(),
      ),
    );
    if (result != null) {
      setState(() => _announcements.insert(0, result));
    }
  }

  String _surveyTypeLabel(SurveyType? type) {
    if (type == SurveyType.multipleChoice) return 'Opción Múltiple';
    if (type == SurveyType.openAnswer) return 'Respuesta Abierta';
    return 'Sin encuesta';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anuncios'),
      ),
      body: _announcements.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.campaign_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay anuncios aún',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crea tu primer anuncio',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _announcements.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final a = _announcements[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.campaign_outlined, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              a.text,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (a.surveyType != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _surveyTypeLabel(a.surveyType),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${a.questions.length} pregunta(s)',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        '${a.createdAt.day}/${a.createdAt.month}/${a.createdAt.year}  ${a.createdAt.hour}:${a.createdAt.minute.toString().padLeft(2, '0')}',
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreate,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo anuncio'),
      ),
    );
  }
}