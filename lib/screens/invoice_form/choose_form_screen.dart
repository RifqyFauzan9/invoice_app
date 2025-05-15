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
          padding: EdgeInsets.symmetric(
            horizontal: getPropScreenWidth(25),
            vertical: getPropScreenWidth(60),
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
                SizedBox(height: SizeConfig.screenHeight * 0.07),
                ChooseFormCard(
                  icon: Icons.settings,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    ScreenRoute.setup.route,
                  ),
                  text: 'Set Up',
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                ChooseFormCard(
                  icon: Icons.credit_card,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    ScreenRoute.transaksi.route,
                  ),
                  text: 'Transaksi',
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                ChooseFormCard(
                  icon: Icons.bar_chart,
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
