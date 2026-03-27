# 🚀 Guía de Configuración de Firebase

## Estructura de Firebase Implementada

Se ha implementado una arquitectura modular y escalable para Firebase con los siguientes componentes:

### 📁 Estructura de Carpetas

```
lib/
├── core/
│   ├── config/
│   │   ├── firebase_config.dart          # Inicialización de Firebase
│   │   └── firebase_options.dart         # Configuración por plataforma
│   ├── services/
│   │   └── firebase/
│   │       ├── auth_service.dart         # Autenticación
│   │       ├── firestore_service.dart    # Firestore (base de datos)
│   │       ├── storage_service.dart      # Cloud Storage
│   │       └── firebase_service_locator.dart  # Singleton locator
│   └── providers/
│       └── auth_provider.dart            # Providers de estado
└── features/                              # Tus features pueden usar Firebase
```

## 🔧 Pasos de Configuración

### 1. Crear Proyecto en Firebase Console

1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Crear un nuevo proyecto
3. Habilitar los siguientes servicios:
   - ✅ Authentication (Email/Password, Google, etc.)
   - ✅ Cloud Firestore
   - ✅ Cloud Storage

### 2. Configurar Credenciales por Plataforma

#### Para Android

1. Descargar `google-services.json` desde Firebase Console
2. Copiar archivo a `android/app/`
3. El archivo ya está configurado en `android/app/build.gradle.kts`

#### Para iOS

1. Descargar `GoogleService-Info.plist` desde Firebase Console
2. Copiar a `ios/Runner/` en Xcode
3. Asegurar que está agregado al target "Runner"

#### Para Web

1. Obtener credenciales de Web desde Firebase Console
2. Actualizar `lib/core/config/firebase_options.dart` con:
   ```dart
   static const FirebaseOptions web = FirebaseOptions(
     apiKey: 'TU_API_KEY',
     appId: 'TU_APP_ID',
     messagingSenderId: 'TU_MESSAGING_SENDER_ID',
     projectId: 'TU_PROJECT_ID',
     authDomain: 'tu-proyecto.firebaseapp.com',
     databaseURL: 'https://tu-proyecto.firebaseio.com',
     storageBucket: 'tu-proyecto.appspot.com',
     measurementId: 'TU_MEASUREMENT_ID',
   );
   ```

### 3. Ejecutar

```bash
# Obtener dependencias
flutter pub get

# Ejecutar en tu plataforma
flutter run
```

## 💻 Cómo Usar Firebase en tu Código

### Autenticación

```dart
import 'package:cospace/core/services/firebase/firebase_service_locator.dart';

final authService = FirebaseServiceLocator().auth;

// Registrarse
try {
  await authService.signUp(
    email: 'usuario@example.com',
    password: 'contraseña123',
  );
} on FirebaseAuthException catch (e) {
  print('Error: ${e.message}');
}

// Iniciar sesión
try {
  await authService.signIn(
    email: 'usuario@example.com',
    password: 'contraseña123',
  );
} on FirebaseAuthException catch (e) {
  print('Error: ${e.message}');
}

// Obtener usuario actual
final user = authService.currentUser;
print('Usuario: ${user?.email}');

// Monitorear cambios de autenticación
authService.authStateChanges.listen((user) {
  if (user != null) {
    print('Usuario autenticado: ${user.email}');
  } else {
    print('Usuario no autenticado');
  }
});

// Cerrar sesión
await authService.signOut();
```

### Firestore (Base de Datos)

