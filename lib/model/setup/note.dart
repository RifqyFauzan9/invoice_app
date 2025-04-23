class Note {
  final String type;
  final String note;

  Note({
    required this.type,
    required this.note,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      type: json['type'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'note': note,
    };
  }
}
