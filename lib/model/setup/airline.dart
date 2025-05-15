class Airline {
  final String airlineId;
  final String airlineCode;
  final String airlineName;

  Airline({
    required this.airlineName,
    required this.airlineId,
    required this.airlineCode,
  });

  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
    airlineId: json['airlineId'],
    airlineCode: json["airlineCode"],
    airlineName: json["airlineName"],
  );

  Map<String, dynamic> toJson() => {
    "airlineCode": airlineCode,
    "airlineName": airlineName,
    'airlineId': airlineId,
  };
}