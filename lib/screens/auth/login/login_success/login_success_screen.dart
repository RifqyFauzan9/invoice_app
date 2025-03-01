import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:my_invoice_app/static/screen_route.dart';

class LoginSuccessScreen extends StatefulWidget {
  const LoginSuccessScreen({super.key});

  @override
  State<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends State<LoginSuccessScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showFlushbar();
    });
  }

  void _showFlushbar() {
    Flushbar(
      message: 'Login berhasil! Anda telah masuk ke akun Anda.',
      messageColor: Theme.of(context).colorScheme.onPrimary,
      messageSize: 12,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: Color(0xFF28A745),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 60,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Icon(
              Icons.check_circle,
              size: 231,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 48),
            Text(
              'Login Success',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Anda berhasil masuk ke akun Anda. Selamat menggunakan layanan kami! Tekan ‘Continue‘ untuk melanjutkan ke beranda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            FilledButton(
                onPressed: () => Navigator.pushNamed(
                      context,
                      ScreenRoute.main.route,
                    ),
                child: const Text('Continue')),
          ],
        ),
      ),
    );
  }
}
