import 'package:flutter/material.dart';

enum InvoiceColor {
  // Light Mode Colors
  primary(Color(0xFF2F6F91)),
  secondary(Color(0xFFF4A259)),
  third(Color(0xFFEDE7D9)),
  four(Color(0xFFD9DCD6)),
  error(Color(0xFFDC3545)),
  info(Color(0xFF757575));

  // Dark Mode Colors


  final Color color;

  const InvoiceColor(this.color);
}
