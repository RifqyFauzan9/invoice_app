import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:my_invoice_app/services/firebase_auth_service.dart';
import 'package:my_invoice_app/static/firebase_auth_status.dart';

import '../model/common/profile.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuthService _service;

  FirebaseAuthProvider(this._service);

  String? _message;
  Profile? _profile;
  FirebaseAuthStatus _authStatus = FirebaseAuthStatus.unauthenticated;

  Profile? get profile => _profile;
  String? get message => _message;
  FirebaseAuthStatus? get authStatus => _authStatus;

  Future createAccount(String email, String password) async {
    try {
      _authStatus = FirebaseAuthStatus.creatingAccount;
      notifyListeners();

      UserCredential user = await _service.createUser(email, password);
      _authStatus = FirebaseAuthStatus.accountCreated;
      _message = 'Account Created Successfully!';

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
        _profile = Profile(
          uid: user.uid,
          name: user.displayName,
          email: user.email,
          photoUrl: user.photoURL,
        );
      }

      _authStatus = FirebaseAuthStatus.authenticated;
      _message = 'Sign in Success';
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

  Future updateProfile(BuildContext context) async {
    final user = await _service.userChanges();
    if (user != null) {
      _profile = Profile(
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
      _message =
      'Link has been sent.';
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }
}