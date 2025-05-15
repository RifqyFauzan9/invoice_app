import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/provider/company_provider.dart';
import 'package:my_invoice_app/services/company_service.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';

import '../../provider/firebase_auth_provider.dart';
import '../../provider/shared_preferences_provider.dart';

class RealSplashScreen extends StatefulWidget {
  const RealSplashScreen({super.key});

  @override
  State<RealSplashScreen> createState() => _RealSplashScreenState();
}

class _RealSplashScreenState extends State<RealSplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    final navigator = Navigator.of(context);
    final isLogin = context.read<SharedPreferencesProvider>().isLogin;
    final companyService = context.read<CompanyService>();
    final companyProvider = context.read<CompanyProvider>();

    Future.delayed(
      Duration(seconds: 2),
      () async {
        if (isLogin) {
          await firebaseAuthProvider.updateProfile(context);
          final company = await companyService.getCompanyData(
              context.read<FirebaseAuthProvider>().profile!.uid!);
          if (company != null) {
            companyProvider.setCompany(company);
          } else {
            debugPrint('Company data null!');
          }
          navigator.pushReplacementNamed(
            ScreenRoute.main.route,
            arguments: context.read<FirebaseAuthProvider>().profile!.uid,
          );
        } else {
          navigator.pushReplacementNamed(ScreenRoute.splash.route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InvoiceColor.primary.color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'InvoTek',
              style: GoogleFonts.bungee(
                height: 1.3,
                fontSize: getPropScreenWidth(40),
                color: Color(0xFFFFFFFF),
              ),
            ),
            Text(
              'Bantu hari harimu lebih mudah!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Color(0xFFB0D0E3),
                fontSize: getPropScreenWidth(17),
              ),
            ),
            SizedBox(
              height: getPropScreenWidth(40),
            ),
            LoadingAnimationWidget.fourRotatingDots(
              color: Color(0xFFB0D0E3),
              size: getPropScreenWidth(60),
            ),
          ],
        ),
      ),
    );
  }
}
