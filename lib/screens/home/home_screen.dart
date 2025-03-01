import 'package:flutter/material.dart';
import 'package:my_invoice_app/static/screen_route.dart';

import '../../widgets/main_widgets/custom_icon_button.dart';
import '../../widgets/main_widgets/invoice_card.dart';
import '../../widgets/main_widgets/invoice_status_card.dart';
import '../../widgets/main_widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<InvoiceStatusCard> invoiceStatusCardList = [
    InvoiceStatusCard(
      icon: Icons.access_time_filled,
      total: 84,
      status: 'Pending',
    ),
    InvoiceStatusCard(
      icon: Icons.check_circle,
      total: 60,
      status: 'Lunas',
    ),
    InvoiceStatusCard(
      icon: Icons.cancel,
      total: 250,
      status: 'Cancel',
    ),
    InvoiceStatusCard(
      icon: Icons.timeline,
      total: 190,
      status: 'Cicilan',
    ),
    InvoiceStatusCard(
      icon: Icons.account_balance,
      total: 250,
      status: 'Deposit',
    ),
    InvoiceStatusCard(
      icon: Icons.local_fire_department,
      total: 250,
      status: 'Hangus',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ScreenRoute.profile.route);
                  },
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/foto.png',
                      height: 52,
                      width: 52,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      icon: Icons.notifications_none_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    CustomIconButton(
                      icon: Icons.add,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ScreenRoute.invoiceForm.route,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            const SearchField(),
            const SizedBox(height: 24),
            SectionTitle(title: 'Status', viewAll: false),
            const SizedBox(height: 16),
            SizedBox(
              height: 142,
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
            const SizedBox(height: 25),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return InvoiceCard(
                      onTap: () => Navigator.pushNamed(
                          context, ScreenRoute.invoiceScreen.route));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 38),
          hintText: 'Search...',
        ),
      ),
    );
  }
}
