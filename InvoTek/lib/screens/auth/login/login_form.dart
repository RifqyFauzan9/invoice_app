import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/provider/profile_provider.dart';
import 'package:my_invoice_app/provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/provider/shared_preferences_provider.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';

import '../../../model/common/user.dart';
import '../../../services/profile_service.dart';
import '../../../static/firebase_auth_status.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool isObsecure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyIdController = TextEditingController();

  void _tapToLogin() async {
    final companyId = _companyIdController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final navigator = Navigator.of(context);
    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final sharedPreferenceProvider = context.read<SharedPreferencesProvider>();
    final profileService =
        context.read<ProfileService>(); // ✅ Tambahkan baris ini

    try {
      await firebaseAuthProvider.signInUser(email, password);

      if (firebaseAuthProvider.authStatus == FirebaseAuthStatus.authenticated) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw 'Authentication failed.';

        final userDoc = await FirebaseFirestore.instance
            .collection('companies')
            .doc(companyId)
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) throw 'User not found in this company.';

        final userData = userDoc.data()!;
        final role = userData['role'];
        final name = userData['name'] ?? '';
        final photoUrl = userData['photoUrl'];

        final profile = Person(
          uid: user.uid,
          name: name,
          email: email,
          role: role,
          companyId: companyId,
          photoUrl: photoUrl,
        );

        profileProvider.setPerson(profile);

        // ✅ Ambil dan set data profile perusahaan
        final companyProfile =
            await profileService.getCompanyProfile(companyId);
        if (companyProfile != null) {
          profileProvider.setProfile(companyProfile);
        } else {
          debugPrint('Company profile not found.');
        }

        await sharedPreferenceProvider.savePerson(profile);
        await sharedPreferenceProvider.login();

        navigator.pushReplacementNamed(
          ScreenRoute.logSuccess.route,
        );
      } else {
        throw firebaseAuthProvider.message ?? 'Login failed.';
      }
    } catch (e) {
      showFlushbar(e.toString(), Icons.error_outline, InvoiceColor.error.color);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _companyIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _companyIdController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.business_outlined),
              hintText: 'Enter your company name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your company name';
              }
              return null;
            },
          ),
          SizedBox(height: getPropScreenWidth(16)),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              hintText: 'x**x@gmail.com',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          SizedBox(
            height: getPropScreenWidth(16),
          ),
          TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: '*****************',
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObsecure = !isObsecure;
                  });
                },
                icon: Icon(
                  isObsecure ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            obscureText: isObsecure,
            onFieldSubmitted: (value) => _tapToLogin(),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Consumer<FirebaseAuthProvider>(
            builder: (context, value, child) {
              return switch (value.authStatus) {
                FirebaseAuthStatus.authenticating => Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Theme.of(context).colorScheme.primary,
                      size: getPropScreenWidth(30),
                    ),
                  ),
                _ => FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _tapToLogin();
                      }
                    },
                    child: const Text('Sign In'),
                  ),
              };
            },
          ),
        ],
      ),
    );
  }

  void showFlushbar(String message, IconData icon, Color bgColor) {
    Flushbar(
      message: message,
      messageColor: Theme.of(context).colorScheme.onError,
      messageSize: 14,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: bgColor,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.onError,
      ),
    ).show(context);
  }
}
