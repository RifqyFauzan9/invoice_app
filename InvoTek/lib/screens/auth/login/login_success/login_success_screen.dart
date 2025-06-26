import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:my_invoice_app/provider/profile_provider.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:provider/provider.dart';

import '../../../../style/colors/invoice_color.dart';

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
              size: getPropScreenWidth(230),
              color: InvoiceColor.primary.color,
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.03),
            Text(
              'Login Success',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getPropScreenWidth(33),
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            Text(
              'Anda berhasil masuk ke akun Anda. Selamat menggunakan layanan kami! Tekan ‘Continue‘ untuk melanjutkan ke beranda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getPropScreenWidth(13),
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                ScreenRoute.main.route,
                arguments: context.read<ProfileProvider>().person!.companyId!,
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
