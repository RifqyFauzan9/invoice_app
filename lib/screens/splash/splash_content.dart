import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          width: getPropScreenWidth(280),
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.05),
        Text(
          title,
          style: TextStyle(
            fontSize: getPropScreenWidth(26),
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.01),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: getPropScreenWidth(15),
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
