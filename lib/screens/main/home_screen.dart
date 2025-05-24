import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';
import 'package:my_invoice_app/services/invoice_service.dart';
import 'package:my_invoice_app/static/invoice_status.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/widgets/main_widgets/invoice_status_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../style/colors/invoice_color.dart';
import '../../widgets/main_widgets/custom_icon_button.dart';
import '../../widgets/main_widgets/custom_card.dart';
import '../../widgets/main_widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.uid});

  final String? uid;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedPeriod = 'Bulan Ini';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Invoice>>(
      stream: context.read<InvoiceService>().getAllInvoices(widget.uid!),
      initialData: const <Invoice>[],
      builder: (context, snapshot) {
        final invoices = snapshot.data ?? [];
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.fromLTRB(
              getPropScreenWidth(25),
              getPropScreenWidth(60),
              getPropScreenWidth(25),
              0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
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
                          SizedBox(width: getPropScreenWidth(8)),
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
                  SizedBox(height: getPropScreenWidth(22)),
                  buildHomeBanner(context, invoices),
                  SizedBox(height: getPropScreenWidth(14)),
                  SectionTitle(title: 'Status', viewAll: false),
                  SizedBox(height: getPropScreenWidth(14)),
                  !snapshot.hasData
                      ? shimmerStatusList()
                      : statusList(invoices, context),
                  SizedBox(height: getPropScreenWidth(22)),
                  SectionTitle(
                    title: 'Recent Invoice',
                    viewAll: true,
                    onTap: () => Navigator.pushNamed(
                      context,
                      ScreenRoute.listInvoice.route,
                      arguments: invoices,
                    ),
                  ),
                  SizedBox(height: getPropScreenWidth(14)),
                  Expanded(
                    child: !snapshot.hasData
                        ? shimmerRecentList()
                        : actualRecentList(invoices),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget shimmerStatusList() {
    return SizedBox(
      height: SizeConfig.screenHeight * 0.16,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) => buildStatusCardShimmer(context),
      ),
    );
  }

  Widget statusList(List<Invoice> invoices, BuildContext context) {
    final statusCounts = InvoiceStatus.values.fold<Map<InvoiceStatus, int>>(
      {},
      (map, status) {
        map[status] = 0;
        return map;
      },
    );

    for (var invoice in invoices) {
      final status = InvoiceStatusExt.fromString(invoice.status);
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }

    final cards = InvoiceStatus.values.map((status) {
      return InvoiceStatusCard(
        onTap: () => Navigator.pushNamed(
          context,
          ScreenRoute.statusScreen.route,
          arguments: status.label,
        ),
        icon: status.iconPath,
        total: statusCounts[status] ?? 0,
        status: status.label,
      );
    }).toList();

    return SizedBox(
      height: SizeConfig.screenHeight * 0.16,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: cards,
      ),
    );
  }

  Widget shimmerRecentList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 3,
      itemBuilder: (context, index) => buildCustomCardShimmer(context),
    );
  }

  Widget actualRecentList(List<Invoice> invoices) {
    if (invoices.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.035),
          SvgPicture.asset(
            'assets/svgs/empty_invoice.svg',
            width: SizeConfig.screenWidth * 0.45,
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
            'You don\'t have any invoice yet.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: invoices.take(5).length,
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
          trailing: PopupMenuButton(
            iconColor: InvoiceColor.primary.color,
            itemBuilder: (context) => [
              if (invoice.status == 'Booking' || invoice.status == 'Lunas')
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
              PopupMenuItem(
                  onTap: () async {
                    final service = context.read<InvoiceService>();
                    final navigator = Navigator.of(context);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Hapus ${invoice.id}?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await service.deleteInvoice(
                                  uid: widget.uid!,
                                  invoiceId: invoice.id,
                                );
                                navigator.pop();
                              },
                              child: Text(
                                'Hapus',
                                style:
                                    TextStyle(color: InvoiceColor.error.color),
                              ),
                            ),
                            TextButton(
                              onPressed: () => navigator.pop(),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                    color: InvoiceColor.primary.color),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Hapus Invoice')),
            ],
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

  Widget buildCustomCardShimmer(BuildContext context) {
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

  Widget buildStatusCardShimmer(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: getPropScreenWidth(116),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5),
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                highlightColor: Colors.blueGrey,
                baseColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: getPropScreenWidth(35),
                  height: getPropScreenWidth(35),
                ),
              ),
              Shimmer.fromColors(
                highlightColor: Colors.blueGrey,
                baseColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: getPropScreenWidth(10),
                  height: getPropScreenWidth(25),
                ),
              ),
              Shimmer.fromColors(
                highlightColor: Colors.blueGrey,
                baseColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: getPropScreenWidth(40),
                  height: getPropScreenWidth(10),
                ),
              ),
            ],
          ),
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
          ),
        ),
        Text(
          'Welcome to InvoTek!',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: getPropScreenWidth(16),
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget buildHomeBanner(BuildContext context, List<Invoice> invoices) {
    return StatefulBuilder(
      builder: (context, setState) {
        int getTotalInvoice(String period) {
          final now = DateTime.now();
          final filtered = invoices.where((invoice) {
            final date = invoice.dateCreated.toDate();
            if (period == 'Bulan Ini') {
              return date.month == now.month && date.year == now.year;
            } else if (period == 'Bulan Lalu') {
              final lastMonth = DateTime(now.year, now.month - 1);
              return date.month == lastMonth.month &&
                  date.year == lastMonth.year;
            } else if (period == '2 Bulan Lalu') {
              final twoMonthsAgo = DateTime(now.year, now.month - 2);
              return date.month == twoMonthsAgo.month &&
                  date.year == twoMonthsAgo.year;
            }

            return false;
          }).toList();

          return filtered.length;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      style: TextStyle(
                        fontSize: getPropScreenWidth(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      getTotalInvoice(selectedPeriod).toString(),
                      style: GoogleFonts.montserrat(
                        height: 1,
                        fontWeight: FontWeight.bold,
                        fontSize: getPropScreenWidth(60),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedPeriod,
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: InvoiceColor.primary.color,
                      ),
                      iconSize: 13,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        prefixIcon: Icon(
                          Icons.date_range,
                          color: Theme.of(context).colorScheme.primary,
                          size: 14,
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 40),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      items: ['Bulan Ini', 'Bulan Lalu', '2 Bulan Lalu']
                          .map((date) {
                        return DropdownMenuItem(
                          value: date,
                          child: Text(date),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPeriod = value;
                          });
                        } else {
                          debugPrint('Total invoice created value was null!');
                        }
                      },
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
      },
    );
  }
}
