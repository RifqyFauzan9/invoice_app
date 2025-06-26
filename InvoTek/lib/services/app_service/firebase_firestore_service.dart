import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseFirestoreService(
      FirebaseFirestore? firebaseFirestore,
      ) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  /// Mengambil data sekali (one-time read)
  Future<List<T>> getDocumentsOnce<T>({
    required String companyId,
    required String collectionName,
    required T Function(Map<String, dynamic> data) fromJson,
  }) async {
    final snapshot = await _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection(collectionName)
        .get();

    return snapshot.docs.map((doc) => fromJson(doc.data())).toList();
  }

  /// Auto-increment number atau formatted string
  Future<dynamic> generateAutoIncrementType({
    required String companyId,
    required String docType,
    required String prefix,
    required int padding,
    required AutoIncrementReturnType returnType,
    DateTime? date,
  }) async {
    final effectiveDate = date ?? DateTime.now();
    final counterKey =
        '${effectiveDate.month.toString().padLeft(2, '0')}${effectiveDate.year}';

    final counterRef = _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('counters')
        .doc('$docType-$counterKey');

    return _firebaseFirestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);

      int lastNumber = snapshot.exists ? snapshot.get('last') ?? 0 : 0;
      int nextNumber = lastNumber + 1;

      transaction.set(counterRef, {'last': nextNumber});

      final formattedNumber = nextNumber.toString().padLeft(padding, '0');
      final formattedString = '$prefix$formattedNumber';

      switch (returnType) {
        case AutoIncrementReturnType.number:
          return nextNumber;
        case AutoIncrementReturnType.formattedString:
          return formattedString;
      }
    });
  }
}

enum AutoIncrementReturnType {
  formattedString,
  number,
}
