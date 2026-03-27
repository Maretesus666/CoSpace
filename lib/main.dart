import 'package:flutter/material.dart';
import 'features/supervisor/supervisor_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/config/firebase_config.dart';
import 'core/services/firebase/firebase_service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await FirebaseConfig.initialize();
  
  // Inicializar servicio locator de Firebase
  FirebaseServiceLocator().initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoSpace',
      theme: AppTheme.lightTheme,
      home: const SupervisorScreen(),
    );
  }
}