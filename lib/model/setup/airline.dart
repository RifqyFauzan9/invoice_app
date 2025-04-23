class Airline {
  final String airline;
  final String code;

  Airline({
    required this.airline,
    required this.code,
  });

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
      airline: json['airline'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airline': airline,
      'code': code,
    };
  }
}
