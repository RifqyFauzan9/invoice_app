import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_invoice_app/model/setup/travel.dart';

class TravelService {
  final FirebaseFirestore _firebaseFirestore;

  TravelService(FirebaseFirestore? firebaseFirestore)
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<String> generateTravelIdFromFirestore(String companyId) async {
    final counterRef = _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('counters')
        .doc('travels');

    return _firebaseFirestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);
      int lastNumber = snapshot.exists ? snapshot.get('last') ?? 0 : 0;
      int nextNumber = lastNumber + 1;

      transaction.set(counterRef, {'last': nextNumber});
      return 'TRV${nextNumber.toString().padLeft(3, '0')}';
    });
  }

  Future<void> saveTravel({
    required String companyId,
    required String travelId,
    required String travelName,
    required String contactPerson,
    required String travelAddress,
    required String phoneNumber,
    required String emailAddress,
  }) async {
    final travelRef = _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('travels')
        .doc(travelId);

    final data = {
      'dateCreated': Timestamp.now(),
      'travelId': travelId,
      'travelName': travelName,
      'contactPerson': contactPerson,
      'travelAddress': travelAddress,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
    };

    final snapshot = await travelRef.get();
    if (snapshot.exists) {
      await travelRef.update(data);
    } else {
      await travelRef.set(data);
    }
  }

  Future<void> deleteTravel({
    required String companyId,
    required String travelId,
  }) async {
    await _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('travels')
        .doc(travelId)
        .delete();
  }

  Stream<List<Travel>> getTravel(String companyId) {
    return _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('travels')
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Travel.fromJson(e.data())).toList();
    });
  }
}
