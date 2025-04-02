import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/static/size_config.dart';

class SplashContent extends StatelessWidget {
  final String title, subtitle, image;

  const SplashContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          image,
          width: getPropScreenWidth(290),
        ),
        SizedBox(height: getPropScreenWidth(48)),
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: getPropScreenWidth(25),
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: getPropScreenWidth(10)),
        Text(
          subtitle,
          style: GoogleFonts.montserrat(
            fontSize: getPropScreenWidth(14),
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
