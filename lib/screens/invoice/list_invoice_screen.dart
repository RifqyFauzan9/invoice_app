import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/services/firebase_firestore_service.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_card.dart';
import 'package:provider/provider.dart';
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
                  SizedBox(width: getPropScreenWidth(70)),
                  Text(
                    'Invoices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getPropScreenWidth(20),
                      letterSpacing: 0,
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
              const SizedBox(height: 24),
              Expanded(
                child: StreamProvider<List<Invoice>>(
                  create: (context) =>
                      context.read<FirebaseFirestoreService>().getInvoice(),
                  initialData: const <Invoice>[],
                  catchError: (context, error) {
                    debugPrint('Error: $error');
                    return [];
                  },
                  builder: (context, child) {
                    final invoices = Provider.of<List<Invoice>>(context);
                    return invoices.isEmpty
                        ? SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: SizeConfig.screenHeight * 0.2),
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
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: invoices.length,
                            itemBuilder: (context, index) {
                              final invoice = invoices[index];
                              return CustomCard(
                                imageLeading: 'assets/images/travel_icon.png',
                                title: invoice.travel.travelName,
                                content: Text(invoice.travel.contactPerson),
                                trailing: Icon(
                                  Icons.query_stats,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 30,
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
