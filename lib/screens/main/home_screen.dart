import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';
import 'package:my_invoice_app/services/firebase_firestore_service.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:provider/provider.dart';
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
      status: 'Processed',
    ),
    InvoiceStatusCard(
      icon: 'assets/images/cancel_icon.png',
      total: 250,
      status: 'Issued',
    ),
  ];

  final date = DateTime.now();

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
                    SizedBox(
                      width: getPropScreenWidth(8),
                    ),
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
              height: 140,
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
            const SizedBox(height: 16),
            Expanded(
              child: StreamProvider<List<Invoice>>(
                create: (context) =>
                    context.read<FirebaseFirestoreService>().getInvoice(),
                initialData: const <Invoice>[],
                catchError: (context, error) {
                  debugPrint('Error: $error');
                  return [];
                },
                child: Builder(
                  builder: (context) {
                    final invoices = context.watch<List<Invoice>>();
                    final recentInvoice = invoices.take(5).toList();
                    return recentInvoice.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: SizeConfig.screenHeight * 0.05),
                              Image.asset('assets/images/empty.png'),
                              const SizedBox(height: 16),
                              Text(
                                'Ayo mulai buat Invoice!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: recentInvoice.length,
                            itemBuilder: (context, index) {
                              final invoice = recentInvoice[index];
                              return CustomCard(
                                imageLeading: 'assets/images/travel_icon.png',
                                title: invoice.travel.travelName,
                                content: Text(
                                  invoice.travel.contactPerson,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                onCardTapped: () => Navigator.pushNamed(
                                  context,
                                  ScreenRoute.invoiceScreen.route,
                                  arguments: invoice,
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            )
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
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: getPropScreenWidth(16),
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  String generateNoBukti(int lastNumber) {
    final now = date;
    final year = now.year % 100; // ambil dua digit terakhir tahun
    final month = now.month.toString().padLeft(2, '0'); // misal 04
    final sequence = (lastNumber + 1).toString().padLeft(4, '0'); // misal 00001

    return 'SO-$year$month-$sequence'; // hasil: SO-2504-00001
  }

  Container buildHomeBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'Total Invoice Created',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '200',
                  style: GoogleFonts.montserrat(
                    height: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: getPropScreenWidth(60),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField(
                  value: 'Bulan Ini',
                  icon: Icon(Icons.keyboard_arrow_down_outlined),
                  iconSize: 13,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    prefixIcon: Icon(
                      Icons.date_range,
                      color: Theme.of(context).colorScheme.primary,
                      size: 14,
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  items:
                      ['Bulan Ini', 'Bulan Lalu', '2 Bulan Lalu'].map((date) {
                    return DropdownMenuItem(
                      value: date,
                      child: Text(date),
                    );
                  }).toList(),
                  onChanged: (value) {},
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SvgPicture.asset(
              'assets/svgs/banner_image.svg',
              width: getPropScreenWidth(130),
            ),
          ),
        ],
      ),
    );
  }
}
