import 'package:flutter/material.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preguntas"),
      ),
      body: const Center(
        child: Text(
          "Pantalla de Preguntas",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}