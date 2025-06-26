import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/setup/item.dart';

class ItemService {
  final FirebaseFirestore _firebaseFirestore;

  ItemService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> saveItem({
    required String companyId,
    required String itemId,
    required String itemName,
    required String itemCode,
  }) async {
    final itemRef = _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('items')
        .doc(itemId);

    final itemSnapshot = await itemRef.get();

    final data = {
      'dateCreated': Timestamp.now(),
      'itemId': itemId,
      'itemName': itemName,
      'itemCode': itemCode,
    };

    if (itemSnapshot.exists) {
      await itemRef.update(data);
    } else {
      await itemRef.set(data);
    }
  }

  Future<void> deleteItem({
    required String companyId,
    required String itemId,
  }) async {
    await _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('items')
        .doc(itemId)
        .delete();
  }

  Stream<List<Item>> getItems(String companyId) {
    return _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('items')
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => Item.fromJson(e.data())).toList());
  }
}
