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
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 6.5),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 40, 16),
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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
