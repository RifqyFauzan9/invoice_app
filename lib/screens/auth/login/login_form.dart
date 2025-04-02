import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/provider/shared_preferences_provider.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:provider/provider.dart';

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

  void _tapToLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      final sharedPreferenceProvider =
          context.read<SharedPreferencesProvider>();
      final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
      final navigator = Navigator.of(context);

      await firebaseAuthProvider.signInUser(email, password, context);
      switch (firebaseAuthProvider.authStatus) {
        case FirebaseAuthStatus.authenticated:
          await sharedPreferenceProvider.login();
          navigator.pushReplacementNamed(ScreenRoute.logSuccess.route);

        case _:
          Flushbar(
            message: firebaseAuthProvider.message ?? '',
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
    } else {
      const message = 'Fill the email and password correctly';

      Flushbar(
        message: message,
        messageColor: Theme.of(context).colorScheme.onPrimary,
        messageSize: 12,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Theme.of(context).colorScheme.error,
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        icon: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ).show(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
              prefixIcon: Icon(Icons.email_outlined),
              hintText: 'Email',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          SizedBox(height: getPropScreenWidth(16),),
          TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
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
            obscureText: isObsecure,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  ScreenRoute.signUp.route,
                ),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  ScreenRoute.forgot.route,
                ),
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Consumer<FirebaseAuthProvider>(
            builder: (context, value, child) {
              return switch (value.authStatus) {
                FirebaseAuthStatus.authenticating => Center(
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
                          _tapToLogin();
                        }
                      },
                      child: const Text('Sign In'),
                    ),
                  ),
              };
            },
          ),
        ],
      ),
    );
  }
}