```dart
import 'package:cospace/core/services/firebase/firebase_service_locator.dart';

final firestoreService = FirebaseServiceLocator().firestore;

// Crear/Actualizar documento
await firestoreService.setDocument(
  collection: 'users',
  document: 'usuario_id',
  data: {
    'nombre': 'Juan',
    'email': 'juan@example.com',
    'createdAt': DateTime.now(),
  },
);

// Obtener documento
final doc = await firestoreService.getDocument(
  collection: 'users',
  document: 'usuario_id',
);
print(doc.data());

// Monitorear documento en tiempo real
firestoreService.getDocumentStream(
  collection: 'users',
  document: 'usuario_id',
).listen((snapshot) {
  print('Documento actualizado: ${snapshot.data()}');
});

// Agregar documento nuevo
final ref = await firestoreService.addDocument(
  collection: 'messages',
  data: {
    'texto': 'Hola',
    'usuario': 'Juan',
    'timestamp': DateTime.now(),
  },
);
print('Documento creado con ID: ${ref.id}');

// Obtener colección
final docs = await firestoreService.getCollection(
  collection: 'users',
);
for (var doc in docs.docs) {
  print(doc.data());
}

// Actualizar documento
await firestoreService.updateDocument(
  collection: 'users',
  document: 'usuario_id',
  data: {'nombre': 'Juan Pérez'},
);

// Eliminar documento
await firestoreService.deleteDocument(
  collection: 'users',
  document: 'usuario_id',
);
```

### Cloud Storage

```dart
import 'package:cospace/core/services/firebase/firebase_service_locator.dart';
import 'dart:io';

final storageService = FirebaseServiceLocator().storage;

// Subir archivo
final file = File('/ruta/de/archivo.jpg');
try {
  final url = await storageService.uploadFile(
    path: 'usuarios/usuario_id/perfil.jpg',
    file: file,
  );
  print('Archivo subido: $url');
} catch (e) {
  print('Error: $e');
}

// Obtener URL de descarga
try {
  final url = await storageService.getDownloadURL(
    'usuarios/usuario_id/perfil.jpg',
  );
  print('URL: $url');
} catch (e) {
  print('Error: $e');
}

// Descargar archivo
try {
  final bytes = await storageService.downloadFile(
    'usuarios/usuario_id/perfil.jpg',
  );
  print('Tamaño: ${bytes.length} bytes');
} catch (e) {
  print('Error: $e');
}
```

## 🎯 Ejemplos en Widgets

### Mostrar datos de Firestore en tiempo real

```dart
import 'package:flutter/material.dart';
import 'package:cospace/core/services/firebase/firebase_service_locator.dart';

class NotificationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestoreService = FirebaseServiceLocator().firestore;

    return StreamBuilder(
      stream: firestoreService.getCollectionStream(
        collection: 'notifications',
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final notifications = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return ListTile(
              title: Text(notification['titulo']),
              subtitle: Text(notification['descripcion']),
            );
          },
        );
      },
    );
  }
}
```

## 🔐 Seguridad

### Reglas de Firestore (firebase_rules.txt)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Solo usuarios autenticados pueden leer su propio documento
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Todos pueden leer anuncios
    match /announcements/{document=**} {
      allow read: if true;
      allow write: if request.auth.uid != null; // Solo usuarios autenticados
    }
    
    // Todos pueden leer notificaciones públicas
    match /notifications/{document=**} {
      allow read: if true;
      allow write: if false; // Solo backend puede escribir
    }
  }
}
```

## ⚠️ Notas Importantes

- **firebase_options.dart**: Reemplaza los valores `YOUR_*` con tus credenciales reales
- NO commits tus credenciales a Git. Usa variables de entorno o archivos locales
- Los servicios están diseñados para ser inyectables y testeables
- La arquitectura permite agregar más servicios fácilmente

## 📦 Dependencias Agregadas

```yaml
firebase_core: ^3.1.0        # Core de Firebase
firebase_auth: ^5.1.0        # Autenticación
cloud_firestore: ^5.0.0      # Base de datos
firebase_storage: ^12.0.0    # Cloud Storage
provider: ^6.1.0             # State Management
```

## 🚀 Próximos Pasos

1. ✅ Configurar credenciales en `firebase_options.dart`
2. ✅ Descargar archivos de configuración (google-services.json, GoogleService-Info.plist)
3. ✅ Ejecutar `flutter pub get`
4. ✅ Empezar a usar los servicios en tus features

Ahora puedes usar Firebase en toda tu aplicación sin problemas. ¡Éxito! 🎉
