import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/services/invoice_service.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/transaction/invoice.dart';
import '../../static/screen_route.dart';
import '../../widgets/main_widgets/custom_card.dart';
import '../../widgets/main_widgets/custom_icon_button.dart';

class StatusInvoiceScreen extends StatelessWidget {
  const StatusInvoiceScreen({super.key, required this.status});

  final String status;

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '$status Invoices',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: getPropScreenWidth(20),
                      letterSpacing: 0,
                      color: InvoiceColor.primary.color,
                    ),
                  ),
                  SizedBox(width: getPropScreenWidth(30)),
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
                hintText: 'Search ${status.toLowerCase()} invoices...',
                padding: WidgetStatePropertyAll(
                  const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SizedBox(height: getPropScreenWidth(18)),
              Expanded(
                child: StreamBuilder<List<Invoice>>(
                  stream: context.read<InvoiceService>().getInvoiceByStatus(
                        status,
                        context.read<FirebaseAuthProvider>().profile!.uid!,
                      ),
                  initialData: const <Invoice>[],
                  builder: (context, snapshot) {
                    final invoices = snapshot.data ?? [];
                    return !snapshot.hasData
                        ? shimmerStatusList()
                        : actualInvoiceList(invoices);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget shimmerStatusList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 3,
      itemBuilder: (context, index) => buildCustomCardShimmer(context),
    );
  }

  Widget actualInvoiceList(List<Invoice> invoices) {
    if (invoices.isEmpty) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.2),
            SvgPicture.asset(
              'assets/svgs/empty_invoice.svg',
              width: SizeConfig.screenWidth * 0.55,
            ),
            SizedBox(height: getPropScreenWidth(10)),
            Text(
              'No Invoice',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: getPropScreenWidth(20),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'You don\'t have any ${status.toLowerCase()} invoice yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return CustomCard(
          imageLeading: 'assets/images/travel_icon.png',
          title: invoice.id,
          content: Text(
            invoice.travel.travelName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          onCardTapped: () => Navigator.pushNamed(
            context,
            ScreenRoute.invoiceScreen.route,
            arguments: invoice,
          ),
        );
      },
    );
  }

  Card buildCustomCardShimmer(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: EdgeInsets.all(getPropScreenWidth(16)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              highlightColor: Colors.blueGrey,
              baseColor: Theme.of(context).colorScheme.surface,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                height: getPropScreenWidth(60),
                width: getPropScreenWidth(60),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.surface,
                    highlightColor: Colors.blueGrey,
                    child: Container(
                      width: getPropScreenWidth(100),
                      height: getPropScreenWidth(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: getPropScreenWidth(6)),
                  Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.surface,
                    highlightColor: Colors.blueGrey,
                    child: Container(
                      width: getPropScreenWidth(60),
                      height: getPropScreenWidth(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
