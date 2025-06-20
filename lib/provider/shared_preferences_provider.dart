import 'package:flutter/widgets.dart';
import 'package:my_invoice_app/services/app_service/shared_preferences_service.dart';

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
}