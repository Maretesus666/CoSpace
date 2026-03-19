import 'package:flutter/material.dart';
import 'create_announcement_step2_screen.dart';

class CreateAnnouncementStep1Screen extends StatefulWidget {
  const CreateAnnouncementStep1Screen({super.key});

  @override
  State<CreateAnnouncementStep1Screen> createState() =>
      _CreateAnnouncementStep1ScreenState();
}

class _CreateAnnouncementStep1ScreenState
    extends State<CreateAnnouncementStep1Screen> {
  final TextEditingController _textController = TextEditingController();
  bool _hasMedia = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onSiguientePaso() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor escribe el texto del anuncio'),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateAnnouncementStep2Screen(
          announcementText: _textController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor Panel Anuncio (1)'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Texto del anuncio ──────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _textController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Haz tu proximo anuncio...',
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.black),

                  // ── Área de media ──────────────────────────
                  GestureDetector(
                    onTap: () {
                      // Simulación: marcar que se añadió media
                      setState(() => _hasMedia = !_hasMedia);
                    },
                    child: Container(
                      height: 140,
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: _hasMedia
                            ? Colors.grey[200]
                            : Colors.white,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_hasMedia)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.image, size: 48, color: Colors.grey),
                                SizedBox(height: 6),
                                Text('Media añadida',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          else
                            const Icon(Icons.add, size: 48),
                        ],
                      ),
                    ),
                  ),

                  // ── Tooltip "Añade Imagenes y videos" ─────
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, bottom: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Añade Imagenes\ny videos',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Botón Siguiente paso ───────────────────────────
            ElevatedButton(
              onPressed: _onSiguientePaso,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Siguiente paso',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}