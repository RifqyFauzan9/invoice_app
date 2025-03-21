import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/services/firebase_firestore_service.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:provider/provider.dart';

import '../../../provider/firebase_auth_provider.dart';
import '../../../static/firebase_auth_status.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isObsecure = true;

  void _tapToRegister() async {
    final email = _emailController.text;
    final password = _confirmPasswordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
      final navigator = Navigator.of(context);

      await firebaseAuthProvider.createAccount(email, password).then((user) {
        if (user != null) {
          final firestore = context.read<FirebaseFirestoreService>();
          firestore.saveUserData(user.user!.uid, email, 'user');
          debugPrint('Gacor kang!');
        } else {
          debugPrint('Babi kang!');
        }
      });

      switch (firebaseAuthProvider.authStatus) {
        case FirebaseAuthStatus.accountCreated:
        // Tampilkan Flushbar dengan pesan sukses
          Flushbar(
            message: 'Account created successfully! Please login.',
            messageColor: Theme.of(context).colorScheme.onPrimary,
            messageSize: 12,
            duration: const Duration(seconds: 1),
            margin: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.green, // Warna hijau untuk pesan sukses
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            boxShadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
            icon: Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ).show(context).then((_) {
            // Navigasi ke halaman login setelah Flushbar hilang
            navigator.pushReplacementNamed(ScreenRoute.login.route);
          });

        case _:
          Flushbar(
            message: firebaseAuthProvider.message ?? '',
            messageColor: Theme.of(context).colorScheme.onError,
            messageSize: 12,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Theme.of(context).colorScheme.error,
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            boxShadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
            icon: Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onError,
            ),
          ).show(context);
      }
    } else {
      const message = 'Fill the email and password correctly';
      Flushbar(
        message: message,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
        messageColor: Theme.of(context).colorScheme.onError,
        messageSize: 14,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Theme.of(context).colorScheme.error,
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        icon: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.onError,
        ),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(
                Icons.email_outlined,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            obscureText: isObsecure,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(
                Icons.lock_outline,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObsecure = !isObsecure;
                  });
                },
                icon: Icon(
                  isObsecure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _confirmPasswordController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: isObsecure,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
              prefixIcon: Icon(
                Icons.lock_outline,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObsecure = !isObsecure;
                  });
                },
                icon: Icon(
                  isObsecure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  value != _passwordController.text) {
                return 'Password don\'t match';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Consumer<FirebaseAuthProvider>(builder: (context, value, child) {
            return switch (value.authStatus) {
              FirebaseAuthStatus.creatingAccount => Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              _ => SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _tapToRegister();
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
            };
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }
}
