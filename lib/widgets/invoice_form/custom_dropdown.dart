import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String Function(T) itemLabelBuilder;
  final void Function(T?)? onChanged;
  final String emptyHint;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.value,
    this.emptyHint = 'Data tidak tersedia',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final hintTextStyle = TextStyle(
      color: primary.withOpacity(0.3),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<T>(
          icon: Icon(Icons.keyboard_arrow_down, color: primary),
          hint: items.isEmpty
              ? Text(emptyHint, style: hintTextStyle)
              : null,
          value: items.isNotEmpty ? items.first : null,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabelBuilder(item)),
            );
          }).toList(),
          onChanged: items.isEmpty ? null : onChanged,
        ),
      ],
    );
  }
}
