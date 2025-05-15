import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseFirestoreService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  Future<dynamic> generateAutoIncrementType({
    required String uid,
    required String docType,
    required String prefix,
    required int padding,
    required AutoIncrementReturnType returnType,
  }) async {
    final counterRef = _firebaseFirestore
        .collection('counters')
        .doc(uid)
        .collection('counters')
        .doc(docType);

    return _firebaseFirestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);

      int lastNumber = snapshot.exists ? snapshot.get('last') ?? 0 : 0;
      int nextNumber = lastNumber + 1;

      // Update counter
      transaction.set(counterRef, {'last': nextNumber});

      // Generate formatted string
      final formattedNumber = nextNumber.toString().padLeft(padding, '0');
      final formattedString = '$prefix $formattedNumber';

      switch (returnType) {
        case AutoIncrementReturnType.number:
          return lastNumber;
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
