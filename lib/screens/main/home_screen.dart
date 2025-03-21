import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/model/profile.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:provider/provider.dart';
import '../../provider/firebase_auth_provider.dart';
import '../../widgets/main_widgets/custom_icon_button.dart';
import '../../widgets/main_widgets/invoice_card.dart';
import '../../widgets/main_widgets/invoice_status_card.dart';
import '../../widgets/main_widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<InvoiceStatusCard> invoiceStatusCardList = [
    InvoiceStatusCard(
      icon: 'assets/images/pending_icon.png',
      total: 84,
      status: 'Pending',
    ),
    InvoiceStatusCard(
      icon: 'assets/images/lunas_icon.png',
      total: 60,
      status: 'Lunas',
    ),
    InvoiceStatusCard(
      icon: 'assets/images/cancel_icon.png',
      total: 250,
      status: 'Cancel',
    ),
    InvoiceStatusCard(
      icon: 'assets/images/cicilan_icon.png',
      total: 190,
      status: 'Cicilan',
    ),
    InvoiceStatusCard(
      icon: 'assets/images/deposit_icon.png',
      total: 250,
      status: 'Deposit',
    ),
    InvoiceStatusCard(
      icon: 'assets/images/hangus_icon.png',
      total: 250,
      status: 'Hangus',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 60, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildGreetUser(),
                CustomIconButton(
                  icon: CupertinoIcons.person_fill,
                  onPressed: () =>
                      Navigator.pushNamed(context, ScreenRoute.profile.route),
                ),
              ],
            ),
            const SizedBox(height: 24),
            buildHomeBanner(context),
            const SizedBox(height: 16),
            SectionTitle(title: 'Status', viewAll: false),
            const SizedBox(height: 16),
            SizedBox(
              height: 142,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: invoiceStatusCardList.map((card) {
                  return card;
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            SectionTitle(
              title: 'Recent Invoice',
              viewAll: true,
              onTap: () => Navigator.pushNamed(
                context,
                ScreenRoute.listInvoice.route,
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return InvoiceCard(
                    imageLeading: 'assets/images/bmw.png',
                    title: 'Ferrari',
                    subtitle: 'Nguyen, Shane',
                    description: 'May 9, 2014',
                    trailing: Icon(
                      Icons.query_stats,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                    onCardTapped: () => Navigator.pushNamed(
                      context,
                      ScreenRoute.invoiceScreen.route,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, ScreenRoute.chooseForm.route),
        child: Icon(CupertinoIcons.add),
      ),
    );
  }

  Column buildGreetUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello,',
          style: GoogleFonts.montserrat(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        Text(
          'Welcome to InvoTek!',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Stack buildHomeBanner(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          width: MediaQuery.of(context).size.width,
          height: 104,
        ),
        Positioned(
          top: 2,
          left: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '200',
                style: GoogleFonts.montserrat(
                  fontSize: 67.2,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  height: 1.1,
                ),
              ),
              Text(
                'Total Invoice Created',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 24,
          top: -20,
          child: SvgPicture.asset('assets/svgs/banner_image.svg'),
        ),
      ],
    );
  }
}
