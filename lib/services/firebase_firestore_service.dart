import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_invoice_app/model/setup/airline.dart';
import 'package:my_invoice_app/model/setup/bank.dart';
import 'package:my_invoice_app/model/setup/item.dart';
import 'package:my_invoice_app/model/setup/note.dart';

import '../model/setup/travel.dart';
import '../model/transaction/invoice.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseFirestoreService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  /// Profile Services
  Future<Map<String, dynamic>?> getCompanyData(String uid) async {
    final doc = await _firebaseFirestore.collection('companies').doc(uid).get();
    if (doc.exists) {
      return doc.data();
    } else {
      debugPrint('Doc does\'nt exist!');
      return null;
    }
  }

  Future<void> saveCompanyData({
    required String uid,
    required String companyName,
    required String companyAddress,
    required String companyEmail,
    required String companyWebsite,
    required int companyPhone,
    required String companyPic,
    Timestamp? timeStamp,
  }) async {
    timeStamp ??= Timestamp.now();

    await _firebaseFirestore.collection('companies').doc(uid).set({
      'companyName': companyName,
      'companyAddress': companyAddress,
      'companyEmail': companyEmail,
      'companyWebsite': companyWebsite,
      'companyPhone': companyPhone,
      'companyPic': companyPic,
      'dateCreated': timeStamp,
    });
  }

  /// Travel Services
  Future<String> generateTravelIdFromFirestore() async {
    final counterRef = _firebaseFirestore.collection('counters').doc('travels');

    return _firebaseFirestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);

      int lastNumber = snapshot.exists ? snapshot.get('last') ?? 0 : 0;
      int nextNumber = lastNumber + 1;

      // Update counter
      transaction.set(counterRef, {'last': nextNumber});

      // Generate ID
      return 'TRV${nextNumber.toString().padLeft(3, '0')}';
    });
  }

  Future<void> saveTravel({
    required String travelName,
    required String contactPerson,
    required String travelAddress,
    required int phoneNumber,
    required String emailAddress,
  }) async {
    String id = await generateTravelIdFromFirestore();
    await _firebaseFirestore.collection('travels').add({
      'travelId': id,
      'travelName': travelName,
      'contactPerson': contactPerson,
      'travelAddress': travelAddress,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
    });
  }

  Stream<List<Travel>> getTravel() {
    return _firebaseFirestore.collection('travels').snapshots().map((event) {
      return event.docs.map(
        (e) {
          final data = Travel.fromJson(e.data());
          return data;
        },
      ).toList();
    });
  }

  /// Bank Services
  Future<void> saveBank({
    required String bankName,
    required int accountNumber,
    required String branch,
  }) async {
    await _firebaseFirestore.collection('banks').add({
      'bankName': bankName,
      'accountNumber': accountNumber,
      'branch': branch,
    });
  }

  Stream<List<Bank>> getBank() {
    return _firebaseFirestore.collection('banks').snapshots().map((event) {
      return event.docs.map(
        (e) {
          final data = Bank.fromJson(e.data());
          return data;
        },
      ).toList();
    });
  }

  /// Airline Services
  Future<void> saveAirline({
    required String airlineName,
    required String airlineCode,
  }) async {
    await _firebaseFirestore.collection('airlines').add({
      'airline': airlineName,
      'code': airlineCode,
    });
  }

  Stream<List<Airline>> getAirline() {
    return _firebaseFirestore.collection('airlines').snapshots().map((event) {
      return event.docs.map(
        (e) {
          final data = Airline.fromJson(e.data());
          return data;
        },
      ).toList();
    });
  }

  /// Item Services
  Future<void> saveItem({
    required String itemName,
    required String itemCode,
  }) async {
    await _firebaseFirestore.collection('items').add({
      'itemName': itemName,
      'itemCode': itemCode,
    });
  }

  Stream<List<Item>> getItem() {
    return _firebaseFirestore.collection('items').snapshots().map((event) {
      return event.docs.map(
        (e) {
          final data = Item.fromJson(e.data());
          return data;
        },
      ).toList();
    });
  }

  /// Note Services
  Future<String> generateNoteTypeFromFirestore() async {
    final counterRef = _firebaseFirestore.collection('counters').doc('notes');

    return _firebaseFirestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);

      int lastNumber = snapshot.exists ? snapshot.get('last') ?? 0 : 0;
      int nextNumber = lastNumber + 1;

      // Update counter
      transaction.set(counterRef, {'last': nextNumber});

      // Generate Note Type (e.g., "Type 001")
      return 'Type ${nextNumber.toString()}';
    });
  }

  Future<void> saveNote({
    required String content,
  }) async {
    final noteType = await generateNoteTypeFromFirestore();
    await _firebaseFirestore.collection('notes').add({
      'type': noteType,
      'note': content,
    });
  }

  Stream<List<Note>> getNote() {
    return _firebaseFirestore.collection('notes').snapshots().map((event) {
      return event.docs.map(
        (e) {
          final data = Note.fromJson(e.data());
          return data;
        },
      ).toList();
    });
  }

  Future<void> saveInvoice({required Invoice invoice}) async {
    await FirebaseFirestore.instance
        .collection('invoices')
        .add(invoice.toJson());
  }
}
