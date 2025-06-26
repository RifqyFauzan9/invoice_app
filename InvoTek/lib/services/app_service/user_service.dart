import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserCompanyData(String uid) async {
    final companiesSnapshot = await _firestore.collection('companies').get();

    for (final companyDoc in companiesSnapshot.docs) {
      final usersRef = companyDoc.reference.collection('users');
      final query = await usersRef.where('uid', isEqualTo: uid).limit(1).get();

      if (query.docs.isNotEmpty) {
        final userDoc = query.docs.first;
        return {
          'companyId': companyDoc.id,
          'role': userDoc['role'],
          'userId': userDoc.id,
          'userData': userDoc.data(),
        };
      }
    }

    return null; // Tidak ditemukan
  }
}
