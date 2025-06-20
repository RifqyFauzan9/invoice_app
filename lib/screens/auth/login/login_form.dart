import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/provider/company_provider.dart';
import 'package:my_invoice_app/provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/provider/shared_preferences_provider.dart';
import 'package:my_invoice_app/services/company_service.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
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
  final _companyIdController = TextEditingController();

  void _tapToLogin() async {
    final companyId = _companyIdController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final companyProvider = context.read<CompanyProvider>();
    final companyService = context.read<CompanyService>();

    if (email.isNotEmpty && password.isNotEmpty /* && companyId.isNotEmpty */) {
      final sharedPreferenceProvider =
          context.read<SharedPreferencesProvider>();
      final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
      final navigator = Navigator.of(context);

      // await firebaseAuthProvider.signInUser(email, password);
      // switch (firebaseAuthProvider.authStatus) {
      //   case FirebaseAuthStatus.authenticated:
      //     final uid = firebaseAuthProvider.profile!.uid!;
      //     final userDoc = await companyService.getCompany(uid);
      //     if (!userDoc.exists || userDoc['companyId'] != companyId) {
      //       await firebaseAuthProvider.signOutUser();
      //       showFlushbar(
      //         'Invalid Company ID',
      //         Icons.error_outline,
      //         InvoiceColor.error.color,
      //       );
      //       return;
      //     }
      //     final role = userDoc['role'] as String;
      //     sharedPreferenceProvider.setRole(role);
      //     sharedPreferenceProvider.login();
      //     navigator.pushReplacementNamed(ScreenRoute.main.route);
      //     break;
      //
      //   default:
      //     showFlushbar(
      //       firebaseAuthProvider.message ?? 'Login Failed',
      //       Icons.error_outline,
      //       InvoiceColor.error.color,
      //     );
      // }

      await firebaseAuthProvider.signInUser(email, password);
      switch (firebaseAuthProvider.authStatus) {
        case FirebaseAuthStatus.authenticated:
          await sharedPreferenceProvider.login();
          final company = await companyService.getCompanyData(
              context.read<FirebaseAuthProvider>().profile!.uid!);
          if (company != null) {
            companyProvider.setCompany(company);
          } else {
            debugPrint('Company data null!');
          }
          navigator.pushReplacementNamed(
            ScreenRoute.logSuccess.route,
            arguments: context.read<FirebaseAuthProvider>().profile!.uid,
          );

        case _:
          Flushbar(
            message: firebaseAuthProvider.message ?? '',
            messageColor: Theme.of(context).colorScheme.onError,
            messageSize: 14,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(10),
            backgroundColor: InvoiceColor.error.color,
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
        backgroundColor: InvoiceColor.error.color,
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
          // TextFormField(
          //   controller: _companyIdController,
          //   keyboardType: TextInputType.text,
          //   textInputAction: TextInputAction.next,
          //   decoration: InputDecoration(
          //     prefixIcon: Icon(Icons.business),
          //     hintText: 'Company ID',
          //   ),
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your company ID';
          //     }
          //     return null;
          //   },
          // ),
          // SizedBox(
          //   height: getPropScreenWidth(16),
          // ),
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
                  style: TextStyle(
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
                  style: TextStyle(
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
