import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/provider/profile_provider.dart';
import 'package:my_invoice_app/services/profile_service.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';

import '../../provider/shared_preferences_provider.dart';

class RealSplashScreen extends StatefulWidget {
  const RealSplashScreen({super.key});

  @override
  State<RealSplashScreen> createState() => _RealSplashScreenState();
}

class _RealSplashScreenState extends State<RealSplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () async {
      final sharedPrefProvider = context.read<SharedPreferencesProvider>();
      final profileService = context.read<ProfileService>();
      final profileProvider = context.read<ProfileProvider>();
      final navigator = Navigator.of(context);

      if (sharedPrefProvider.isLogin) {
        final person = await sharedPrefProvider.loadPerson();
        if (person != null) {
          profileProvider.setPerson(person);

          final companyProfile =
              await profileService.getCompanyProfile(person.companyId!);
          if (companyProfile != null) {
            profileProvider.setProfile(companyProfile);
          }

          navigator.pushReplacementNamed(
            ScreenRoute.main.route,
            arguments: person.companyId,
          );
        } else {
          debugPrint('No cached person found!');
          navigator.pushReplacementNamed(ScreenRoute.splash.route);
        }
      } else {
        navigator.pushReplacementNamed(ScreenRoute.splash.route);
      }
    });
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
              'Make Your Business To Easier!',
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
