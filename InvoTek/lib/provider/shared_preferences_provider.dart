import 'package:flutter/widgets.dart';
import 'package:my_invoice_app/services/app_service/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/common/user.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  final SharedPreferencesService _service;

  SharedPreferencesProvider(this._service);

  bool _isLogin = false;
  bool get isLogin => _service.isLogin ?? _isLogin;

  Future login() async {
    await _service.login();
    _isLogin = true;
    notifyListeners();
  }

  Future logout() async {
    await _service.logout();
    _isLogin = false;
    notifyListeners();
  }

  Future setRole(String role) async {
    await _service.setRole(role);
    notifyListeners();
  }

  Future getRole() async {
    await _service.getRole();
  }

  Future<void> savePerson(Person person) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', person.uid ?? '');
    await prefs.setString('name', person.name ?? '');
    await prefs.setString('email', person.email ?? '');
    await prefs.setString('companyId', person.companyId ?? '');
    await prefs.setString('role', person.role ?? '');
    await prefs.setString('photoUrl', person.photoUrl ?? '');
  }

  Future<Person?> loadPerson() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid == null || uid.isEmpty) return null;

    return Person(
      uid: uid,
      name: prefs.getString('name'),
      email: prefs.getString('email'),
      companyId: prefs.getString('companyId'),
      role: prefs.getString('role'),
      photoUrl: prefs.getString('photoUrl'),
    );
  }
}