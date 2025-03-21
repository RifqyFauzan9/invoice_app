import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseFirestoreService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot doc = await _firebaseFirestore.collection('users').doc(uid).get();

    if (doc.exists) {
      return doc['role'];
    }
    return null;
  }

  Future<void> saveUserData(String uid, String email, String role) async {
    await _firebaseFirestore.collection('users').doc(uid).set({
      'email': email,
      'role': role,
    });
  }
}
