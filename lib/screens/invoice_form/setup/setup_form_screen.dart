import 'package:flutter/material.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/widgets/invoice_form/setup_form_card.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';

class SetupFormScreen extends StatelessWidget {
  const SetupFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SetUpFormCard> formCardList = [
      SetUpFormCard(
        image: 'assets/images/travel_icon.png',
        text: 'Data Travel',
        onPressed: () => Navigator.pushNamed(
          context,
          ScreenRoute.travel.route,
        ),
      ),
      SetUpFormCard(
        image: 'assets/images/bank_icon.png',
        text: 'Data Bank',
        onPressed: () => Navigator.pushNamed(
          context,
          ScreenRoute.bank.route,
        ),
      ),
      SetUpFormCard(
        image: 'assets/images/airlines_icon.png',
        text: 'Data Maskapai',
        onPressed: () => Navigator.pushNamed(
          context,
          ScreenRoute.airlines.route,
        ),
      ),
      SetUpFormCard(
        image: 'assets/images/item_icon.png',
        text: 'Data Item',
        onPressed: () => Navigator.pushNamed(
          context,
          ScreenRoute.item.route,
        ),
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    return formCardList[index];
                  },
                  itemCount: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
