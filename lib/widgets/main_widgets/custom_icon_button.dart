import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool? blueDotted;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.blueDotted,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            if (blueDotted == true)
              Positioned(
                top: 3,
                right: 3,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
