import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService(
    FirebaseAuth? auth,
  ) : _auth = auth ??= FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUserCompanyData(String uid) async {
    final companySnapshot = await FirebaseFirestore.instance.collection('companies').get();

    for (final doc in companySnapshot.docs) {
      final usersRef = doc.reference.collection('users');
      final userQuery = await usersRef.where('uid', isEqualTo: uid).limit(1).get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        return {
          'companyId': doc.id,
          'role': userDoc['role'],
          'userId': userDoc.id,
          'userData': userDoc.data(),
        };
      }
    }
    return null;
  }

  Future<UserCredential> createUser(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // await sendEmailVerification(result.user!);

      return result;
    } on FirebaseAuthException catch (e) {
      final errorMessage = switch (e.code) {
        "email-already-in-use" =>
          "There already exists an account with the given email address.",
        "invalid-email" => "The email address is not valid.",
        "operation-not-allowed" => "Server error, please try again later.",
        "weak-password" => "The password is not strong enough.",
        _ => "Register failed. Please try again.",
      };
      throw errorMessage;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserCredential> signInUser(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      return result;
    } on FirebaseAuthException catch (e) {
      final errorMessage = switch (e.code) {
        "invalid-email" => "The email address is not valid.",
        "user-disabled" => "User disabled.",
        "user-not-found" => "No user found with this email.",
        "wrong-password" => "Wrong email/password combination.",
        'email_not_verified' => 'Email belum verified',
        _ => "Login failed. Please try again.",
      };
      throw errorMessage;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Logout failed. Please try again.';
    }
  }

  Future<void> sendPassword(String email) async {
    try {
      final result = await _auth.sendPasswordResetEmail(email: email);
      return result;
    } on FirebaseAuthException catch (e) {
      final errorMessage = switch (e.code) {
        'invalid-email' => 'The email address is not valid.',
        'user-not-found' => 'The email address is not registered',
        _ => "Send code failed. Please try again.",
      };
      throw errorMessage;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<User?> userChanges() => _auth.userChanges().first;

  // Future<void> sendEmailVerification(User user) async {
  //   if (!user.emailVerified) {
  //     await user.sendEmailVerification();
  //   }
  // }
}
