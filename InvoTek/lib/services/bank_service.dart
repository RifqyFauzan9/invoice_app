import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/setup/bank.dart';

class BankService {
  final FirebaseFirestore _firebaseFirestore;

  BankService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> saveBank({
    required String companyId,
    required String bankId,
    required String bankName,
    required String accountNumber,
    required String branch,
    required String accountHolder,
  }) async {
    final bankRef = _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('banks')
        .doc(bankId);

    final bankSnapshot = await bankRef.get();

    final data = {
      'bankId': bankId,
      'dateCreated': Timestamp.now(),
      'bankName': bankName,
      'accountNumber': accountNumber,
      'branch': branch,
      'accountHolder': accountHolder,
    };

    if (bankSnapshot.exists) {
      await bankRef.update(data);
    } else {
      await bankRef.set(data);
    }
  }

  Future<void> deleteBank({
    required String companyId,
    required String bankId,
  }) async {
    await _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('banks')
        .doc(bankId)
        .delete();
  }

  Stream<List<Bank>> getBanks(String companyId) {
    return _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('banks')
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => Bank.fromJson(e.data())).toList());
  }
}
