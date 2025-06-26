import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/transaction/invoice.dart';
import '../../static/screen_route.dart';
import '../../static/size_config.dart';
import '../../style/colors/invoice_color.dart';
import '../../widgets/main_widgets/custom_card.dart';
import '../../widgets/main_widgets/custom_icon_button.dart';

class ListInvoiceScreen extends StatefulWidget {
  const ListInvoiceScreen({super.key, required this.invoices});

  final List<Invoice> invoices;

  @override
  State<ListInvoiceScreen> createState() => _ListInvoiceScreenState();
}

class _ListInvoiceScreenState extends State<ListInvoiceScreen> {
  List<Invoice> filteredInvoices = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredInvoices = widget.invoices;
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredInvoices = widget.invoices.where((invoice) {
        final invoiceNumber = invoice.id.toLowerCase();
        final travelName = invoice.travel.travelName.toLowerCase();
        return invoiceNumber.contains(searchQuery) ||
            travelName.contains(searchQuery);
      }).toList();
    });
  }

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
                      color: InvoiceColor.primary.color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getPropScreenWidth(24)),
              SearchBar(
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                elevation: const WidgetStatePropertyAll(0),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                leading: const Icon(Icons.search, size: 32, color: Colors.grey),
                hintText: 'Search by invoice number or travel name...',
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: onSearch,
              ),
              SizedBox(height: getPropScreenWidth(18)),
              Expanded(
                child: filteredInvoices.isEmpty
                    ? _buildEmptyContent()
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: filteredInvoices.length,
                        itemBuilder: (context, index) {
                          final invoice = filteredInvoices[index];
                          return CustomCard(
                            imageLeading: 'assets/images/travel_icon.png',
                            title: invoice.id,
                            content: Text(invoice.travel.travelName),
                            onCardTapped: () => Navigator.pushNamed(
                              context,
                              ScreenRoute.invoiceScreen.route,
                              arguments: invoice,
                            ),
                            trailing: PopupMenuButton(
                              iconColor: InvoiceColor.primary.color,
                              itemBuilder: (context) => [
                                if (invoice.status != 'Booking' && invoice.status != 'Lunas')
                                  PopupMenuItem(
                                    child: const Text('Edit Invoice'),
                                    onTap: () {
                                      Future.delayed(Duration.zero, () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Tidak bisa edit invoice'),
                                            content: Text('Invoice ${invoice.status}'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                  )
                                else
                                  PopupMenuItem(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        ScreenRoute.updateInvoice.route,
                                        arguments: invoice,
                                      );
                                    },
                                    child: Text('Edit Invoice'),
                                  ),
                              ],
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

  Widget _buildEmptyContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            'You don\'t have any invoices yet.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
