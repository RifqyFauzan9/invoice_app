import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String content;
  final String noteName;
  final String termPayment;
  final String noteId;
  Timestamp? dateCreated;

  Note({
    required this.content,
    required this.noteName,
    required this.termPayment,
    required this.noteId,
    this.dateCreated,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    noteId: json['noteId'],
    content: json["content"],
    // note id
    noteName: json["name"],
    termPayment: json['term_payment'],
    dateCreated: json['dateCreated'],
  );

  Map<String, dynamic> toJson() => {
    "content": content,
    // note id
    "name": noteName,
    'term_payment': termPayment,
    'noteId': noteId,
  };
}