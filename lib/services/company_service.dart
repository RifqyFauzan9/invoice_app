import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/common/company.dart';

class CompanyService {
  final FirebaseFirestore _firebaseFirestore;

  CompanyService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  Future<Company?> getCompanyData(String uid) async {
    final doc = await _firebaseFirestore.collection('companies').doc(uid).get();
    if (doc.exists) {
      return Company.fromJson(doc.data()!);
    } else {
      debugPrint('Doc company does\'nt exist!');
      return null;
    }
  }

  Future<void> saveCompanyData(String uid, Company company) async {
    final docRef = _firebaseFirestore.collection('companies').doc(uid);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update(company.toJson());
    } else {
      await docRef.set(company.toJson());
    }
  }
}
