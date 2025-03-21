import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/static/screen_route.dart';

import '../../../../widgets/main_widgets/custom_icon_button.dart';
import '../../../../widgets/main_widgets/invoice_card.dart';

class DataItemScreen extends StatelessWidget {
  const DataItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    'Data Item',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                CustomIconButton(
                  icon: Icons.add,
                  onPressed: () {
                    Navigator.pushNamed(context, ScreenRoute.itemForm.route,);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            SearchBar(
              backgroundColor: WidgetStatePropertyAll(
                  Colors.white
              ),
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
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => InvoiceCard(
                  imageLeading: 'assets/images/item_icon.png',
                  title: 'Adult',
                  subtitle: 'Dewasa',
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      size: 32,
                    ),
                  ),
                ),
                itemCount: 3,
              ),
            )
          ],
        ),
      ),
    );
  }
}