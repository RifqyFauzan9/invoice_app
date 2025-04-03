import 'package:flutter/material.dart';
import 'package:my_invoice_app/static/size_config.dart';

class InvoiceStatusCard extends StatelessWidget {
  final String icon;
  final int total;
  final String status;

  const InvoiceStatusCard({
    super.key,
    required this.icon,
    required this.total,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getPropScreenWidth(110),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 6.5),
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.surface,
                ),
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  icon,
                  width: getPropScreenWidth(29),
                  height: getPropScreenWidth(29),
                ),
              ),
              Text(
                '$total',
                style: TextStyle(
                  fontSize: getPropScreenWidth(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: getPropScreenWidth(12),
                  fontWeight: FontWeight.w500,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
