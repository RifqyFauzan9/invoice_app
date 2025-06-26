class Person {
  final String? uid, name, email, photoUrl, companyId, role;

  Person({
    this.name,
    this.email,
    this.photoUrl,
    this.uid,
    this.companyId,
    this.role,
  });
}

class UserModel {
  final String id;
  final String email;
  final String username;
  final String role;
  final String companyId;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.companyId,
  });

  factory UserModel.fromMap(
      String id, Map<String, dynamic> data, String companyId) {
    return UserModel(
      id: id,
      email: data['email'],
      username: data['username'],
      role: data['role'],
      companyId: companyId,
    );
  }
}
