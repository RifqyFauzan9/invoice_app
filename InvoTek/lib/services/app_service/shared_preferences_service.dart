import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String _keyLogin = 'MY_LOGIN';
  static const String _keyRole = 'MY_ROLE';

  bool? get isLogin => _preferences.getBool(_keyLogin);

  Future<void> login() async {
    try {
      await _preferences.setBool(_keyLogin, true);
    } catch (e) {
      throw Exception("Shared preferences cannot save the value.");
    }
  }

  Future<void> logout() async {
    try {
      await _preferences.setBool(_keyLogin, false);
    } catch (e) {
      throw Exception("Shared preferences cannot save the value.");
    }
  }

  Future<void> setRole(String role) async {
    try {
      await _preferences.setString(_keyRole, role);
    } catch (e) {
      throw Exception('Shared Preferences cannot save the value.');
    }
  }

  Future<String?> getRole() async {
    try {
      return _preferences.getString(_keyRole);
    } catch (e) {
      throw Exception('Shared Preferences cannot get the value.');
    }
  }
}
