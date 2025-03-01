import 'package:flutter/material.dart';

enum InvoiceColor {
  primary('primary', Color(0xFF2F6F91)),
  secondary('secondary', Color(0xFFF4A259)),
  third('third', Color(0xFFEDE7D9)),
  four('four', Color(0xFFD9DCD6));
  
  final String name;
  final Color color;

  const InvoiceColor(this.name, this.color);
}
