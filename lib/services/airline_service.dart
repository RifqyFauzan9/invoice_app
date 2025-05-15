import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/setup/airline.dart';

class AirlineService {
  final FirebaseFirestore _firebaseFirestore;

  AirlineService(FirebaseFirestore? firebaseFirestore)
      : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  Future<void> saveAirline({
    required String uid,
    required String airlineId,
    required String airlineName,
    required String airlineCode,
  }) async {
    final airlineRefs = _firebaseFirestore
        .collection('airlines')
        .doc(uid)
        .collection('airlines')
        .doc(airlineId);

    final airlineSnapshot = await airlineRefs.get();

    final data = {
      'dateCreated': Timestamp.now(),
      'airlineId': airlineId,
      'airlineName': airlineName,
      'airlineCode': airlineCode,
    };

    if (airlineSnapshot.exists) {
      airlineRefs.update(data);
    } else {
      airlineRefs.set(data);
    }
  }

  Future<void> deleteAirline({
    required String uid,
    required String airlineId,
  }) async {
    await _firebaseFirestore
        .collection('airlines')
        .doc(uid)
        .collection('airlines')
        .doc(airlineId)
        .delete();
  }

  Stream<List<Airline>> getAirline(String uid) {
    return _firebaseFirestore
        .collection('airlines')
        .doc(uid)
        .collection('airlines').orderBy('dateCreated', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map(
        (e) {
          final data = Airline.fromJson(e.data());
          return data;
        },
      ).toList();
    });
  }
}
