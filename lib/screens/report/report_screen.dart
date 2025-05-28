import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/model/setup/airline.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';
import 'package:my_invoice_app/services/app_service/firebase_firestore_service.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../model/setup/item.dart';
import '../../provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/services/invoice_service.dart';
import '../../static/size_config.dart';
import 'package:excel/excel.dart' as exc;
import 'package:path/path.dart' as path;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // filter state
  String selectedStatus = 'All Status';
  String selectedAirline = 'All Maskapai';
  String selectedItem = 'All Item';
  DateTime? periodFrom;
  DateTime? periodTo;
  DateTime? departureDate;

  String searchQuery = '';
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _departureController = TextEditingController();

  List<String> availableAirlines = [];
  List<String> availableItems = [];

  @override
  void dispose() {
    super.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    _departureController.dispose();
  }

  @override
  void initState() {
    super.initState();
    context
        .read<FirebaseFirestoreService>()
        .getDocumentsOnce(
            uid: context.read<FirebaseAuthProvider>().profile!.uid!,
            collectionPath: 'airlines',
            fromJson: Airline.fromJson)
        .then((airlines) {
      setState(() {
        availableAirlines.add('All Maskapai');
      });
      if (airlines.isNotEmpty) {
        for (var airline in airlines) {
          setState(() {
            availableAirlines.add(airline.airlineName);
          });
        }
      }
    });
    context
        .read<FirebaseFirestoreService>()
        .getDocumentsOnce(
            uid: context.read<FirebaseAuthProvider>().profile!.uid!,
            collectionPath: 'items',
            fromJson: Item.fromJson)
        .then((items) {
      setState(() {
        availableItems.add('All Item');
      });
      if (items.isNotEmpty) {
        for (var item in items) {
          setState(() {
            availableItems.add(item.itemName);
          });
        }
      }
    });
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
          .value = exc.TextCellValue(invoice.status.toUpperCase());
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

  void _showFlushbar(String message, Color bgColor, IconData icon) {
    Flushbar(
      message: message,
      messageColor: Colors.white,
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

  void _exportFilteredInvoices() async {
    final uid = context.read<FirebaseAuthProvider>().profile!.uid!;
    final service = context.read<InvoiceService>();

    final allInvoices = await service.getAllInvoices(uid).first;
    final filteredInvoices = _filterInvoices(allInvoices);

    if (filteredInvoices.isEmpty) {
      _showFlushbar(
        'No invoice to export',
        InvoiceColor.error.color,
        Icons.info_outline,
      );
      return;
    }

    exportExcel(filteredInvoices);
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.read<FirebaseAuthProvider>().profile!.uid!;
    final service = context.read<InvoiceService>();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Invoices'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: InvoiceColor.primary.color,
        ),
        actions: [
          IconButton(
            onPressed: () => _exportFilteredInvoices(),
            icon: Icon(Icons.download),
            color: InvoiceColor.primary.color,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              color: InvoiceColor.primary.color,
                            ),
                            value: selectedStatus,
                            items: [
                              'All Status',
                              'Booking',
                              'Lunas',
                              'Cancel',
                              'Issued'
                            ].map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedStatus = value;
                                });
                              }
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
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2050),
                                    );
                                    if (pickedDate != null) {
                                      _fromDateController.text =
                                          DateFormat('dd-MMM-yy')
                                              .format(pickedDate);
                                      setState(() {
                                        periodFrom = pickedDate;
                                      });
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
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2050),
                                    );
                                    if (pickedDate != null) {
                                      _toDateController.text =
                                          DateFormat('dd-MMM-yy')
                                              .format(pickedDate);
                                      setState(() {
                                        periodTo = pickedDate;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Departure', style: fieldLabelStyle),
                    SizedBox(height: 4),
                    TextFormField(
                      controller: _departureController,
                      decoration: InputDecoration(hintText: 'All Departure'),
                      readOnly: true,
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        );
                        if (pickedDate != null) {
                          _departureController.text =
                              DateFormat('d MMMM yyyy').format(pickedDate);
                          setState(() {
                            departureDate = pickedDate;
                          });
                        }
                      },
                    )
                  ],
                ),
                SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Maskapai', style: fieldLabelStyle),
                    SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      style: dropdownTextStyle,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: InvoiceColor.primary.color,
                      ),
                      value: selectedAirline,
                      items: availableAirlines.map((airlineName) {
                        return DropdownMenuItem(
                          value: airlineName,
                          child: Text(airlineName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedAirline = value;
                          });
                        }
                      },
                    )
                  ],
                ),
                SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Item', style: fieldLabelStyle),
                    SizedBox(height: 4),
                    DropdownButtonFormField(
                        style: dropdownTextStyle,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: InvoiceColor.primary.color,
                        ),
                        value: selectedItem,
                        items: availableItems.map((itemName) {
                          return DropdownMenuItem(
                            value: itemName,
                            child: Text(itemName),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              selectedItem = value;
                            });
                          }
                        }),
                  ],
                ),
                SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Search', style: fieldLabelStyle),
                    SizedBox(height: 4),
                    SearchBar(
                      hintText: 'Seach customer or invoice number',
                      leading: Icon(
                        Icons.search,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 16),
                // --- RESULT LIST --- //
                SizedBox(
                  height: SizeConfig.screenHeight * 0.4,
                  child: StreamBuilder<List<Invoice>>(
                    stream: service.getAllInvoices(uid),
                    builder: (ctx, snap) {
                      if (!snap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final filteredInvoices = _filterInvoices(snap.data!);

                      if (filteredInvoices.isEmpty) {
                        return const Center(
                            child: Text('No matching invoices.'));
                      }

                      return ListView.builder(
                        itemCount: filteredInvoices.length,
                        itemBuilder: (c, i) {
                          final inv = filteredInvoices[i];
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: getPropScreenWidth(6),
                            ),
                            padding: EdgeInsets.all(getPropScreenWidth(14)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 2,
                                color:
                                    InvoiceColor.primary.color.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      inv.id,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: InvoiceColor.primary.color,
                                      ),
                                    ),
                                    Text(
                                      inv.status,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: InvoiceColor.primary.color,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      inv.travel.travelName,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('d MMM yyyy')
                                          .format(inv.dateCreated.toDate()),
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '${inv.items.length} items • ${NumberFormat.currency(symbol: 'Rp', decimalDigits: 0, locale: 'id_ID').format(
                                    inv.items.fold<int>(
                                      0,
                                      (sum, item) =>
                                          sum +
                                          (item.itemPrice * item.quantity),
                                    ),
                                  )}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Invoice> _filterInvoices(List<Invoice> invoices) {
    var filtered = invoices;

    // Filter berdasarkan status
    if (selectedStatus != 'All Status') {
      filtered = filtered.where((inv) => inv.status == selectedStatus).toList();
    }

    // Filter berdasarkan periode
    if (periodFrom != null && periodTo != null) {
      filtered = filtered.where((inv) {
        final date = inv.dateCreated.toDate();
        return !date.isBefore(periodFrom!) && !date.isAfter(periodTo!);
      }).toList();
    }

    // Filter berdasarkan departure date
    if (departureDate != null) {
      filtered = filtered.where((inv) {
        final date = inv.departure.toDate();
        return date.year == departureDate!.year &&
            date.month == departureDate!.month &&
            date.day == departureDate!.day;
      }).toList();
    }

    // Filter berdasarkan maskapai
    if (selectedAirline != 'All Maskapai') {
      filtered = filtered
          .where((inv) => inv.airline.airlineName == selectedAirline)
          .toList();
    }

    // Filter berdasarkan item
    if (selectedItem != 'All Item') {
      filtered = filtered
          .where((inv) => inv.items
              .map((item) => item.item.itemName)
              .toList()
              .contains(selectedItem))
          .toList();
    }

    // Filter berdasarkan search query
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((inv) {
        return inv.id.toLowerCase().contains(query) ||
            inv.travel.travelName.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }
}
