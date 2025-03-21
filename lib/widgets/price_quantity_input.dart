import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PriceQuantityInput extends StatefulWidget {
  const PriceQuantityInput({
    super.key,
    required this.initialValue,
    required this.hintText,
  });

  final int initialValue;
  final String hintText;

  @override
  State<PriceQuantityInput> createState() => _PriceQuantityInputState();
}

class _PriceQuantityInputState extends State<PriceQuantityInput> {
  late int _currentValue;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(text: _currentValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _currentValue++;
      _controller.text = _currentValue.toString();
    });
  }

  void _decrement() {
    if (_currentValue > 0) {
      setState(() {
        _currentValue--;
        _controller.text = _currentValue.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hint Text Style
    TextStyle hintTextStyle = GoogleFonts.montserrat(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Harga ${widget.hintText}',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: () => _decrement(),
          icon: Icon(Icons.remove),
        ),
        const SizedBox(width: 7),
        Expanded(
          flex: 1,
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            onChanged: (value) {
              setState(() {
                _currentValue = int.tryParse(value) ?? 0; // Update _currentValue
              });
            },
          ),
        ),
        const SizedBox(width: 7),
        IconButton(
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: () => _increment(),
          icon: Icon(Icons.add),
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
