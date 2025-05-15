import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_card.dart';
import '../../model/transaction/invoice.dart';

class ListInvoiceScreen extends StatelessWidget {
  const ListInvoiceScreen({super.key, required this.invoices});

  final List<Invoice> invoices;

  @override
  Widget build(BuildContext context) {
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: getPropScreenWidth(72)),
                  Text(
                    'Invoices',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: getPropScreenWidth(20),
                      letterSpacing: 0,
                      color: InvoiceColor.primary.color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getPropScreenWidth(24)),
              SearchBar(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                elevation: WidgetStatePropertyAll(0),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                leading: Icon(Icons.search, size: 32, color: Colors.grey),
                hintText: 'Search...',
                padding: WidgetStatePropertyAll(
                  const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SizedBox(height: getPropScreenWidth(18)),
              Expanded(
                child: invoices.isEmpty
                    ? SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: SizeConfig.screenHeight * 0.2),
                            SvgPicture.asset(
                              'assets/svgs/empty_invoice.svg',
                              width: getPropScreenWidth(200),
                            ),
                            SizedBox(height: getPropScreenWidth(14)),
                            Text(
                              'No Invoice',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'You don\'t have any invoice yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: invoices.length,
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];
                          return CustomCard(
                            imageLeading: 'assets/images/travel_icon.png',
                            title: invoice.id,
                            content: Text(invoice.travel.travelName),
                            onCardTapped: () => Navigator.pushNamed(
                              context,
                              ScreenRoute.invoiceScreen.route,
                              arguments: invoice,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
