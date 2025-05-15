class Note {
  final String content;
  // note id
  final String type;
  final String termPayment;

  Note({
    required this.content,
    required this.type,
    required this.termPayment,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    content: json["content"],
    // note id
    type: json["type"],
    termPayment: json['term_payment'],
  );

  Map<String, dynamic> toJson() => {
    "content": content,
    // note id
    "type": type,
    'term_payment': termPayment,
  };
}