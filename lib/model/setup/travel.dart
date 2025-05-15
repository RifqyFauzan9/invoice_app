class Travel {
  final String travelAddress;
  final String emailAddress;
  final int phoneNumber;
  final String travelId;
  final String travelName;
  final String contactPerson;

  Travel({
    required this.travelAddress,
    required this.emailAddress,
    required this.phoneNumber,
    required this.travelId,
    required this.travelName,
    required this.contactPerson
  });

  factory Travel.fromJson(Map<String, dynamic> json) => Travel(
    travelAddress: json["travelAddress"],
    emailAddress: json["emailAddress"],
    phoneNumber: json["phoneNumber"],
    travelId: json["travelId"],
    travelName: json["travelName"],
    contactPerson: json["contactPerson"],
  );

  Map<String, dynamic> toJson() => {
    "travelAddress": travelAddress,
    "emailAddress": emailAddress,
    "phoneNumber": phoneNumber,
    "travelId": travelId,
    "travelName": travelName,
    "contactPerson": contactPerson,
  };
}