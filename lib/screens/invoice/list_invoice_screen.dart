import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_card.dart';

import '../../model/setup/airline.dart';
import '../../model/setup/bank.dart';
import '../../model/setup/item.dart';
import '../../model/setup/note.dart';
import '../../model/setup/travel.dart';
import '../../model/transaction/invoice.dart';

class ListInvoiceScreen extends StatelessWidget {
  ListInvoiceScreen({super.key});

  final date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
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
                children: [
                  CustomIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: getPropScreenWidth(75)),
                  Text(
                    'Invoices',
                    style: TextStyle(
                      fontSize: getPropScreenWidth(20),
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getPropScreenWidth(24)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: SearchBar(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                      elevation: WidgetStatePropertyAll(0),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      leading: Icon(Icons.search, size: 32, color: Colors.grey),
                      hintText: 'Search...',
                      padding: WidgetStatePropertyAll(
                        const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.tune,
                          size: 24,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 10,
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
                          flightNotes: 'Dari jeddah ke memek',
                          pnrCode: 'kontol capebnaget gua anjning',
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
                              accountNumber: 567896545678,
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
                              item: 'Child',
                              itemPrice: 100000,
                              itemQuantity: 50,
                            ),
                            InvoiceItem(
                              item: 'Adult',
                              itemPrice: 100000,
                              itemQuantity: 50,
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
      ),
    );
  }

  String generateNoBukti(int lastNumber) {
    final now = date;
    final year = now.year % 100; // ambil dua digit terakhir tahun
    final month = now.month.toString().padLeft(2, '0'); // misal 04
    final sequence = (lastNumber + 1).toString().padLeft(5, '0'); // misal 00001

    return 'SO-$year$month-$sequence'; // hasil: SO-2504-00001
  }
}
