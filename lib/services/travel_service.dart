import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_invoice_app/model/setup/travel.dart';

class TravelService {
  final FirebaseFirestore _firebaseFirestore;

  TravelService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  /// Travel Services
  Future<String> generateTravelIdFromFirestore(String uid) async {
    final counterRef = _firebaseFirestore
        .collection('counters')
        .doc(uid)
        .collection('counters')
        .doc('travels');

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
    required String uid,
    required String travelId,
    required String travelName,
    required String contactPerson,
    required String travelAddress,
    required String phoneNumber,
    required String emailAddress,
  }) async {
    final travelRefs = _firebaseFirestore
        .collection('travels')
        .doc(uid)
        .collection('travels')
        .doc(travelId);

    final travelSnapshot = await travelRefs.get();

    final data = {
      'dateCreated': Timestamp.now(),
      'travelId': travelId,
      'travelName': travelName,
      'contactPerson': contactPerson,
      'travelAddress': travelAddress,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
    };

    if (travelSnapshot.exists) {
      travelRefs.update(data);
    } else {
      travelRefs.set(data);
    }
  }

  Future<void> deleteTravel({
    required String uid,
    required String travelId,
  }) async {
    await _firebaseFirestore
        .collection('travels')
        .doc(uid)
        .collection('travels')
        .doc(travelId)
        .delete();
  }

  Stream<List<Travel>> getTravel(String uid) {
    return _firebaseFirestore
        .collection('travels')
        .doc(uid)
        .collection('travels')
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) {
              final data = Travel.fromJson(e.data());
              return data;
            },
          ).toList(),
        );
  }
}
