import 'package:flutter/material.dart';
import 'package:my_invoice_app/static/size_config.dart';

class CustomCard extends StatelessWidget {
  final String imageLeading, title;
  final Widget? trailing, subtitle;
  final VoidCallback? onCardTapped;

  const CustomCard({
    super.key,
    required this.imageLeading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onCardTapped,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onCardTapped,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: EdgeInsets.all(getPropScreenWidth(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imageLeading,
                width: getPropScreenWidth(60),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      child: subtitle ?? SizedBox(),
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
      ),
    );
  }
}
