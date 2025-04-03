import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import '../../widgets/main_widgets/custom_icon_button.dart';
import '../../widgets/main_widgets/custom_card.dart';
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      icon: CupertinoIcons.person_fill,
                      onPressed: () => Navigator.pushNamed(
                          context, ScreenRoute.profile.route),
                    ),
                    SizedBox(width: getPropScreenWidth(8),),
                    CustomIconButton(
                      icon: CupertinoIcons.add,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        ScreenRoute.chooseForm.route,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
            buildHomeBanner(context),
            const SizedBox(height: 16),
            SectionTitle(title: 'Status', viewAll: false),
            const SizedBox(height: 16),
            SizedBox(
              height: getPropScreenWidth(140),
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
            SizedBox(height: getPropScreenWidth(16)),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return CustomCard(
                    imageLeading: 'assets/images/travel_icon.png',
                    title: 'Rihlah Wisata',
                    subtitle: Text('IBU DEDE'),
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
    );
  }

  Column buildGreetUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello,',
          style: GoogleFonts.montserrat(
            fontSize: getPropScreenWidth(32),
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        Text(
          'Welcome to InvoTek!',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: getPropScreenWidth(16),
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
        AspectRatio(
          aspectRatio: 16 / 5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
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
                  fontSize: getPropScreenWidth(60),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  height: 1.1,
                ),
              ),
              Text(
                'Total Invoice Created',
                style: GoogleFonts.montserrat(
                  fontSize: getPropScreenWidth(12),
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
