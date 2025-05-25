import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseFirestoreService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  Future<List<T>> getDocumentsOnce<T>({
    required String collectionPath,
    required T Function(Map<String, dynamic> data) fromJson,
    required String uid,
  }) async {
    final snapshot = await _firebaseFirestore
        .collection(collectionPath)
        .doc(uid)
        .collection(collectionPath)
        .get();
    return snapshot.docs.map((doc) => fromJson(doc.data())).toList();
  }

  Future<dynamic> generateAutoIncrementType({
    required String uid,
    required String docType,
    required String prefix,
    required int padding,
    required AutoIncrementReturnType returnType,
    DateTime? date,
  }) async {
    final effectiveDate = date ?? DateTime.now();
    final counterKey = '${effectiveDate.month.toString().padLeft(2, '0')}${effectiveDate.year}';

    final counterRef = _firebaseFirestore
        .collection('counters')
        .doc(uid)
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
