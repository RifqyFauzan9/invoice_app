import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';

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
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 6,
          spreadRadius: 3,
          offset: Offset(0, 2),
        ),
      ],
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        Icons.check_circle,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
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
              color: InvoiceColor.primary.color,
            ),
            const SizedBox(height: 48),
            Text(
              'Login Success',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 32),
            Text(
                'Anda berhasil masuk ke akun Anda. Selamat menggunakan layanan kami! Tekan ‘Continue‘ untuk melanjutkan ke beranda.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                )),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.pushNamed(
                context,
                ScreenRoute.main.route,
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
