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
  String _selectedPeriod = 'Bulan Ini';
  final _periodOptions = const ['Bulan Ini', 'Bulan Lalu', '2 Bulan Lalu'];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Invoice>>(
      stream: context.read<InvoiceService>().getAllInvoices(widget.uid!),
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
            child: _buildMainContent(context, invoices, snapshot.hasData),
          ),
        );
      },
    );
  }

  Widget _buildMainContent(
      BuildContext context, List<Invoice> invoices, bool hasData) {
    return Column(
      children: [
        _buildHeaderSection(),
        SizedBox(height: getPropScreenWidth(22)),
        _HomeBanner(
          invoices: invoices,
          selectedPeriod: _selectedPeriod,
          onPeriodChanged: (period) => setState(() => _selectedPeriod = period),
          periodOptions: _periodOptions,
        ),
        SizedBox(height: getPropScreenWidth(14)),
        SectionTitle(title: 'Status', viewAll: false),
        SizedBox(height: getPropScreenWidth(14)),
        hasData ? _StatusList(invoices: invoices) : const _ShimmerStatusList(),
        SizedBox(height: getPropScreenWidth(22)),
        SectionTitle(
          title: 'Recent Invoice',
          viewAll: true,
          onTap: () => _navigateToInvoiceList(context, invoices),
        ),
        SizedBox(height: getPropScreenWidth(14)),
        Expanded(
          child: hasData
              ? _RecentInvoiceList(
                  invoices: invoices, selectedPeriod: _selectedPeriod)
              : const _ShimmerRecentList(),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _GreetingHeader(),
        Row(
          children: [
            CustomIconButton(
              icon: CupertinoIcons.person_fill,
              onPressed: () =>
                  Navigator.pushNamed(context, ScreenRoute.profile.route),
            ),
            SizedBox(width: getPropScreenWidth(8)),
            CustomIconButton(
              icon: CupertinoIcons.add,
              onPressed: () =>
                  Navigator.pushNamed(context, ScreenRoute.chooseForm.route),
            ),
          ],
        )
      ],
    );
  }

  void _navigateToInvoiceList(BuildContext context, List<Invoice> invoices) {
    Navigator.pushNamed(
      context,
      ScreenRoute.listInvoice.route,
      arguments: invoices,
    );
  }
}

// Header Components
class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello,',
          style: GoogleFonts.montserrat(
            fontSize: getPropScreenWidth(32),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Welcome to InvoTek!',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: getPropScreenWidth(16),
          ),
        ),
      ],
    );
  }
}

// Banner Component
class _HomeBanner extends StatelessWidget {
  final List<Invoice> invoices;
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;
  final List<String> periodOptions;

  const _HomeBanner({
    required this.invoices,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.periodOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(child: _buildBannerContent(context)),
          SizedBox(width: getPropScreenWidth(16)),
          Expanded(child: _buildBannerImage()),
        ],
      ),
    );
  }

  Widget _buildBannerContent(BuildContext context) {
    return Column(
      children: [
        Text(
          'Total Invoice Created',
          style: TextStyle(
            fontSize: getPropScreenWidth(12),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          _calculateTotalInvoices().toString(),
          style: GoogleFonts.montserrat(
            height: 1,
            fontWeight: FontWeight.bold,
            fontSize: getPropScreenWidth(60),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: getPropScreenWidth(6)),
        _PeriodDropdown(
          selectedPeriod: selectedPeriod,
          periodOptions: periodOptions,
          onChanged: onPeriodChanged,
        ),
      ],
    );
  }

  Widget _buildBannerImage() {
    return SvgPicture.asset(
      'assets/svgs/banner_image.svg',
      width: getPropScreenWidth(130),
    );
  }

  int _calculateTotalInvoices() {
    return InvoiceUtils.filterInvoicesByPeriod(invoices, selectedPeriod).length;
  }
}

class _PeriodDropdown extends StatelessWidget {
  final String selectedPeriod;
  final List<String> periodOptions;
  final ValueChanged<String> onChanged;

  const _PeriodDropdown({
    required this.selectedPeriod,
    required this.periodOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedPeriod,
      icon: Icon(Icons.keyboard_arrow_down_outlined,
          color: InvoiceColor.primary.color),
      iconSize: 13,
      style: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.primary,
      ),
      decoration: _buildDropdownDecoration(context),
      items: periodOptions.map(_buildDropdownMenuItem).toList(),
      onChanged: (value) => value != null ? onChanged(value) : null,
    );
  }

  InputDecoration _buildDropdownDecoration(BuildContext context) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      prefixIcon: Icon(Icons.date_range,
          color: Theme.of(context).colorScheme.primary, size: 14),
      prefixIconConstraints: const BoxConstraints(minWidth: 40),
      border: _inputBorder(context),
      enabledBorder: _inputBorder(context),
      focusedBorder: _inputBorder(context),
    );
  }

  OutlineInputBorder _inputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    );
  }

  DropdownMenuItem<String> _buildDropdownMenuItem(String value) {
    return DropdownMenuItem(
      value: value,
      child: Text(value),
    );
  }
}

// Status Components
class _StatusList extends StatelessWidget {
  final List<Invoice> invoices;

  const _StatusList({required this.invoices});

