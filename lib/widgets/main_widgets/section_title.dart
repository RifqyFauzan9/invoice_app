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
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        viewAll
        ? GestureDetector(
          onTap: onTap,
          child: Text(
            'View All',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          )
        )
            : const SizedBox(),
      ],
    );
  }
}