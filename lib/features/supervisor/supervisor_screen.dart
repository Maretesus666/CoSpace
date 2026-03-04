import 'package:flutter/material.dart';
import '../../core/widgets/custom_search_bar.dart';
import '../settings/settings_screen.dart';
import 'widgets/supervisor_grid.dart';

class SupervisorScreen extends StatelessWidget {
  const SupervisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supervisor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomSearchBar(
              onSettingsTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            const Expanded(
              child: SupervisorGrid(),
            ),
          ],
        ),
      ),
    );
  }
}