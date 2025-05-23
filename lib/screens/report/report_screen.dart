import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:excel/excel.dart' as exc;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';
import 'package:my_invoice_app/provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/services/airline_service.dart';
import 'package:my_invoice_app/services/invoice_service.dart';
import 'package:my_invoice_app/services/item_service.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../widgets/main_widgets/custom_icon_button.dart';

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
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _searchController = TextEditingController();
  final _departureController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  DateTime? _departure;
  Stream<List<Invoice>>? filteredInvoices;
  List<Invoice>? invoices;

  final ScrollController verticalScroll = ScrollController();
  final ScrollController verticalScrollForNo = ScrollController();
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController horizontalScrollForHeader = ScrollController();

  final headerColor = const Color(0xFF2E6D89);

  final columns = [
    'No',
    'Inv No',
    'Inv Date',
    'Customer',
    'Status',
    'Qty',
    'Total Amount'
  ];

  @override
  void initState() {
    super.initState();
    verticalScroll.addListener(() {
      if (verticalScroll.offset != verticalScrollForNo.offset) {
        verticalScrollForNo.jumpTo(verticalScroll.offset);
      }
    });
    verticalScrollForNo.addListener(() {
      if (verticalScroll.offset != verticalScrollForNo.offset) {
        verticalScroll.jumpTo(verticalScrollForNo.offset);
      }
    });
    horizontalScroll.addListener(() {
      if (horizontalScroll.offset != horizontalScrollForHeader.offset) {
        horizontalScrollForHeader.jumpTo(horizontalScroll.offset);
      }
    });
    horizontalScrollForHeader.addListener(() {
      if (horizontalScroll.offset != horizontalScrollForHeader.offset) {
        horizontalScroll.jumpTo(horizontalScrollForHeader.offset);
      }
    });

    _loadAirlines(context.read<FirebaseAuthProvider>().profile!.uid!);
    _loadItems(context.read<FirebaseAuthProvider>().profile!.uid!);
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    _searchController.dispose();
    _departureController.dispose();
    verticalScroll.dispose();
    verticalScrollForNo.dispose();
    horizontalScroll.dispose();
    horizontalScrollForHeader.dispose();
    super.dispose();
  }

  void exportExcel(List<Invoice> invoices) async {
    final excel = exc.Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, 'Sales Invoice');

    final sheet = excel['Sales Invoice'];

    // Header
    final headers = [
      'Trans. No.',
      'Trans. Date',
      'Customer',
      'Status',
      'Total Qty',
      'Total Amount'
    ];

    sheet.setColumnWidth(0, 20);
    sheet.setColumnWidth(1, 20);
    sheet.setColumnWidth(2, 30);
    sheet.setColumnWidth(3, 15);
    sheet.setColumnWidth(4, 15);
    sheet.setColumnWidth(5, 17);

    exc.CellStyle headerStyle = exc.CellStyle(bold: true);

    for (int col = 0; col < headers.length; col++) {
      var cell = sheet
          .cell(exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      cell.value = exc.TextCellValue(headers[col]);
      cell.cellStyle = headerStyle;
    }

    // Isi data dari invoices
    for (int i = 0; i < invoices.length; i++) {
      final invoice = invoices[i];
      sheet
          .cell(exc.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
          .value = exc.TextCellValue(invoice.id);
      sheet
          .cell(exc.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
          .value = exc.TextCellValue(DateFormat(
              'dd/MM/yyyy H:mm')
          .format(invoice.dateCreated.toDate()));
      sheet
          .cell(exc.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
          .value = exc.TextCellValue(invoice.travel.travelName.toUpperCase());
      sheet
          .cell(exc.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1))
          .value = exc.TextCellValue(invoice.status!.toUpperCase());
      sheet
          .cell(exc.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1))
          .value = exc.DoubleCellValue(invoice.items.length.toDouble());
      final totalAmountCell = sheet.cell(
          exc.CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i + 1));

      totalAmountCell.value = exc.TextCellValue(
        NumberFormat.currency(
          locale: 'id_ID',
          decimalDigits: 0,
          symbol: '',
        ).format(
          invoice.items.fold<int>(
            0,
            (sum, item) => sum + (item.itemPrice * item.quantity),
          ),
        ),
      );
      totalAmountCell.cellStyle =
          exc.CellStyle(horizontalAlign: exc.HorizontalAlign.Right);
    }

    // Simpan file
    final fileBytes = excel.save();
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, 'Sales_Invoice.xlsx');

    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    await OpenFile.open(filePath);
  }

  DateTimeRange? getSelectedPeriod() {
    final start = _fromDate;
    final end = _toDate;

    if (start != null && end != null) {
      if (start.isAfter(end)) return null;
      return DateTimeRange(start: start, end: end);
    }
    return null;
  }

  void updateFilter() {
    final service = context.read<InvoiceService>();
    final uid = context.read<FirebaseAuthProvider>().profile!.uid!;
    String searchQuery = _searchController.text.toLowerCase();
    setState(() {
      filteredInvoices = service.getFilteredInvoices(
        uid: uid,
        airline: selectedAirline,
        status: selectedStatus,
        period: getSelectedPeriod(),
        item: selectedItem,
        searchQuery: searchQuery,
        departure: _departure,
      );
    });
  }

  List<String> statusItems = [
    'All Status',
    'Booking',
    'Lunas',
    'Cancel',
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

  void _loadAirlines(String uid) {
    context.read<AirlineService>().getAirline(uid).listen((airlines) {
      setState(() {
        airlineItems.clear();
        airlineItems.add('All Maskapai');
      });
      if (airlines.isNotEmpty) {
        for (var airline in airlines) {
          setState(() {
            airlineItems.add(airline.airlineName);
          });
        }
      }
    });
  }

  void _loadItems(String uid) {
    context.read<ItemService>().getItem(uid).listen((items) {
      setState(() {
        itemItems.clear();
        itemItems.add('All Item');
      });
      if (items.isNotEmpty) {
        for (var item in items) {
          setState(() {
            itemItems.add(item.itemName);
          });
        }
      }
    });
  }

  final TextStyle fieldLabelStyle = GoogleFonts.montserrat(
    fontWeight: FontWeight.bold,
    fontSize: getPropScreenWidth(14),
    color: InvoiceColor.primary.color,
  );

  final TextStyle dropdownTextStyle = GoogleFonts.montserrat(
    fontWeight: FontWeight.w500,
    fontSize: getPropScreenWidth(12),
    color: Colors.black.withOpacity(0.6),
  );

  void _showFlushbar(String message, Color bgColor, IconData icon) {
    Flushbar(
      message: message,
      messageColor: Theme.of(context).colorScheme.onPrimary,
      messageSize: 12,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: bgColor,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                      'Report',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: getPropScreenWidth(20),
                        letterSpacing: 0,
                        color: InvoiceColor.primary.color,
                      ),
                    ),
                    CustomIconButton(
                        icon: Icons.download,
                        onPressed: () {
                          if (invoices == null || invoices!.isEmpty) {
                            _showFlushbar(
                              'No invoices to display',
                              InvoiceColor.error.color,
                              Icons.error_outline,
                            );
                          } else {
                            exportExcel(invoices!);
                          }
                        })
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Row(
                  children: [
                    Expanded(
                      child: Column(
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
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Periode', style: fieldLabelStyle),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _fromDateController,
                                  decoration: InputDecoration(hintText: 'From'),
                                  readOnly: true,
                                  onTap: () async {
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2050),
                                    );
                                    if (pickedDate != null) {
                                      _fromDateController.text =
                                          DateFormat('dd-MMM-yy')
                                              .format(pickedDate);
                                      _fromDate = pickedDate;
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: TextFormField(
                                  controller: _toDateController,
                                  decoration: InputDecoration(hintText: 'To'),
                                  readOnly: true,
                                  onTap: () async {
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2050),
                                    );
                                    if (pickedDate != null) {
                                      _toDateController.text =
                                          DateFormat('dd-MMM-yy')
                                              .format(pickedDate);
                                      _toDate = pickedDate;
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getPropScreenWidth(6)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Departure', style: fieldLabelStyle),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _departureController,
                      decoration: InputDecoration(
                        hintText: 'All Departure',
                      ),
                      readOnly: true,
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2050),
                        );
                        if (pickedDate != null) {
                          _departureController.text =
                              DateFormat('d MMMM yyyy').format(pickedDate);
                          _departure = pickedDate;
                        }
                      },
                    )
                  ],
                ),
                SizedBox(height: getPropScreenWidth(6)),
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
                      onChanged: (value) {
                        setState(() {
                          selectedAirline = value;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: getPropScreenWidth(6)),
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
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: getPropScreenWidth(6)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Search', style: fieldLabelStyle),
                    const SizedBox(height: 4),
                    SearchBar(
                      controller: _searchController,
                      hintText: 'Search customer or invoice number',
                      leading: Icon(
                        Icons.search,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getPropScreenWidth(16)),
                FilledButton(
                  onPressed: () => updateFilter(),
                  child: const Text('Search'),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.24,
                  child: filteredInvoices == null
                      ? Center(child: Text('Tekan tombol Search'))
                      : StreamBuilder<List<Invoice>>(
                          stream: filteredInvoices,
                          builder: (context, snapshot) {
                            !snapshot.hasData
                                ? CircularProgressIndicator()
                                : null;

                            invoices = snapshot.data ?? [];
                            if (invoices!.isEmpty) {
                              return Center(
                                  child: Text('Tidak ada invoice ditemukan'));
                            }

                            return Stack(
                              children: [
                                // Main scrollable table
                                Positioned.fill(
                                  left: 60,
                                  top: 50,
                                  child: SingleChildScrollView(
                                    controller: verticalScroll,
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      controller: horizontalScroll,
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        children: invoices!.map((invoice) {
                                          return Row(
                                            children: [
                                              _buildCell(invoice.id),
                                              _buildCell(DateFormat('M/d/yyyy')
                                                  .format(invoice.dateCreated
                                                      .toDate())),
                                              _buildCell(
                                                  invoice.travel.travelName),
                                              _buildCell(invoice.status!),
                                              _buildCell(invoice.items.length
                                                  .toString()),
                                              _buildCell(
                                                NumberFormat.currency(
                                                  locale: 'id_ID',
                                                  decimalDigits: 0,
                                                  symbol: '',
                                                ).format(
                                                  invoice.items.fold<int>(
                                                    0,
                                                    (sum, item) =>
                                                        sum +
                                                        (item.itemPrice *
                                                            item.quantity),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),

                                // Sticky header (columns)
                                Positioned(
                                  top: 0,
                                  left: 60,
                                  right: 0,
                                  height: 50,
                                  child: SingleChildScrollView(
                                    controller: horizontalScrollForHeader,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        _buildHeaderCell('Inv No'),
                                        _buildHeaderCell('Inv Date'),
                                        _buildHeaderCell('Customer'),
                                        _buildHeaderCell('Status'),
                                        _buildHeaderCell('Qty'),
                                        _buildHeaderCell('Total Amount'),
                                      ],
                                    ),
                                  ),
                                ),

                                // Sticky column "No"
                                Positioned(
                                  left: 0,
                                  top: 50,
                                  bottom: 0,
                                  width: 60,
                                  child: SingleChildScrollView(
                                    controller: verticalScrollForNo,
                                    child: Column(
                                      children: List.generate(invoices!.length,
                                          (index) {
                                        return Container(
                                          width: 60,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: InvoiceColor
                                                    .primary.color
                                                    .withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Text('${index + 1}'),
                                        );
                                      }),
                                    ),
                                  ),
                                ),

                                // Sticky "No" header
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  width: 60,
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      width: 1,
                                      color: InvoiceColor.primary.color
                                          .withOpacity(0.3),
                                    ))),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'No',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(String value) {
    return Container(
      width: 120,
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: InvoiceColor.primary.color.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Text(value, textAlign: TextAlign.center),
    );
  }

  Widget _buildHeaderCell(String label) {
    return Container(
      width: 120,
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: InvoiceColor.primary.color.withOpacity(0.3),
        width: 1,
      ))),
      child: Text(
        label,
        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
      ),
    );
  }
}
