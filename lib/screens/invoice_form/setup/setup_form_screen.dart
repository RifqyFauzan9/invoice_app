import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_card.dart';

class SetupFormScreen extends StatelessWidget {
  const SetupFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CustomCard> formCardList = [
      CustomCard(
        imageLeading: 'assets/images/travel_icon.png',
        title: 'Data Travel',
        onCardTapped: () => Navigator.pushNamed(
          context,
          ScreenRoute.travel.route,
        ),
      ),
      CustomCard(
        imageLeading: 'assets/images/bank_icon.png',
        title: 'Data Bank',
        onCardTapped: () => Navigator.pushNamed(
          context,
          ScreenRoute.bank.route,
        ),
      ),
      CustomCard(
        imageLeading: 'assets/images/airlines_icon.png',
        title: 'Data Airlines',
        onCardTapped: () => Navigator.pushNamed(
          context,
          ScreenRoute.airlines.route,
        ),
      ),
      CustomCard(
        imageLeading: 'assets/images/item_icon.png',
        title: 'Data Item',
        onCardTapped: () => Navigator.pushNamed(
          context,
          ScreenRoute.item.route,
        ),
      ),
      CustomCard(
        imageLeading: 'assets/images/note_icon.png',
        title: 'Data Note',
        onCardTapped: () => Navigator.pushNamed(
          context,
          ScreenRoute.note.route,
        ),
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getPropScreenWidth(25),
          vertical: getPropScreenWidth(60),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconButton(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.pop(context),
              ),
              Platform.isIOS
                  ? SizedBox(height: SizeConfig.screenHeight * 0.01)
                  : SizedBox(height: SizeConfig.screenHeight * 0.04),
              Expanded(
                child: ListView(
                  children: formCardList.map((card) {
                    return card;
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
