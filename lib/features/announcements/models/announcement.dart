import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String createdBy;
  final DateTime createdAt;
  final String category;
  final int viewCount;
  final List<String> viewers; // IDs de usuarios que vieron
  final int correctAnswers;
  final int totalAnswers;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.createdBy,
    required this.createdAt,
    this.category = 'General',
    this.viewCount = 0,
    this.viewers = const [],
    this.correctAnswers = 0,
    this.totalAnswers = 0,
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
      'viewCount': viewCount,
      'viewers': viewers,
      'correctAnswers': correctAnswers,
      'totalAnswers': totalAnswers,
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
      viewCount: data['viewCount'] ?? 0,
      category: data['category'] ?? 'General',
      viewers: List<String>.from(data['viewers'] ?? []),
      correctAnswers: data['correctAnswers'] ?? 0,
      totalAnswers: data['totalAnswers'] ?? 0,
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
      viewCount: data['viewCount'] ?? 0,
      category: data['category'] ?? 'General',
      viewers: List<String>.from(data['viewers'] ?? []),
      correctAnswers: data['correctAnswers'] ?? 0,
      totalAnswers: data['totalAnswers'] ?? 0,
    );
  }
}
