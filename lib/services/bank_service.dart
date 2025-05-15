import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/setup/bank.dart';

class BankService {
  final FirebaseFirestore _firebaseFirestore;

  BankService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  Future<void> saveBank({
    required String uid,
    required String bankId,
    required String bankName,
    required int accountNumber,
    required String branch,
    required String accountHolder,
  }) async {
    final bankRefs = _firebaseFirestore
        .collection('banks')
        .doc(uid)
        .collection('banks')
        .doc(bankId);

    final bankSnapshot = await bankRefs.get();

    final data = {
      'bankId': bankId,
      'dateCreated': Timestamp.now(),
      'bankName': bankName,
      'accountNumber': accountNumber,
      'branch': branch,
      'accountHolder': accountHolder,
    };

    if (bankSnapshot.exists) {
      bankRefs.update(data);
    } else {
      bankRefs.set(data);
    }
  }

  Future<void> deleteBank({
    required String bankId,
    required String uid,
  }) async {
    await _firebaseFirestore
        .collection('banks')
        .doc(uid)
        .collection('banks')
        .doc(bankId)
        .delete();
  }

  Stream<List<Bank>> getBank(String uid) {
    return _firebaseFirestore
        .collection('banks')
        .doc(uid)
        .collection('banks')
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map(
        (e) {
          final data = Bank.fromJson(e.data());
          return data;
        },
      ).toList();
    });
  }
}
