import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/api/pdf_api.dart';
import 'package:my_invoice_app/api/pdf_invoice_api.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';
import 'package:my_invoice_app/provider/company_provider.dart';
import 'package:my_invoice_app/provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/services/invoice_service.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';

import '../../model/common/company.dart';
import '../../model/setup/item.dart';

class InvoiceScreen extends StatefulWidget {
  final Invoice invoice;

  const InvoiceScreen({
    super.key,
    required this.invoice,
  });

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  bool noteViewAll = false;
  bool termViewAll = false;
  String? selectedStatus;
  final _paymentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Company? company;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    company = context.read<CompanyProvider>().company;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.black,
    );

    final TextStyle labelStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black.withOpacity(0.7),
      fontSize: 12,
    );

    final TextStyle valueStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 12,
    );

    final outstandingAmount = calculateOutstandingAmount(
      items: widget.invoice.items,
      paymentHistory: widget.invoice.paymentHistory ?? [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.invoice.id,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          PopupMenuButton(
            iconColor: InvoiceColor.primary.color,
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: viewInvoicePdf,
                child: Text('View Invoice Pdf'),
              ),
              PopupMenuItem(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Update Pembayaran',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getPropScreenWidth(17),
                            color: Colors.black,
                          ),
                        ),
                        content: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Update Status',
                                style: GoogleFonts.montserrat(
                                  color: InvoiceColor.primary.color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: getPropScreenWidth(14),
                                ),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField(
                                icon: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: InvoiceColor.primary.color,
                                ),
                                style: GoogleFonts.montserrat(
                                  fontSize: getPropScreenWidth(11),
                                  fontWeight: FontWeight.w500,
                                  color: InvoiceColor.primary.color,
                                ),
                                hint: Text(
                                  'Pilih Status',
                                  style: GoogleFonts.montserrat(
                                    fontSize: getPropScreenWidth(11),
                                    fontWeight: FontWeight.w500,
                                    color: InvoiceColor.primary.color
                                        .withOpacity(0.5),
                                  ),
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: InvoiceColor.primary.color,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: InvoiceColor.primary.color
                                          .withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: InvoiceColor.primary.color,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    selectedStatus = widget.invoice.status;
                                  }
                                  return null;
                                },
                                items: [
                                  'Booking',
                                  'Processed',
                                  'Issued',
                                  'Cancel'
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
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Harga di Bayar',
                                style: GoogleFonts.montserrat(
                                  color: InvoiceColor.primary.color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: getPropScreenWidth(14),
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                readOnly: outstandingAmount == 0,
                                onTap: () {
                                  if (outstandingAmount == 0) {
                                    _showFlushbar(
                                      'Harga sudah lunas.',
                                      InvoiceColor.info.color,
                                      Icons.info_outline,
                                    );
                                  }
                                },
                                keyboardType: TextInputType.number,
                                controller: _paymentController,
                                style: GoogleFonts.montserrat(
                                  fontSize: getPropScreenWidth(11),
                                  fontWeight: FontWeight.w500,
                                  color: InvoiceColor.primary.color,
                                ),
                                validator: (value) {
                                  if (outstandingAmount == 0 ||
                                      value == null ||
                                      value.isEmpty) {
                                    return null;
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Harga harus berupa angka';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: InvoiceColor.primary.color,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: InvoiceColor.primary.color
                                          .withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: InvoiceColor.primary.color,
                                      width: 2,
                                    ),
                                  ),
                                  hintText: 'Tanpa titik (IDR)',
                                  hintStyle: GoogleFonts.montserrat(
                                    fontSize: getPropScreenWidth(11),
                                    fontWeight: FontWeight.w500,
                                    color: InvoiceColor.primary.color
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final invoiceId = widget.invoice.id;
                                    final amountPaid = int.tryParse(
                                        _paymentController.text) ??
                                        0;
                                    final service = context
                                        .read<InvoiceService>();
                                    final uid = context
                                        .read<FirebaseAuthProvider>()
                                        .profile!
                                        .uid;
                                    final navigator = Navigator.of(context);

                                    try {
                                      await service.updateInvoice(
                                        uid: uid!,
                                        invoiceId: invoiceId,
                                        amountPaid: amountPaid,
                                        selectedStatus: selectedStatus,
                                      );

                                      debugPrint(
                                          'Berhasil update pembayaran!');
                                    } on Exception catch (e) {
                                      debugPrint(e.toString());
                                    } finally {
                                      navigator.pop();
                                    }
                                  }
                                },
                                child: Text('Update Pembayaran'),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text('Update Payment'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(getPropScreenWidth(25)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                // Informasi Perusahaan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${widget.invoice.status}'),
                    const SizedBox(height: 4),
                    Text(
                      'INFORMASI PERUSAHAAN',
                      style: titleStyle,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'No. Bukti',
                          style: labelStyle,
                        ),
                        Text(
                          widget.invoice.id,
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tanggal', style: labelStyle),
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(widget.invoice.dateCreated!.toDate()),
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kepada',
                          style: labelStyle,
                        ),
                        Text(widget.invoice.travel.travelName,
                            style: valueStyle),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Penerima',
                          style: labelStyle,
                        ),
                        Text(
                          widget.invoice.travel.contactPerson,
                          style: valueStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                // Detail Pemesanan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DETAIL PEMESANAN',
                      style: titleStyle,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'kode Booking (PNR)',
                          style: labelStyle,
                        ),
                        Text(
                          widget.invoice.pnrCode.toUpperCase(),
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PIC',
                          style: labelStyle,
                        ),
                        Text(
                          widget.invoice.travel.contactPerson,
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Maskapai',
                          style: labelStyle,
                        ),
                        Text(
                          widget.invoice.airline.airlineName,
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Program',
                          style: labelStyle,
                        ),
                        Text(
                          widget.invoice.program,
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Detail Penerbangan',
                      style: labelStyle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.invoice.flightNotes.toUpperCase(),
                      style: valueStyle,
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                // Rincian Biaya
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('RINCIAN BIAYA', style: titleStyle),
                    const SizedBox(height: 8),
                    ...widget.invoice.items.map((item) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.item.itemName}   X   ${item.quantity}',
                            style: labelStyle,
                          ),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'RP',
                              decimalDigits: 0,
                            ).format(item.itemPrice * item.quantity),
                            style: valueStyle,
                          ),
                        ],
                      );
                    }),
                    Row(
                      children: [
                        Expanded(
                          child: DottedLine(
                            dashColor: Colors.black.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: labelStyle,
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'RP',
                            decimalDigits: 0,
                          ).format(
                            widget.invoice.items.fold<int>(
                                0,
                                (sum, item) =>
                                    sum + (item.itemPrice * item.quantity)),
                          ),
                          style: valueStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                // Status Pembayaran
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STATUS PEMBAYARAN', style: titleStyle),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tanggal Pembayaran', style: labelStyle),
                        Text('Jumlah Dibayar', style: labelStyle),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (widget.invoice.paymentHistory != null)
                      ...widget.invoice.paymentHistory!.map((payment) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    (payment['last_payment_date'] as Timestamp)
                                        .toDate(),
                                  ),
                                  style: valueStyle,
                                ),
                                Text(
                                  NumberFormat.currency(
                                    decimalDigits: 0,
                                    symbol: 'RP',
                                    locale: 'id_ID',
                                  ).format(payment['last_payment']),
                                  style: valueStyle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                          ],
                        );
                      }),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Kekurangan', style: labelStyle),
                        Text(
                          outstandingAmount == 0
                              ? 'Rp0 (Lunas)'
                              : NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'RP',
                                      decimalDigits: 0)
                                  .format(outstandingAmount),
                          style: valueStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                // Payment should be paid to
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment should be paid to:', style: labelStyle),
                      ...widget.invoice.banks.take(2).map((bank) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 1),
                          child: Text(
                            '${bank.bankName}: ${formatAccountNumber(bank.accountNumber)}\na/n ${bank.accountHolder}',
                            style: valueStyle,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Note
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CATATAN', style: titleStyle),
                        TextButton(
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            overlayColor: Colors.transparent,
                          ),
                          onPressed: () {
                            setState(() {
                              noteViewAll = !noteViewAll;
                            });
                          },
                          child: Text(
                            noteViewAll ? 'Show Less' : 'View All',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: getPropScreenWidth(12),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.invoice.note.content.toUpperCase().toString(),
                      maxLines: noteViewAll ? null : 5,
                      overflow: noteViewAll ? null : TextOverflow.ellipsis,
                      style: labelStyle,
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                // Terms of payment
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TERM PAYMENT', style: titleStyle),
                        TextButton(
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            overlayColor: Colors.transparent,
                          ),
                          onPressed: () {
                            setState(() {
                              termViewAll = !termViewAll;
                            });
                          },
                          child: Text(
                            termViewAll ? 'Show Less' : 'View All',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: getPropScreenWidth(12),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.invoice.note.termPayment
                          .toUpperCase(),
                      maxLines: termViewAll ? null : 5,
                      overflow: termViewAll ? null : TextOverflow.ellipsis,
                      style: labelStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void viewInvoicePdf() async {
    final invoice = widget.invoice;
    final pdfFile = await PdfInvoiceApi.generate(invoice, company);
    PdfApi.openFile(pdfFile);
  }

  int calculateOutstandingAmount({
    required List<InvoiceItem> items,
    required List<Map<String, dynamic>> paymentHistory,
  }) {
    final totalInvoiceAmount = items.fold<int>(
      0,
      (sum, item) => sum + (item.itemPrice * item.quantity),
    );

    final totalPaid = paymentHistory.fold<int>(
      0,
      (sum, payment) => sum + (payment['last_payment'] as int),
    );

    final kekurangan = totalInvoiceAmount - totalPaid;

    return kekurangan < 0 ? 0 : kekurangan; // prevent negative
  }

  String formatAccountNumber(int number) {
    // convert num to string
    String numberStr = number.toString();

    // format
    final buffer = StringBuffer();
    for (int i = 0; i < numberStr.length; i++) {
      buffer.write(numberStr[i]);
      int nextIndex = i + 1;
      if (nextIndex % 4 == 0 && nextIndex != numberStr.length) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _paymentController.dispose();
  }

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
}
