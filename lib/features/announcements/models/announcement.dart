import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String createdBy;
  final DateTime createdAt;
  final String category;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.createdBy,
    required this.createdAt,
    this.category = 'General',
  });

  /// Convertir modelo a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'category': category,
    };
  }

  /// Crear modelo desde Firestore
  factory Announcement.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return Announcement(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      createdBy: data['createdBy'] ?? 'Unknown',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      category: data['category'] ?? 'General',
    );
  }

  /// Crear modelo desde Map (para FlutterFlow o similares)
  factory Announcement.fromMap(Map<String, dynamic> data, String id) {
    return Announcement(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      createdBy: data['createdBy'] ?? 'Unknown',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      category: data['category'] ?? 'General',
    );
  }
}
