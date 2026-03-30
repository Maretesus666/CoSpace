import 'package:flutter/material.dart';
import '../announcements/models/announcement.dart';
import '../announcements/services/announcement_service.dart';

class SeguimientoScreen extends StatefulWidget {
  const SeguimientoScreen({super.key});

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  final AnnouncementService _service = AnnouncementService();
  Announcement? _selectedAnnouncement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seguimiento de Anuncios"),
      ),
      body: StreamBuilder<List<Announcement>>(
        stream: _service.getAnnouncementsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final announcements = snapshot.data ?? [];

          if (announcements.isEmpty) {
            return const Center(
              child: Text('No hay anuncios aún'),
            );
          }

          // Si no hay selección, mostrar la lista
          if (_selectedAnnouncement == null) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      announcement.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(announcement.description),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      setState(() {
                        _selectedAnnouncement = announcement;
                      });
                    },
                  ),
                );
              },
            );
          }

          // Mostrar panel de seguimiento detallado
          return _buildDetailPanel(_selectedAnnouncement!);
        },
      ),
    );
  }

  Widget _buildDetailPanel(Announcement announcement) {
    // Calcular porcentajes
    int totalVistas = announcement.viewCount;
    int respuestasCorrectas = announcement.correctAnswers;
    int totalRespuestas = announcement.totalAnswers;
    int errores = totalRespuestas - respuestasCorrectas;

    double porcentajeVistas = (totalVistas > 0) ? 50.0 : 0.0;
    double porcentajeAciertos =
        (totalRespuestas > 0) ? (respuestasCorrectas / totalRespuestas) * 100 : 0.0;
    double porcentajeErrores =
        (totalRespuestas > 0) ? (errores / totalRespuestas) * 100 : 0.0;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botón para volver
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
              onPressed: () {
                setState(() {
                  _selectedAnnouncement = null;
                });
              },
            ),
            const SizedBox(height: 24),

            // Título de la sección
            Text(
              'Panel De Seguimiento',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Información del anuncio
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcement.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      announcement.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Panel de visualizaciones
            _buildStatPanel(
              title: 'Visualizaciones',
              percentage: porcentajeVistas.toInt(),
              color: Colors.amber,
            ),
            const SizedBox(height: 20),

            // Panel de aciertos
            _buildStatPanel(
              title: 'Aciertos',
              percentage: porcentajeAciertos.toInt(),
              color: Colors.green,
            ),
            const SizedBox(height: 20),

            // Panel de errores
            _buildStatPanel(
              title: 'Errores',
              percentage: porcentajeErrores.toInt(),
              color: Colors.red,
            ),
            const SizedBox(height: 40),

            // Estadísticas detalladas
            Text(
              'Estadísticas Detalladas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatisticTile(
              'Visualizaciones',
              '$totalVistas',
              Icons.visibility,
            ),
            _buildStatisticTile(
              'Respuestas Correctas',
              '$respuestasCorrectas/$totalRespuestas',
              Icons.check_circle,
            ),
            _buildStatisticTile(
              'Respuestas Incorrectas',
              '$errores/$totalRespuestas',
              Icons.cancel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPanel({
    required String title,
    required int percentage,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                height: 40,
                width: (percentage / 100) * (MediaQuery.of(context).size.width - 64),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: percentage > 50
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$percentage%',
                      style: TextStyle(
                        color:
                            percentage > 50 ? Colors.white : Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
