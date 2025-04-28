class Note {
  final String note;
  final String type;

  Note({
    required this.note,
    required this.type,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    note: json["note"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "note": note,
    "type": type,
  };
}