class Profile {
  String? profileLogo;
  final String profileName;
  final String profileAddress;
  final String profileEmail;
  final String profileWebsite;
  final String profilePhone;
  final String profilePic;
  final String? profileSignature;

  Profile(
    this.profileLogo, this.profileSignature, {
    required this.profileName,
    required this.profileAddress,
    required this.profileEmail,
    required this.profileWebsite,
    required this.profilePhone,
    required this.profilePic,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      json['profileLogo'], json['profileSignature'],
      profileName: json['profileName'],
      profileAddress: json['profileAddress'],
      profileEmail: json['profileEmail'],
      profileWebsite: json['profileWebsite'],
      profilePhone: json['profilePhone'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileLogo': profileLogo,
      'profileName': profileName,
      'profileAddress': profileAddress,
      'profileEmail': profileEmail,
      'profileWebsite': profileWebsite,
      'profilePhone': profilePhone,
      'profilePic': profilePic,
      'profileSignature': profileSignature,
    };
  }
}
