import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../static/size_config.dart';

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
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 30,
          ),
          child: Column(
            children: [
              Image.asset(
                image,
                width: getPropScreenWidth(90),
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: getPropScreenWidth(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
