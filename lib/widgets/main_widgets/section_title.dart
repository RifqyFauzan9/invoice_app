import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool viewAll;
  final VoidCallback? onTap;

  const SectionTitle({
    super.key,
    required this.title,
    required this.viewAll,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        viewAll
            ? GestureDetector(
                onTap: onTap,
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ))
            : const SizedBox(),
      ],
    );
  }
}
