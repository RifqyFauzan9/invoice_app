import 'package:flutter/material.dart';

class InvoiceStatusCard extends StatelessWidget {
  final IconData icon;
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6.5),
      constraints: BoxConstraints(
        minWidth: 110,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
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
            height: 40,
            width: 40,
            child: Icon(
              icon,
              size: 29,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            '$total',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            status,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