  @override
  Widget build(BuildContext context) {
    final statusCounts = InvoiceUtils.calculateStatusCounts(invoices);

    return SizedBox(
      height: SizeConfig.screenHeight * 0.16,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: InvoiceStatus.values
            .map((status) =>
                _StatusCard(status: status, count: statusCounts[status] ?? 0))
            .toList(),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final InvoiceStatus status;
  final int count;

  const _StatusCard({required this.status, required this.count});

  @override
  Widget build(BuildContext context) {
    return InvoiceStatusCard(
      onTap: () => _navigateToStatusScreen(context),
      icon: status.iconPath,
      total: count,
      status: status.label,
    );
  }

  void _navigateToStatusScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      ScreenRoute.statusScreen.route,
      arguments: status.label,
    );
  }
}

// Recent Invoices Components
class _RecentInvoiceList extends StatelessWidget {
  final List<Invoice> invoices;
  final String selectedPeriod;

  const _RecentInvoiceList({
    required this.invoices,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final filteredInvoices =
        InvoiceUtils.filterInvoicesByPeriod(invoices, selectedPeriod);

    if (filteredInvoices.isEmpty) {
      return const _EmptyInvoiceState();
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: filteredInvoices.take(5).length,
      itemBuilder: (context, index) =>
          _RecentInvoiceItem(invoice: filteredInvoices[index]),
    );
  }
}

class _RecentInvoiceItem extends StatelessWidget {
  final Invoice invoice;

  const _RecentInvoiceItem({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      imageLeading: 'assets/images/travel_icon.png',
      title: invoice.id,
      content: Text(
        invoice.travel.travelName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      trailing: _buildPopupMenu(context),
      onCardTapped: () => _navigateToInvoiceDetail(context),
    );
  }

  Widget? _buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
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
                    title: const Text('Tidak Bisa Diedit'),
                    content: const Text('Invoice tidak bisa diedit karena statusnya bukan Booking atau Lunas.'),
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
            onTap: () => _navigateToUpdateInvoice(context),
            child: const Text('Edit Invoice'),
          ),
      ]

    );
  }

  void _navigateToInvoiceDetail(BuildContext context) {
    Navigator.pushNamed(
      context,
      ScreenRoute.invoiceScreen.route,
      arguments: invoice,
    );
  }

  void _navigateToUpdateInvoice(BuildContext context) {
    Navigator.pushNamed(
      context,
      ScreenRoute.updateInvoice.route,
      arguments: invoice,
    );
  }
}

// Empty State Component
class _EmptyInvoiceState extends StatelessWidget {
  const _EmptyInvoiceState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.035),
        SvgPicture.asset(
          'assets/svgs/empty_invoice.svg',
          width: SizeConfig.screenWidth * 0.45,
        ),
        SizedBox(height: getPropScreenWidth(10)),
        Text(
          'No Invoice',
          style: GoogleFonts.montserrat(
            fontSize: getPropScreenWidth(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'You don\'t have any invoice yet.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Shimmer Components
class _ShimmerStatusList extends StatelessWidget {
  const _ShimmerStatusList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight * 0.16,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) => const _ShimmerStatusCard(),
      ),
    );
  }
}

class _ShimmerRecentList extends StatelessWidget {
  const _ShimmerRecentList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 3,
      itemBuilder: (context, index) => const _ShimmerRecentItem(),
    );
  }
}

class _ShimmerStatusCard extends StatelessWidget {
  const _ShimmerStatusCard();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: getPropScreenWidth(116)),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5),
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.surface,
            highlightColor: Colors.blueGrey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: getPropScreenWidth(35),
                  height: getPropScreenWidth(35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  width: getPropScreenWidth(10),
                  height: getPropScreenWidth(25),
                  color: Colors.white,
                ),
                Container(
                  width: getPropScreenWidth(40),
                  height: getPropScreenWidth(10),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerRecentItem extends StatelessWidget {
  const _ShimmerRecentItem();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: EdgeInsets.all(getPropScreenWidth(16)),
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Colors.blueGrey,
          child: Row(
            children: [
              Container(
                width: getPropScreenWidth(60),
                height: getPropScreenWidth(60),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: getPropScreenWidth(100),
                      height: getPropScreenWidth(10),
                      color: Colors.white,
                    ),
                    SizedBox(height: getPropScreenWidth(6)),
                    Container(
                      width: getPropScreenWidth(60),
                      height: getPropScreenWidth(10),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Utility Class
class InvoiceUtils {
  static Map<InvoiceStatus, int> calculateStatusCounts(List<Invoice> invoices) {
    return InvoiceStatus.values.fold<Map<InvoiceStatus, int>>(
      {},
      (map, status) {
        map[status] = invoices
            .where((i) => InvoiceStatusExt.fromString(i.status) == status)
            .length;
        return map;
      },
    );
  }

  static List<Invoice> filterInvoicesByPeriod(
      List<Invoice> invoices, String period) {
    final now = DateTime.now();
    return invoices.where((invoice) {
      final date = invoice.dateCreated.toDate();
      switch (period) {
        case 'Bulan Lalu':
          final lastMonth = DateTime(now.year, now.month - 1);
          return date.month == lastMonth.month && date.year == lastMonth.year;
        case '2 Bulan Lalu':
          final twoMonthsAgo = DateTime(now.year, now.month - 2);
          return date.month == twoMonthsAgo.month &&
              date.year == twoMonthsAgo.year;
        default: // Bulan Ini
          return date.month == now.month && date.year == now.year;
      }
    }).toList();
  }
}
