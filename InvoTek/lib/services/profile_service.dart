import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_invoice_app/model/common/profile.dart';

class ProfileService {
  final FirebaseFirestore _firebaseFirestore;

  ProfileService([FirebaseFirestore? instance])
      : _firebaseFirestore = instance ?? FirebaseFirestore.instance;

  // Ambil profile perusahaan
  Future<Profile?> getCompanyProfile(String companyId) async {
    final doc = await _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('profile') // atau .doc('profile') kalau pakai 1 document
        .doc('data') // ID dokumen fixed misal 'data'
        .get();

    if (doc.exists) {
      return Profile.fromJson(doc.data()!);
    } else {
      debugPrint('Company profile not found!');
      return null;
    }
  }

  // Simpan/update profile perusahaan
  Future<void> saveCompanyProfile({
    required String companyId,
    required Profile profile,
  }) async {
    await _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('profile')
        .doc('data')
        .set(profile.toJson(), SetOptions(merge: true));
  }
}
