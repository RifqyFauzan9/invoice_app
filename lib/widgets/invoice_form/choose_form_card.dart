import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../static/size_config.dart';

class ChooseFormCard extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  const ChooseFormCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Outside gradient
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF5FCAFF).withOpacity(0.10),
                      Color(0xFF2F6F91).withOpacity(0.10),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                // Inside gradient with image inside
                child: Container(
                  height: getPropScreenWidth(60),
                  width: getPropScreenWidth(60),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF5FCAFF).withOpacity(0.12),
                        Color(0xFF2F6F91).withOpacity(0.12),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [
                          Color(0xFF5FCAFF),
                          Color(0xFF2F6F91),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Icon(
                      icon,
                      size: getPropScreenWidth(40),
                    ),
                  ),
                ),
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
