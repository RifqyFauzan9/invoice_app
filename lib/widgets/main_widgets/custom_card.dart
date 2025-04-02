import 'package:flutter/material.dart';
import 'package:my_invoice_app/static/size_config.dart';

class CustomCard extends StatelessWidget {
  final String imageLeading, title;
  final String? subtitle;
  final String? description;
  final Widget? trailing;
  final VoidCallback? onCardTapped;

  const CustomCard({
    super.key,
    required this.imageLeading,
    required this.title,
    this.subtitle,
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
        padding: EdgeInsets.all(getPropScreenWidth(18)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imageLeading,
              width: getPropScreenWidth(60),
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
                      fontSize: getPropScreenWidth(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Visibility(
                    visible: subtitle != null,
                    child: Text(
                      subtitle ?? '',
                      style: TextStyle(
                        fontSize: getPropScreenWidth(12),
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: description != null,
                    child: Text(
                      description ?? '',
                      style: TextStyle(
                        fontSize: getPropScreenWidth(10),
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: trailing != null,
              child: Expanded(
                flex: 1,
                child: trailing ?? SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
