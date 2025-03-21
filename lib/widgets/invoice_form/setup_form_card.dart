import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetUpFormCard extends StatelessWidget {
  final String image, text;
  final VoidCallback onPressed;

  const SetUpFormCard({
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
        height: 166,
        width: 166,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              text,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
