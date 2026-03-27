import 'auth_service.dart';
import 'firestore_service.dart';
import 'storage_service.dart';

/// Servicio centralizado para acceder a todos los servicios de Firebase
/// Implementa el patrón Singleton para garantizar una única instancia
class FirebaseServiceLocator {
  static final FirebaseServiceLocator _instance = FirebaseServiceLocator._internal();

  late final AuthService _authService;
  late final FirestoreService _firestoreService;
  late final StorageService _storageService;

  factory FirebaseServiceLocator() {
    return _instance;
  }

  FirebaseServiceLocator._internal();

  /// Inicializar todos los servicios
  void initialize() {
    _authService = AuthService();
    _firestoreService = FirestoreService();
    _storageService = StorageService();
  }

  /// Obtener servicio de autenticación
  AuthService get auth => _authService;

  /// Obtener servicio de Firestore
  FirestoreService get firestore => _firestoreService;

  /// Obtener servicio de Storage
  StorageService get storage => _storageService;
}
