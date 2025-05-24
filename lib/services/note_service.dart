import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_invoice_app/services/app_service/firebase_firestore_service.dart';

import '../model/setup/note.dart';

class NoteService {
  final FirebaseFirestore _firebaseFirestore;

  NoteService(
    FirebaseFirestore? firebaseFirestore,
    FirebaseFirestoreService? firestoreService,
  )   : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  Future<void> saveNote({
    required String noteId,
    required String uid,
    required String termPayment,
    required String noteName,
    required String content,
  }) async {
    final noteRefs = _firebaseFirestore
        .collection('notes')
        .doc(uid)
        .collection('notes')
        .doc(noteId);

    final noteSnapshot = await noteRefs.get();

    final data = {
      'noteId': noteId,
      'name': noteName,
      'content': content,
      'term_payment': termPayment,
      'dateCreated': Timestamp.now(),
    };

    if (noteSnapshot.exists) {
      noteRefs.update(data);
    } else {
      noteRefs.set(data);
    }
  }

  Future<void> deleteNote({
    required String uid,
    required String noteId,
  }) async {
    await _firebaseFirestore
        .collection('notes')
        .doc(uid)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  Stream<List<Note>> getNote(String uid) {
    return _firebaseFirestore
        .collection('notes')
        .doc(uid)
        .collection('notes')
        .orderBy('dateCreated', descending: false)
        .snapshots()
        .map((event) {
      return event.docs.map(
        (e) {
          final data = Note.fromJson(e.data());
          return data;
        },
      ).toList();
    });
  }
}
