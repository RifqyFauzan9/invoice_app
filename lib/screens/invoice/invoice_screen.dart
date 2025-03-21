import 'package:flutter/material.dart';

import '../../widgets/main_widgets/custom_icon_button.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 60,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                    CustomIconButton(
                      icon: Icons.share,
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.75),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                        onPressed: () {},
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Color(0xFF007BFF),
                        ),
                        onPressed: () {},
                        child: const Text('Download'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
