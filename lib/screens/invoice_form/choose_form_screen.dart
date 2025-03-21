import 'package:flutter/material.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/widgets/invoice_form/choose_form_card.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';

class ChooseFormScreen extends StatelessWidget {
  const ChooseFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 60,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CustomIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              ChooseFormCard(
                image: 'assets/images/setup_icon.png',
                text: 'Set Up',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ScreenRoute.setup.route,
                  );
                },
              ),
              const SizedBox(height: 41),
              ChooseFormCard(
                image: 'assets/images/invoice_icon.png',
                text: 'Transaksi',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ScreenRoute.transaksi.route,
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
