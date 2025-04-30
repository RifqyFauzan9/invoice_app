import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedStatus = 'All Status';
  String? selectedPeriod = 'All Period';
  String? selectedAirline = 'All Maskapai';
  String? selectedItem = 'All Item';

  final customerCards = [
    CustomerCard(
      invoiceNumber: 'INV-001',
      status: 'Pending',
      customerName: 'Max',
      date: '31 Jan 2024',
      itemLength: 4,
      total: 'Rp700.500.000',
    ),
    CustomerCard(
      invoiceNumber: 'INV-002',
      status: 'Pending',
      customerName: 'John',
      date: '1 Feb 2024',
      itemLength: 3,
      total: 'Rp500.500.000',
    ),
    CustomerCard(
      invoiceNumber: 'INV-003',
      status: 'Succeed',
      customerName: 'Susi',
      date: '5 March 2024',
      itemLength: 9,
      total: 'Rp1.000.500.000',
    ),
    CustomerCard(
      invoiceNumber: 'INV-004',
      status: 'Issued',
      customerName: 'Xam',
      date: '20 April 2024',
      itemLength: 4,
      total: 'Rp700.000.000',
    ),
  ];

  List<String> statusItems = [
    'All Status',
    'Pending',
    'Processed',
    'Issued',
  ];
  List<String> periodItems = [
    'All Period',
    'Last Month',
    '2 Months Ago',
  ];
  List<String> airlineItems = [
    'All Maskapai',
    'Sriwijaya Air',
    'Garuda',
    'Batik Air',
  ];
  List<String> itemItems = [
    'All Item',
    'Adult',
    'Child',
    'Infant',
  ];

  final fieldLabelStyle = GoogleFonts.montserrat(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: InvoiceColor.primary.color,
  );

  final dropdownTextStyle = GoogleFonts.montserrat(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: Colors.black.withOpacity(0.6),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          color: Theme.of(context).colorScheme.primary,
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Report'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.download),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 6,
                childAspectRatio: 2,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      DropdownButtonFormField(
                        style: dropdownTextStyle,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        value: selectedStatus,
                        items: statusItems.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(
                              status,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {},
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Periode', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      DropdownButtonFormField(
                        style: dropdownTextStyle,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        value: selectedPeriod,
                        items: periodItems.map((period) {
                          return DropdownMenuItem(
                            value: period,
                            child: Text(
                              period,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {},
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Maskapai', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      DropdownButtonFormField(
                        style: dropdownTextStyle,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        value: selectedAirline,
                        items: airlineItems.map((airline) {
                          return DropdownMenuItem(
                            value: airline,
                            child: Text(
                              airline,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {},
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Item', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      DropdownButtonFormField(
                        style: dropdownTextStyle,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        value: selectedItem,
                        items: itemItems.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {},
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Search', style: fieldLabelStyle),
              const SizedBox(height: 4),
              SearchBar(
                hintText: 'Search customer or invoice',
                leading: Icon(
                  Icons.search,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {},
                child: const Text('Search'),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: customerCards.length,
                  itemBuilder: (context, index) {
                    final customerCard = customerCards[index];
                    return customerCard;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  final String invoiceNumber;
  final String status;
  final String customerName;
  final String date;
  final int itemLength;
  final String total;

  const CustomerCard({
    super.key, required this.invoiceNumber, required this.status, required this.customerName, required this.date, required this.itemLength, required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                invoiceNumber,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                status,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customerName,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                date,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Text(
            '$itemLength Items • $total',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
