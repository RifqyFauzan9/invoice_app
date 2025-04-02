import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/static/size_config.dart';

class ChooseFormCard extends StatelessWidget {
  final String image, text;
  final VoidCallback onPressed;

  const ChooseFormCard({
    super.key,
    required this.image,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: Container(
        height: getPropScreenWidth(220),
        width: getPropScreenWidth(220),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: getPropScreenWidth(90),
            ),
            SizedBox(height: getPropScreenWidth(12)),
            Text(
              text,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: getPropScreenWidth(22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}