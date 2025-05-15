class Company {
  String? companyLogo;
  final String companyName;
  final String companyAddress;
  final String companyEmail;
  final String companyWebsite;
  final int companyPhone;
  final String companyPic;

  Company(
    this.companyLogo, {
    required this.companyName,
    required this.companyAddress,
    required this.companyEmail,
    required this.companyWebsite,
    required this.companyPhone,
    required this.companyPic,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      json['companyLogo'],
      companyName: json['companyName'],
      companyAddress: json['companyAddress'],
      companyEmail: json['companyEmail'],
      companyWebsite: json['companyWebsite'],
      companyPhone: json['companyPhone'],
      companyPic: json['companyPic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyLogo': companyLogo,
      'companyName': companyName,
      'companyAddress': companyAddress,
      'companyEmail': companyEmail,
      'companyWebsite': companyWebsite,
      'companyPhone': companyPhone,
      'companyPic': companyPic,
    };
  }
}
