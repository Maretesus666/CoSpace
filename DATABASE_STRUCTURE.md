# 📊 Estructura de Base de Datos Firestore - CoSpace

## Estructura General

```
cospace-58fec (Proyecto)
├── announcements/           (Colección - Anuncios)
├── notifications/           (Colección - Notificaciones)
├── users/                   (Colección - Usuarios)
└── messages/                (Colección - Mensajes)
```

---

## 📢 Colección: `announcements`

**Propósito**: Almacenar todos los anuncios creados por supervisores.

### Estructura del Documento

```json
{
  "id": "auto-generated",                    // ID de Firestore
  "title": "Nuevo comunicado importante",    // Título del anuncio
  "description": "Contenido del anuncio...", // Descripción completa
  "imageUrl": "https://..../imagen.jpg",    // URL de imagen (opcional)
  "category": "Urgente",                     // Categoría (General, Urgente, Importante)
  "createdBy": "Supervisor",                 // Usuario que creó el anuncio
  "createdAt": 2024-03-25T10:30:00Z,       // Timestamp de creación
}
```

### Ejemplo de Documento

```
announcements/
  ├── 001/
  │   ├── title: "Cambio de horario de clases"
  │   ├── description: "Las clases de matemática..."
  │   ├── imageUrl: null
  │   ├── category: "General"
  │   ├── createdBy: "supervisor_001"
  │   └── createdAt: 2024-03-25T08:00:00Z
  │
  ├── 002/
  │   ├── title: "¡URGENTE! Evacuar el edificio"
  │   ├── description: "Se reportó una fuga de gas..."
  │   ├── imageUrl: "https://..."
  │   ├── category: "Urgente"
  │   ├── createdBy: "supervisor_002"
  │   └── createdAt: 2024-03-25T14:30:00Z
```

### Índices Recomendados

- `createdAt (descendente)` - Para ordenar por fecha más reciente
- `category + createdAt` - Para filtrar por categoría y fecha

---

## 🔔 Colección: `notifications`

**Propósito**: Notificaciones generales (alertas, actualizaciones, etc).

### Estructura del Documento

```json
{
  "id": "auto-generated",
  "title": "Nueva notificación",
  "description": "Contenido de la notificación",
  "type": "announcement",              // Tipo: "announcement", "message", "alert"
  "announcementId": "001",             // Referencia al anuncio (si aplica)
  "read": false,                       // Si fue leída
  "createdAt": 2024-03-25T10:30:00Z,
}
```

### En CoSpace Actual

**Las notificaciones ahora muestran anuncios en tiempo real**. 
- No se duplican datos
- Se leen directamente de la colección `announcements`
- Filtrado opcional por categoría: "General", "Urgente", "Importante"

---

## 👥 Colección: `users`

**Propósito**: Almacenar datos de usuarios (supervisores, estudiantes, etc).

### Estructura del Documento

```json
{
  "id": "user_id_firebase",
  "email": "usuario@example.com",
  "displayName": "Juan Pérez",
  "photoURL": "https://...",
  "role": "supervisor",                // "supervisor", "student", "admin"
  "createdAt": 2024-03-01T09:00:00Z,
}
```

---

## 💬 Colección: `messages`

**Propósito**: Almacenar mensajes del chat (futuro).

### Estructura del Documento

```json
{
  "id": "auto-generated",
  "conversationId": "conv_001",
  "senderId": "user_123",
  "text": "Contenido del mensaje",
  "imageUrl": null,
  "timestamp": 2024-03-25T15:45:00Z,
  "read": false,
}
```

---

