import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/model/setup/item.dart';
import 'package:my_invoice_app/services/firebase_firestore_service.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/main_widgets/custom_icon_button.dart';
import '../../../../widgets/main_widgets/custom_card.dart';

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
                    Navigator.pushNamed(
                      context,
                      ScreenRoute.itemForm.route,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            SearchBar(
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
            Expanded(
                child: StreamProvider<List<Item>>(
              create: (context) =>
                  context.read<FirebaseFirestoreService>().getItem(),
              initialData: const <Item>[],
              catchError: (context, error) {
                debugPrint('Error: $error');
                return [];
              },
              builder: (context, child) {
                final items = Provider.of<List<Item>>(context);
                return items.isEmpty
                    ? const Center(
                        child: Text('Empty List'),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return CustomCard(
                            imageLeading: 'assets/images/item_icon.png',
                            title: item.itemName,
                            content: Text(item.itemCode),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.more_vert,
                                size: 32,
                              ),
                            ),
                          );
                        },
                      );
              },
            ))
          ],
        ),
      ),
    );
  }
}
