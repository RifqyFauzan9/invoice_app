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
        Expanded(
          flex: 3,
          child: SvgPicture.asset(image),
        ),
        const SizedBox(height: 32),
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: getPropScreenWidth(28),
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 1,
          child: Text(
            subtitle,
            style: GoogleFonts.montserrat(
              fontSize: getPropScreenWidth(13),
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
