class Airline {
  final String code;
  final String airline;

  Airline({
    required this.code,
    required this.airline,
  });

  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
    code: json["code"],
    airline: json["airline"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "airline": airline,
  };
}