import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:provider/provider.dart';

import '../../../../static/firebase_auth_status.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'x**x@gmail.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Consumer<FirebaseAuthProvider>(
            builder: (context, value, child) {
              return switch (value.authStatus) {
                FirebaseAuthStatus.sendingCode => Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                  ),
                _ => FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _tapToSendCode();
                    }
                  },
                  child: const Text('Send Link'),
                ),
              };
            },
          )
        ],
      ),
    );
  }

  void _tapToSendCode() async {
    final email = _emailController.text;
    if (email.isNotEmpty) {
      final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
      final navigator = Navigator.of(context);

      await firebaseAuthProvider.sendPassword(email);
      switch (firebaseAuthProvider.authStatus) {
        case FirebaseAuthStatus.codeSent:
          Flushbar(
            message: 'Code berhasil dikirim! Silahkan cek email anda.',
            messageColor: Theme.of(context).colorScheme.onPrimary,
            messageSize: 12,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Color(0xFF28A745),
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            icon: Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ).show(context).then((_) {
            navigator.pushReplacementNamed(ScreenRoute.login.route);
          });
        case _:
          Flushbar(
            message: firebaseAuthProvider.message ?? 'Fill the email correctly!',
            messageColor: Theme.of(context).colorScheme.onError,
            messageSize: 14,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Theme.of(context).colorScheme.error,
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            icon: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.onError,
            ),
          ).show(context);
      }
    } else {
      const message = 'Fill the email correctly!';
      Flushbar(
        message: message,
        messageColor: Theme.of(context).colorScheme.onPrimary,
        messageSize: 12,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        icon: Icon(
          Icons.info_outline,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ).show(context);
    }
  }
}
