/*
// REFERENCIA RÁPIDA - FIREBASE EN COSPACE
// Este archivo contiene ejemplos de código para usar Firebase
// No es código ejecutable, solo referencia

import 'package:cospace/core/services/firebase/firebase_service_locator.dart';
import 'package:cospace/core/services/firebase/auth_service.dart';
import 'package:cospace/core/services/firebase/firestore_service.dart';
import 'package:cospace/core/services/firebase/storage_service.dart';

// ============================================================================
// 1️⃣ OBTENER SERVICIOS
// ============================================================================

final authService = FirebaseServiceLocator().auth;
final firestoreService = FirebaseServiceLocator().firestore;
final storageService = FirebaseServiceLocator().storage;

// ============================================================================
// 2️⃣ AUTENTICACIÓN
// ============================================================================

// Registrar usuario
await authService.signUp(
  email: 'usuario@example.com',
  password: 'password123',
);

// Iniciar sesión
await authService.signIn(
  email: 'usuario@example.com',
  password: 'password123',
);

// Cerrar sesión
await authService.signOut();

// Obtener usuario actual
final user = authService.currentUser;
print(user?.email);

// Recuperar contraseña
await authService.sendPasswordResetEmail('usuario@example.com');

// Actualizar perfil
await authService.updateUserProfile(
  displayName: 'Juan Pérez',
  photoURL: 'https://...',
);

// Monitorear cambios de autenticación
authService.authStateChanges.listen((user) {
  if (user != null) {
    print('Usuario autenticado: ${user.email}');
  } else {
    print('Sin autenticación');
  }
});

// ============================================================================
// 3️⃣ FIRESTORE - CREAR Y ACTUALIZAR
// ============================================================================

// Crear/Actualizar documento
await firestoreService.setDocument(
  collection: 'users',
  document: 'user123',
  data: {
    'nombre': 'Juan',
    'email': 'juan@example.com',
    'edad': 25,
    'createdAt': DateTime.now(),
  },
  merge: true, // true = merge, false = replace
);

// Agregar documento con ID automático
final docRef = await firestoreService.addDocument(
  collection: 'notifications',
  data: {
    'titulo': 'Nueva notificación',
    'descripcion': 'Esto es importante',
    'timestamp': DateTime.now(),
  },
);
print('ID del documento: ${docRef.id}');

// ============================================================================
// 4️⃣ FIRESTORE - LEER
// ============================================================================

// Obtener un documento
final doc = await firestoreService.getDocument(
  collection: 'users',
  document: 'user123',
);
final userData = doc.data() as Map<String, dynamic>;
print(userData['nombre']);

// Monitorear documento en tiempo real
firestoreService.getDocumentStream(
  collection: 'users',
  document: 'user123',
).listen((snapshot) {
  print('Usuario actualizado: ${snapshot.data()}');
});

// Obtener colección completa
final querySnapshot = await firestoreService.getCollection(
  collection: 'notifications',
);
for (var doc in querySnapshot.docs) {
  print(doc.data());
}

// Monitorear colección en tiempo real (mejor para StreamBuilder)
final stream = firestoreService.getCollectionStream(
  collection: 'notifications',
);
stream.listen((snapshot) {
  for (var doc in snapshot.docs) {
    print(doc.data());
  }
});

// ============================================================================
// 5️⃣ FIRESTORE - ACTUALIZAR
// ============================================================================

// Actualizar solo ciertos campos
await firestoreService.updateDocument(
  collection: 'users',
  document: 'user123',
  data: {
    'nombre': 'Juan Pérez',
    'updatedAt': DateTime.now(),
  },
);

// ============================================================================
// 6️⃣ FIRESTORE - ELIMINAR
// ============================================================================

// Eliminar documento
await firestoreService.deleteDocument(
  collection: 'users',
  document: 'user123',
);

// ============================================================================
// 7️⃣ CLOUD STORAGE
// ============================================================================

// Subir archivo
import 'dart:io';

final file = File('/ruta/a/archivo.jpg');
final url = await storageService.uploadFile(
  path: 'usuarios/user123/perfil.jpg',
  file: file,
);
print('Archivo subido: $url');

// Obtener URL de descarga
final downloadUrl = await storageService.getDownloadURL(
  'usuarios/user123/perfil.jpg',
);

// Descargar archivo
final bytes = await storageService.downloadFile(
  'usuarios/user123/perfil.jpg',
);

// Eliminar archivo
await storageService.deleteFile(
  'usuarios/user123/perfil.jpg',
);

// ============================================================================
// 8️⃣ EJEMPLOS EN WIDGETS - StreamBuilder
// ============================================================================

// Mostrar notificaciones en tiempo real
StreamBuilder(
  stream: FirebaseServiceLocator().firestore.getCollectionStream(
    collection: 'notifications',
  ),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    final notifications = snapshot.data?.docs ?? [];
    
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final data = notifications[index].data() as Map<String, dynamic>;
        return ListTile(
          title: Text(data['titulo']),
          subtitle: Text(data['descripcion']),
        );
      },
    );
  },
)

// ============================================================================
// 9️⃣ MANEJO DE ERRORES
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';

try {
  await authService.signIn(
    email: 'usuario@example.com',
    password: 'contra',
  );
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('Usuario no encontrado');
  } else if (e.code == 'wrong-password') {
    print('Contraseña incorrecta');
  } else {
    print('Error: ${e.message}');
  }
}

// ============================================================================
// 🔟 OPERACIONES POR LOTES (Batch)
// ============================================================================

await firestoreService.batchWrite((batch) {
  batch.set(
    FirebaseFirestore.instance.collection('users').doc('user1'),
    {'nombre': 'Juan'},
  );
  batch.set(
    FirebaseFirestore.instance.collection('users').doc('user2'),
    {'nombre': 'María'},
  );
  batch.delete(
    FirebaseFirestore.instance.collection('users').doc('user3'),
  );
});

// ============================================================================
// 📝 NOTAS IMPORTANTES
// ============================================================================

// ✅ Siempre usa FirebaseServiceLocator() para acceder a los servicios
// ✅ Los servicios manejan excepciones, déjalas propagarse o captura FirebaseAuthException
// ✅ Usa StreamBuilder para datos que cambien en tiempo real
// ✅ Para colecciones grandes, implementa paginación
// ✅ En Firestore, usa subcollections para datos relacionados
// ✅ Configura reglas de seguridad en Firebase Console
// ✅ No hagas requests innecesarios, usa listeners en lugar de queries repetidas

*/
