import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/announcement.dart';

class AnnouncementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String _collection = 'announcements';

  /// Crear anuncio con imagen (opcional)
  Future<Announcement> createAnnouncement({
    required String title,
    required String description,
    required String createdBy,
    File? imageFile,
    String category = 'General',
  }) async {
    try {
      String? imageUrl;

      // Subir imagen si existe
      if (imageFile != null) {
        imageUrl = await _uploadAnnouncementImage(
          imageFile,
          createdBy,
        );
      }

      final announcement = Announcement(
        id: '', // Firestore lo asignará
        title: title,
        description: description,
        imageUrl: imageUrl,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        category: category,
      );

      // Guardar en Firestore
      final docRef = await _firestore.collection(_collection).add(
            announcement.toJson(),
          );

      // Retornar con ID asignado
      return Announcement(
        id: docRef.id,
        title: announcement.title,
        description: announcement.description,
        imageUrl: announcement.imageUrl,
        createdBy: announcement.createdBy,
        createdAt: announcement.createdAt,
        category: announcement.category,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Obtener todos los anuncios
  Future<List<Announcement>> getAnnouncements() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Announcement.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Obtener anuncios en tiempo real (stream)
  Stream<List<Announcement>> getAnnouncementsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Announcement.fromFirestore(doc))
          .toList();
    });
  }

  /// Obtener anuncio por ID
  Future<Announcement?> getAnnouncementById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return Announcement.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Actualizar anuncio
  Future<void> updateAnnouncement(
    String id, {
    String? title,
    String? description,
    String? category,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (category != null) data['category'] = category;

      await _firestore.collection(_collection).doc(id).update(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Eliminar anuncio
  Future<void> deleteAnnouncement(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Subir imagen del anuncio
  Future<String> _uploadAnnouncementImage(File file, String userId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = 'announcements/$userId/images/$timestamp.jpg';

      final ref = _storage.ref().child(path);
      await ref.putFile(file);

      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  /// Eliminar imagen del anuncio
  Future<void> deleteAnnouncementImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Incrementar contador de vistas para un usuario específico (solo una vez por usuario)
  Future<void> incrementViewCount(String announcementId, String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(announcementId).get();
      final viewers = List<String>.from(doc['viewers'] ?? []);
      
      // Solo agregar si el usuario no ha visto antes
      if (!viewers.contains(userId)) {
        viewers.add(userId);
        await _firestore.collection(_collection).doc(announcementId).update({
          'viewers': viewers,
          'viewCount': viewers.length,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Registrar respuesta correcta a una pregunta
  Future<void> recordCorrectAnswer(String announcementId) async {
    try {
      await _firestore.collection(_collection).doc(announcementId).update({
        'correctAnswers': FieldValue.increment(1),
        'totalAnswers': FieldValue.increment(1),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Registrar respuesta incorrecta a una pregunta
  Future<void> recordIncorrectAnswer(String announcementId) async {
    try {
      await _firestore.collection(_collection).doc(announcementId).update({
        'totalAnswers': FieldValue.increment(1),
      });
    } catch (e) {
      rethrow;
    }
  }
}
