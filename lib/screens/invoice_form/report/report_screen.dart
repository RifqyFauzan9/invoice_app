import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';

import '../../../static/screen_route.dart';
import '../../../widgets/main_widgets/custom_card.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CustomCard> formCardList = [
      CustomCard(
        imageLeading: 'assets/images/travel_icon.png',
        title: 'Rihlah Wisata',
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jumlah Pembelian: RP.400.000.000'),
            Text('Via Bank: Mandiri'),
            Text('Status: Lunas')
          ],
        ),
      ),
      CustomCard(
        imageLeading: 'assets/images/travel_icon.png',
        title: 'Rendra Wisata',
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jumlah Pembelian: RP.100.000.000'),
            Text('Via Bank: BCA'),
            Text('Status: Deposit')
          ],
        ),
      ),
      CustomCard(
        imageLeading: 'assets/images/travel_icon.png',
        title: 'Ageng Travel',
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jumlah Pembelian: RP.50.000.000'),
            Text('Via Bank: BSI'),
            Text('Status: Cicilan')
          ],
        ),
      ),
      CustomCard(
        imageLeading: 'assets/images/travel_icon.png',
        title: 'Lalu Iman Company',
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jumlah Pembelian: RP.500.000.000'),
            Text('Via Bank: BCA'),
            Text('Status: Lunas')
          ],
        ),
      ),
      CustomCard(
        imageLeading: 'assets/images/travel_icon.png',
        title: 'Kamil Tekno Globalindo',
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jumlah Pembelian: RP.300.000.000'),
            Text('Via Bank: Mandiri'),
            Text('Status: Lunas')
          ],
        ),
      ),
      CustomCard(
        imageLeading: 'assets/images/travel_icon.png',
        title: 'Sriwijaya Air',
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jumlah Pembelian: RP.800.000.000'),
            Text('Via Bank: Mandiri'),
            Text('Status: Lunas')
          ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      'Report Penjualan',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  CustomIconButton(
                    icon: Icons.download,
                    onPressed: () => showFlushBar(context),
                  ),
                ],
              ),
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

  void showFlushBar(BuildContext context) {
    Flushbar(
      message: 'Mengunduh Report...',
      messageColor: Theme.of(context).colorScheme.onPrimary,
      messageSize: 12,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: Colors.grey,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        Icons.downloading,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    ).show(context);
  }
}
