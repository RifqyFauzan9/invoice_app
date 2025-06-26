import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/setup/airline.dart';

class AirlineService {
  final FirebaseFirestore _firebaseFirestore;

  AirlineService(FirebaseFirestore? firebaseFirestore)
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> saveAirline({
    required String companyId,
    required String airlineId,
    required String airlineName,
    required String airlineCode,
  }) async {
    final airlineRef = _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('airlines')
        .doc(airlineId);

    final airlineSnapshot = await airlineRef.get();

    final data = {
      'dateCreated': Timestamp.now(),
      'airlineId': airlineId,
      'airlineName': airlineName,
      'airlineCode': airlineCode,
    };

    if (airlineSnapshot.exists) {
      await airlineRef.update(data);
    } else {
      await airlineRef.set(data);
    }
  }

  Future<void> deleteAirline({
    required String companyId,
    required String airlineId,
  }) async {
    await _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('airlines')
        .doc(airlineId)
        .delete();
  }

  Stream<List<Airline>> getAirlines(String companyId) {
    return _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('airlines')
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Airline.fromJson(doc.data())).toList());
  }
}
