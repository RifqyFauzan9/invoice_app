class Travel {
  final String? travelId;
  final String travelName;
  final String contactPerson;
  final String address;
  final int phoneNumber;
  final String emailAddress;

  Travel({
    this.travelId,
    required this.travelName,
    required this.contactPerson,
    required this.address,
    required this.phoneNumber,
    required this.emailAddress,
  });

  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      travelId: json['travelId'],
      travelName: json['travelName'],
      contactPerson: json['contactPerson'],
      address: json['travelAddress'],
      phoneNumber: json['phoneNumber'],
      emailAddress: json['emailAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'travelId': travelId,
      'travelName': travelName,
      'contactPerson': contactPerson,
      'address': address,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
    };
  }
}
