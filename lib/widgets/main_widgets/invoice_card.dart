import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  final String imageLeading, title, subtitle;
  final String? description;
  final Widget? trailing;
  final VoidCallback? onCardTapped;

  const InvoiceCard({
    super.key,
    required this.imageLeading,
    required this.title,
    required this.subtitle,
    this.description,
    this.trailing,
    this.onCardTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTapped ?? () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 107,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                imageLeading,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
                  ),
                  Text(
                    description ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: trailing ?? SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
