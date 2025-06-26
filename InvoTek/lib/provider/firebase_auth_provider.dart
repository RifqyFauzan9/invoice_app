import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:my_invoice_app/model/common/user.dart';
import 'package:my_invoice_app/static/firebase_auth_status.dart';

import '../services/app_service/firebase_auth_service.dart';
import '../services/app_service/user_service.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuthService _service;

  FirebaseAuthProvider(this._service);

  String? _message;
  Person? _profile;
  FirebaseAuthStatus _authStatus = FirebaseAuthStatus.unauthenticated;

  Person? get profile => _profile;
  String? get message => _message;
  FirebaseAuthStatus? get authStatus => _authStatus;

  Future createAccount(String email, String password) async {
    try {
      _authStatus = FirebaseAuthStatus.creatingAccount;
      notifyListeners();

      UserCredential user = await _service.createUser(email, password);
      _authStatus = FirebaseAuthStatus.accountCreated;
      _message = 'Account created successfully. Please check email to verify.';

      return user;
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }

  Future signInUser(String email, String password) async {
    try {
      _authStatus = FirebaseAuthStatus.authenticating;
      notifyListeners();

      final result = await _service.signInUser(email, password);
      final user = result.user;

      if (user != null) {
        final userService = UserService();
        final userData = await userService.getUserCompanyData(user.uid);

        if (userData != null) {
          final companyId = userData['companyId'];
          final role = userData['role'];

          _profile = Person(
            uid: user.uid,
            name: user.displayName,
            email: user.email,
            photoUrl: user.photoURL,
            companyId: companyId,
            role: role,
          );

          _authStatus = FirebaseAuthStatus.authenticated;
          _message = 'Sign in Success';
        } else {
          _authStatus = FirebaseAuthStatus.error;
          _message = 'User data not found in Firestore.';
        }
      }
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }


  Future signOutUser() async {
    try {
      _authStatus = FirebaseAuthStatus.signingOut;
      notifyListeners();

      await _service.signOut();

      _authStatus = FirebaseAuthStatus.unauthenticated;
      _message = 'Sign out success';
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }

  void reset() {
    _profile = null;
    _authStatus = FirebaseAuthStatus.unauthenticated;
    _message = null;
    notifyListeners();
  }

  Future updateProfile(BuildContext context) async {
    final user = await _service.userChanges();
    if (user != null) {
      _profile = Person(
        uid: user.uid,
        name: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
      );
    }
    notifyListeners();
  }

  Future sendPassword(String email) async {
    try {
      _authStatus = FirebaseAuthStatus.sendingCode;
      notifyListeners();

      await _service.sendPassword(email);
      _authStatus = FirebaseAuthStatus.codeSent;
      _message = 'Link has been sent.';
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }
}
