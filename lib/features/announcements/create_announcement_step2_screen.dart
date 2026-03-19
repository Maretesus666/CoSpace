import 'package:flutter/material.dart';
import 'models/announcement_model.dart';

class CreateAnnouncementStep2Screen extends StatefulWidget {
  final String announcementText;

  const CreateAnnouncementStep2Screen({
    super.key,
    required this.announcementText,
  });

  @override
  State<CreateAnnouncementStep2Screen> createState() =>
      _CreateAnnouncementStep2ScreenState();
}

class _CreateAnnouncementStep2ScreenState
    extends State<CreateAnnouncementStep2Screen> {
  SurveyType? _selectedType;

  // Controllers para las 3 preguntas
  final List<TextEditingController> _questionControllers = List.generate(
    3,
    (_) => TextEditingController(),
  );

  // Controllers para opciones A, B, C de cada pregunta (3x3)
  final List<List<TextEditingController>> _optionControllers = List.generate(
    3,
    (_) => List.generate(3, (_) => TextEditingController()),
  );

  @override
  void dispose() {
    for (final c in _questionControllers) {
      c.dispose();
    }
    for (final row in _optionControllers) {
      for (final c in row) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _onEnviar() {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona el tipo de encuesta'),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    final questions = <QuestionModel>[];
    for (int i = 0; i < 3; i++) {
      final q = _questionControllers[i].text.trim();
      if (q.isEmpty) continue;

      List<String> opts = [];
      if (_selectedType == SurveyType.multipleChoice) {
        opts = _optionControllers[i]
            .map((c) => c.text.trim())
            .where((o) => o.isNotEmpty)
            .toList();
      }
      questions.add(QuestionModel(question: q, options: opts));
    }

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe al menos una pregunta'),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    final announcement = AnnouncementModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: widget.announcementText,
      surveyType: _selectedType,
      questions: questions,
      createdAt: DateTime.now(),
    );

    // Volver hasta AnnouncementsScreen pasando el resultado
    Navigator.of(context).popUntil((route) => route.isFirst == false);
    Navigator.of(context).pop(announcement);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor Panel Anuncio (2)'),
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
            // ── Tipo de encuesta ───────────────────────────────
            const Text(
              'Tipo de encuesta',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _SurveyTypeButton(
              label: 'Opcion Multiple',
              selected: _selectedType == SurveyType.multipleChoice,
              onTap: () => setState(
                  () => _selectedType = SurveyType.multipleChoice),
            ),
            _SurveyTypeButton(
              label: 'Respuesta Abierta',
              selected: _selectedType == SurveyType.openAnswer,
              onTap: () =>
                  setState(() => _selectedType = SurveyType.openAnswer),
            ),

            const SizedBox(height: 28),

            // ── Encuesta: preguntas ────────────────────────────
            const Text(
              'Encuesta',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                children: List.generate(3, (i) {
                  return Column(
                    children: [
                      if (i > 0)
                        const Divider(height: 1, color: Colors.black),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              '${i + 1})',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _questionControllers[i],
                                decoration: const InputDecoration(
                                  hintText: 'Pregunta...',
                                  border: InputBorder.none,
                                  filled: false,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                ),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),

            // ── Opciones (solo Opción Múltiple) ───────────────
            if (_selectedType == SurveyType.multipleChoice) ...[
              const SizedBox(height: 20),
              const Text(
                'Opciones',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: List.generate(3, (i) {
                    return Column(
                      children: [
                        if (i > 0)
                          const Divider(height: 1, color: Colors.black),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              Text(
                                '${i + 1})',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Row(
                                  children: ['A', 'B', 'C']
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final idx = entry.key;
                                    final label = entry.value;
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 6),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              label,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            TextField(
                                              controller:
                                                  _optionControllers[i]
                                                      [idx],
                                              decoration:
                                                  const InputDecoration(
                                                hintText: '...',
                                                border: InputBorder.none,
                                                filled: false,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 4),
                                                isDense: true,
                                              ),
                                              style: const TextStyle(
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],

            const SizedBox(height: 28),

            // ── Botón Enviar ───────────────────────────────────
            OutlinedButton(
              onPressed: _onEnviar,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Enviar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Widget reutilizable para el selector de tipo ──────────────
class _SurveyTypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SurveyTypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: selected ? Colors.white : Colors.black,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}