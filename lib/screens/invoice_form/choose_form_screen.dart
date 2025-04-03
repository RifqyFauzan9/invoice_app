import 'package:flutter/material.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';

import '../../widgets/invoice_form/choose_form_card.dart';

class ChooseFormScreen extends StatelessWidget {
  const ChooseFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 60,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                ChooseFormCard(
                  image: 'assets/images/setup_icon.png',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    ScreenRoute.setup.route,
                  ),
                  text: 'Set Up',
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                ChooseFormCard(
                  image: 'assets/images/invoice_icon.png',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    ScreenRoute.transaksi.route,
                  ),
                  text: 'Transaksi',
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                ChooseFormCard(
                  image: 'assets/images/report_icon.png',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    ScreenRoute.report.route,
                  ),
                  text: 'Report',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
