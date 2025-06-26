import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_invoice_app/model/setup/note.dart';

class NoteService {
  final FirebaseFirestore _firebaseFirestore;

  NoteService(FirebaseFirestore? firebaseFirestore)
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> saveNote({
    required String noteId,
    required String companyId,
    required String termPayment,
    required String noteName,
    required String content,
  }) async {
    final noteRef = _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('notes')
        .doc(noteId);

    final data = {
      'noteId': noteId,
      'name': noteName,
      'content': content,
      'term_payment': termPayment,
      'dateCreated': Timestamp.now(),
    };

    final snapshot = await noteRef.get();
    if (snapshot.exists) {
      await noteRef.update(data);
    } else {
      await noteRef.set(data);
    }
  }

  Future<void> deleteNote({
    required String companyId,
    required String noteId,
  }) async {
    await _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  Stream<List<Note>> getNote(String companyId) {
    return _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('notes')
        .orderBy('dateCreated', descending: false)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Note.fromJson(e.data())).toList();
    });
  }
}
