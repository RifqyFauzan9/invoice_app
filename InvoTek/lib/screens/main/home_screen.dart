import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';
import 'package:my_invoice_app/provider/profile_provider.dart';
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
  const HomeScreen({super.key, required this.companyId});
  final String companyId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedPeriod = DateFormat('MMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Invoice>>(
      stream: context.read<InvoiceService>().getAllInvoices(widget.companyId),
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
                onPressed: () {
                  showChooseFormModal();
                }),
          ],
        )
      ],
    );
  }

  Future<dynamic> showChooseFormModal() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            getPropScreenWidth(25),
            getPropScreenWidth(40),
            getPropScreenWidth(25),
            getPropScreenWidth(60),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.read<ProfileProvider>().person?.role == 'user'
                      ? 'Choose Form'
                      : 'View Report',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: InvoiceColor.primary.color),
                ),
                const SizedBox(height: 2),
                Text(
                  context.read<ProfileProvider>().person?.role == 'user'
                      ? 'Choose form you would fill'
                      : 'See report made by your employee',
                ),
                const SizedBox(height: 24),
                if (context.read<ProfileProvider>().person?.role == 'user') ...[
                  ChooseFormWidget(
                    onTap: () {
                      Navigator.pop(context);
                      showSetupModalBottom(context);
                    },
                    leading: Icon(
                      Icons.settings_suggest_rounded,
                      size: 32,
                      color: InvoiceColor.primary.color,
                    ),
                    title: 'Set Up',
                    subtitle:
                        'Set up essentials data for making invoice such as airline, travel, etc.',
                  ),
                  const SizedBox(height: 16),
                  ChooseFormWidget(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, ScreenRoute.transaksi.route);
                    },
                    leading: Icon(
                      Icons.receipt_long_rounded,
                      size: 32,
                      color: InvoiceColor.primary.color,
                    ),
                    title: 'Transaction',
                    subtitle: 'Make invoice from essentials data you set up.',
                  ),
                ] else if (context.read<ProfileProvider>().person?.role ==
                    'admin') ...[
                  ChooseFormWidget(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, ScreenRoute.report.route);
                    },
                    leading: Icon(
                      Icons.bar_chart_rounded,
                      size: 32,
                      color: InvoiceColor.primary.color,
                    ),
                    title: 'Report',
                    subtitle: 'View summary and reports of all invoices.',
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> showSetupModalBottom(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            getPropScreenWidth(25),
            getPropScreenWidth(40),
            getPropScreenWidth(25),
            getPropScreenWidth(60),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Set Up',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: InvoiceColor.primary.color),
                ),
                const SizedBox(height: 2),
                Text('Choose data you would set'),
                const SizedBox(height: 24),
                ChooseFormWidget(
                  onTap: () {
                    Navigator.pushNamed(context, ScreenRoute.travel.route);
                  },
                  leading: Image.asset('assets/images/travel_icon.png'),
                  title: 'Travel Data',
                  subtitle:
                      'Set up travel data such as travel name, travel address, etc.',
                ),
                const SizedBox(height: 16),
                ChooseFormWidget(
                  onTap: () {
                    Navigator.pushNamed(context, ScreenRoute.airlines.route);
                  },
                  leading: Image.asset('assets/images/airlines_icon.png'),
                  title: 'Airline Data',
                  subtitle:
                      'Set up airline data such as airline name, airline code, etc.',
                ),
                const SizedBox(height: 16),
                ChooseFormWidget(
                  onTap: () {
                    Navigator.pushNamed(context, ScreenRoute.bank.route);
                  },
                  leading: Image.asset('assets/images/bank_icon.png'),
                  title: 'Bank Data',
                  subtitle:
                      'Set up bank data such as bank name, bank branch, etc.',
                ),
                const SizedBox(height: 16),
                ChooseFormWidget(
                  onTap: () {
                    Navigator.pushNamed(context, ScreenRoute.item.route);
                  },
                  leading: Image.asset('assets/images/item_icon.png'),
                  title: 'Item Data',
                  subtitle:
                      'Set up item data such as item name, item code, etc.',
                ),
                const SizedBox(height: 16),
                ChooseFormWidget(
                  onTap: () {
                    Navigator.pushNamed(context, ScreenRoute.note.route);
                  },
                  leading: Image.asset('assets/images/note_icon.png'),
                  title: 'Note Data',
                  subtitle:
                      'Set up note data such as note name, note content, etc.',
                ),
              ],
            ),
          ),
        );
      },
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

class ChooseFormWidget extends StatelessWidget {
  const ChooseFormWidget({
    super.key,
    required this.leading,
    required this.onTap,
    required this.title,
    required this.subtitle,
  });

  final VoidCallback onTap;
  final Widget leading;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: InvoiceColor.primary.color,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: leading,
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: InvoiceColor.primary.color),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
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

class _MonthPickerButton extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onChanged;

  const _MonthPickerButton({
    required this.selectedPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showMonthPicker(context),
      child: InputDecorator(
        decoration: _buildInputDecoration(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedPeriod,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: InvoiceColor.primary.color,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      prefixIcon: Icon(
        Icons.date_range,
        color: Theme.of(context).colorScheme.primary,
        size: 14,
      ),
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

  Future<void> _showMonthPicker(BuildContext context) async {
    final selected = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selected != null) {
      final formattedDate = DateFormat('MMM yyyy').format(selected);
      onChanged(formattedDate); // Contoh: "May 2023"
    }
  }
}

// Banner Component
class _HomeBanner extends StatelessWidget {
  final List<Invoice> invoices;
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  const _HomeBanner({
    required this.invoices,
    required this.selectedPeriod,
    required this.onPeriodChanged,
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
        _MonthPickerButton(
          selectedPeriod: selectedPeriod,
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
                          title: const Text('Tidak bisa edit invoice'),
                          content: Text('Invoice ${invoice.status}.'),
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
            ]);
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
    try {
      final selectedDate = DateFormat('MMM yyyy').parse(period);
      return invoices.where((invoice) {
        final date = invoice.dateCreated.toDate();
        return date.month == selectedDate.month &&
            date.year == selectedDate.year;
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
