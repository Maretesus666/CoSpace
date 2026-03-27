import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear o actualizar documento
  Future<void> setDocument({
    required String collection,
    required String document,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    try {
      await _firestore.collection(collection).doc(document).set(
            data,
            SetOptions(merge: merge),
          );
    } catch (e) {
      rethrow;
    }
  }

  // Obtener documento
  Future<DocumentSnapshot> getDocument({
    required String collection,
    required String document,
  }) async {
    try {
      return await _firestore.collection(collection).doc(document).get();
    } catch (e) {
      rethrow;
    }
  }

  // Obtener stream de documento en tiempo real
  Stream<DocumentSnapshot> getDocumentStream({
    required String collection,
    required String document,
  }) {
    return _firestore.collection(collection).doc(document).snapshots();
  }

  // Obtener colección
  Future<QuerySnapshot> getCollection({
    required String collection,
    List<QueryConstraint>? constraints,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      if (constraints != null) {
        for (var constraint in constraints) {
          query = constraint.apply(query);
        }
      }

      return await query.get();
    } catch (e) {
      rethrow;
    }
  }

  // Obtener stream de colección en tiempo real
  Stream<QuerySnapshot> getCollectionStream({
    required String collection,
    List<QueryConstraint>? constraints,
  }) {
    Query query = _firestore.collection(collection);

    if (constraints != null) {
      for (var constraint in constraints) {
        query = constraint.apply(query);
      }
    }

    return query.snapshots();
  }

  // Agregar documento
  Future<DocumentReference> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      rethrow;
    }
  }

  // Actualizar documento
  Future<void> updateDocument({
    required String collection,
    required String document,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(document).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Eliminar documento
  Future<void> deleteDocument({
    required String collection,
    required String document,
  }) async {
    try {
      await _firestore.collection(collection).doc(document).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Batch write
  Future<void> batchWrite(
    Function(WriteBatch) updates,
  ) async {
    try {
      final batch = _firestore.batch();
      await updates(batch);
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }
}

abstract class QueryConstraint {
  Query apply(Query query);
}

class WhereConstraint extends QueryConstraint {
  final String field;
  final dynamic value;
  final String? isEqualTo;
  final String? isLessThan;
  final String? isLessThanOrEqualTo;
  final String? isGreaterThan;
  final String? isGreaterThanOrEqualTo;
  final String? arrayContains;
  final List<dynamic>? arrayContainsAny;
  final List<dynamic>? whereIn;

  WhereConstraint(
    this.field, {
    this.value,
    this.isEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
  });

  @override
  Query apply(Query query) {
    if (isEqualTo != null) {
      return query.where(field, isEqualTo: value);
    }
    if (isLessThan != null) {
      return query.where(field, isLessThan: value);
    }
    if (isLessThanOrEqualTo != null) {
      return query.where(field, isLessThanOrEqualTo: value);
    }
    if (isGreaterThan != null) {
      return query.where(field, isGreaterThan: value);
    }
    if (isGreaterThanOrEqualTo != null) {
      return query.where(field, isGreaterThanOrEqualTo: value);
    }
    if (arrayContains != null) {
      return query.where(field, arrayContains: value);
    }
    if (arrayContainsAny != null) {
      return query.where(field, arrayContainsAny: arrayContainsAny);
    }
    if (whereIn != null) {
      return query.where(field, whereIn: whereIn);
    }
    return query.where(field, isEqualTo: value);
  }
}

class OrderConstraint extends QueryConstraint {
  final String field;
  final bool descending;

  OrderConstraint(this.field, {this.descending = false});

  @override
  Query apply(Query query) {
    return query.orderBy(field, descending: descending);
  }
}

class LimitConstraint extends QueryConstraint {
  final int limit;

  LimitConstraint(this.limit);

  @override
  Query apply(Query query) {
    return query.limit(limit);
  }
}
