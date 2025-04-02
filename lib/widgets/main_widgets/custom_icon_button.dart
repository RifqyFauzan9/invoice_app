import 'package:flutter/material.dart';
import 'package:my_invoice_app/static/size_config.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(getPropScreenWidth(12)),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: getPropScreenWidth(22),
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
