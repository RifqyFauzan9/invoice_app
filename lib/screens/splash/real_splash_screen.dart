import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';

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
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
        context,
        ScreenRoute.splash.route,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
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
