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
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.all(getPropScreenWidth(12)),
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
