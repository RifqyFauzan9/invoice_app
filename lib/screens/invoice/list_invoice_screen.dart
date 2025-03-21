import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:my_invoice_app/widgets/main_widgets/invoice_card.dart';

class ListInvoiceScreen extends StatelessWidget {
  const ListInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Invoices',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                        context, ScreenRoute.invoiceScreen.route),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
