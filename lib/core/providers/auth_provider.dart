import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase/firebase_service_locator.dart';
import '../services/firebase/auth_service.dart';

/// Obtener servicio de autenticación
AuthService getAuthService() => FirebaseServiceLocator().auth;

/// Stream para monitorear cambios en el estado de autenticación
Stream<User?> get authStateChanges => getAuthService().authStateChanges;

/// Obtener usuario actual
User? get currentUser => getAuthService().currentUser;

/// Verificar si el usuario está autenticado
bool get isAuthenticated => currentUser != null;