## 🔐 Reglas de Seguridad Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Anuncios - Lectura pública, escritura solo supervisores
    match /announcements/{document=**} {
      allow read: if true;
      allow create, update, delete: if request.auth != null;
    }
    
    // Usuarios - Lectura propia, escritura propia
    match /users/{userId} {
      allow read: if request.auth.uid == userId;
      allow write: if request.auth.uid == userId;
    }
    
    // Mensajes - Acceso a propios mensajes
    match /messages/{messageId} {
      allow read: if request.auth.uid == resource.data.senderId;
      allow create: if request.auth != null;
    }
  }
}
```

---

## 📤 Cloud Storage - Estructura de Carpetas

```
cospace-58fec.firebasestorage.app
├── announcements/
│   ├── user_123/
│   │   └── images/
│   │       ├── 1711353000000.jpg
│   │       └── 1711353001000.jpg
├── users/
│   ├── user_123/
│   │   └── profile.jpg
└── messages/
    └── user_123/
        └── 1711353500000.jpg
```

---

## 🔄 Flujo de Datos: Crear Anuncio

```
1. Usuario crea anuncio en AnnouncementsScreen
   ↓
2. AnnouncementService.createAnnouncement()
   ├─ Subir imagen a Cloud Storage
   │  (announcements/{userId}/images/{timestamp}.jpg)
   │  ↓ Obtener URL de imagen
   │
   └─ Guardar en Firestore (collection: announcements)
      ├─ title
      ├─ description
      ├─ imageUrl (si existe)
      ├─ category
      ├─ createdBy
      └─ createdAt
   ↓
3. NotificationsScreen recibe actualización via Stream
   ↓
4. UI actualiza mostrando el nuevo anuncio
```

---

## 📊 Flujo de Datos: Ver Notificaciones

```
NotificationsScreen
   ↓
AnnouncementService.getAnnouncementsStream()
   ↓
Firestore query: announcements 
  → orderBy('createdAt', descending: true)
   ↓
Stream<List<Announcement>>
   ↓
StreamBuilder actualiza UI en tiempo real
```

---

## 💡 Ventajas de esta Estructura

✅ **Separación de responsabilidades**
- Anuncios en su propia colección
- Notificaciones pueden referenciar o duplicar datos

✅ **Escalabilidad**
- Fácil agregar más tipos de notificaciones
- Storage para archivos grandes

✅ **Tiempo real**
- StreamBuilder recibe actualizaciones automáticamente
- Sin necesidad de polling

✅ **Seguridad**
- Reglas claras por rol y usuario
- Protección de datos privados

---

## 🚀 Operaciones Comunes

### Crear Anuncio

```dart
final service = AnnouncementService();
final announcement = await service.createAnnouncement(
  title: "Nuevo anuncio",
  description: "Contenido...",
  createdBy: userId,
  imageFile: null,
  category: "General",
);
```

### Obtener Anuncios (Una sola vez)

```dart
final announcements = await service.getAnnouncements();
// Retorna: List<Announcement>
```

### Monitorear Anuncios en Tiempo Real

```dart
service.getAnnouncementsStream()
  .listen((announcements) {
    print('Anuncios actualizados: ${announcements.length}');
  });
```

### Obtener un Anuncio por ID

```dart
final announcement = await service.getAnnouncementById("001");
```

### Actualizar Anuncio

```dart
await service.updateAnnouncement(
  "001",
  title: "Nuevo título",
  description: "Nueva descripción",
);
```

### Eliminar Anuncio

```dart
await service.deleteAnnouncement("001");
```

---

## 📈 Límites y Consideraciones

| Aspecto | Límite | Impacto |
|---------|--------|--------|
| Tamaño de documento | 1 MB | Máximo para un anuncio |
| Tamaño de imagen | 32 MB | Por archivo en Storage |
| Reads por día | Plan Spark: Infinito | Free tier suficiente para desarrollo |
| Writes por día | Plan Spark: 20K gratis | Suficiente para la mayoría de casos |
| Queries simultáneas | Ilimitado | Sin problema |

---

## 🔗 Próximos Pasos

1. ✅ Crear anuncios con imágenes
2. ✅ Ver anuncios en notificaciones (EN TIEMPO REAL)
3. ⬜ Agregar filtros por categoría
4. ⬜ Implementar búsqueda
5. ⬜ Agregar likes/reacciones
6. ⬜ Implementar compartir anuncios

