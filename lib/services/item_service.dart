import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/setup/item.dart';

class ItemService {
  final FirebaseFirestore _firebaseFirestore;

  ItemService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  Future<void> saveItem({
    required String uid,
    required String itemId,
    required String itemName,
    required String itemCode,
  }) async {
    final itemRefs = _firebaseFirestore
        .collection('items')
        .doc(uid)
        .collection('items')
        .doc(itemId);

    final itemSnapshots = await itemRefs.get();

    final data = {
      'dateCreated': Timestamp.now(),
      'itemId': itemId,
      'itemName': itemName,
      'itemCode': itemCode,
    };

    if (itemSnapshots.exists) {
      itemRefs.update(data);
    } else {
      itemRefs.set(data);
    }
  }

  Future<void> deleteItem({
    required String uid,
    required String itemId,
  }) async {
    await _firebaseFirestore
        .collection('items')
        .doc(uid)
        .collection('items')
        .doc(itemId)
        .delete();
  }

  Stream<List<Item>> getItem(String uid) {
    return _firebaseFirestore
        .collection('items')
        .doc(uid)
        .collection('items')
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map(
        (e) {
          final data = Item.fromJson(e.data());
          return data;
        },
      ).toList();
    });
  }
}
