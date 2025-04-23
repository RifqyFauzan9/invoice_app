import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import '../../model/setup/airline.dart';
import '../../model/setup/bank.dart';
import '../../model/setup/item.dart';
import '../../model/setup/note.dart';
import '../../model/setup/travel.dart';
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
      status: 'Cancel',
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
            SizedBox(height: getPropScreenWidth(16)),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return CustomCard(
                    imageLeading: 'assets/images/travel_icon.png',
                    title: 'Rihlah Wisata',
                    content: Text('IBU DEDE'),
                    trailing: Icon(
                      Icons.query_stats,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                    onCardTapped: () => Navigator.pushNamed(
                      context,
                      ScreenRoute.invoiceScreen.route,
                      arguments: Invoice(
                        program: '20 Hari',
                        flightNotes: 'CGK-JDH',
                        pnrCode: 'FGBN19',
                        dateCreated: DateFormat('dd/MM/yyyy').format(date),
                        proofNumber: generateNoBukti(0),
                        travel: Travel(
                          travelName: 'Rihlah Wisata',
                          contactPerson: 'Eka',
                          address: 'Jalan Batubara',
                          phoneNumber: 089518853275,
                          emailAddress: 'r1fqyf4uz4n@gmail.com',
                        ),
                        bank: [
                          Bank(
                            bankName: 'BCA',
                            accountNumber: 875323456789,
                            branch: 'Asahan',
                          ),
                          Bank(
                            bankName: 'Mandiri',
                            accountNumber: 3456789876543,
                            branch: 'Tangerang Selatan',
                          ),
                        ],
                        airline: Airline(
                          airline: 'Garuda Indonesia',
                          code: 'KDX-0897',
                        ),
                        items: [
                          InvoiceItem(
                            item: 'Infant',
                            itemQuantity: 10,
                            itemPrice: 400000,
                          ),
                          InvoiceItem(
                            item: 'Child',
                            itemQuantity: 10,
                            itemPrice: 400000,
                          ),
                          InvoiceItem(
                            item: 'Adult',
                            itemQuantity: 10,
                            itemPrice: 400000,
                          ),
                        ],
                        note: Note(
                          type: 'Type 2',
                          note: 'jbdasjidbaknmdacbiuzbxciahsdausdhdj',
                        ),
                      ),
                    ),
                  );
                },
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
            height: 1,
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
                  style: GoogleFonts.montserrat(
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
                const SizedBox(height: 4),
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
                    filled: true,
                    fillColor: Color(0xFF2F6F91).withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
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
