import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/api/pdf_api.dart';
import 'package:my_invoice_app/api/pdf_invoice_api.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';
import 'package:my_invoice_app/provider/company_provider.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';

import '../../model/common/company.dart';
import '../../model/setup/item.dart';
import '../../provider/firebase_auth_provider.dart';
import '../../services/invoice_service.dart';

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
  late Invoice? _currentInvoice;
  bool noteViewAll = false;
  bool termViewAll = false;
  String? selectedStatus;
  final _paymentController = TextEditingController();
  Company? company;
  DateTime paidDate = DateTime.now();
  final _paidDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final fieldLabelStyle = GoogleFonts.montserrat(
    color: InvoiceColor.primary.color,
    fontWeight: FontWeight.w600,
    fontSize: getPropScreenWidth(15),
  );

  final fieldTextStyle = GoogleFonts.montserrat(
    fontSize: getPropScreenWidth(12),
    fontWeight: FontWeight.w500,
    color: InvoiceColor.primary.color,
  );

  final hintTextStyle = GoogleFonts.montserrat(
    fontSize: getPropScreenWidth(12),
    fontWeight: FontWeight.w500,
    color: InvoiceColor.primary.color.withOpacity(0.5),
  );

  InputDecoration inputFieldDecoration(String hintText) {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: getPropScreenWidth(16),
        vertical: getPropScreenWidth(12),
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
          color: InvoiceColor.primary.color.withOpacity(0.3),
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
      hintStyle: hintTextStyle,
      hintText: hintText,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _paidDateController.text = DateFormat('d MMMM yyyy').format(paidDate);
    company = context.read<CompanyProvider>().company;
    _currentInvoice = widget.invoice;
  }

  Future<void> _loadInvoice() async {
    final service = context.read<InvoiceService>();
    final updatedInvoice = await service.getInvoiceById(
        uid: context.read<FirebaseAuthProvider>().profile!.uid!,
        invoiceId: _currentInvoice!.id);
    setState(() {
      _currentInvoice = updatedInvoice;
    });
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
      items: _currentInvoice?.items ?? widget.invoice.items,
      paymentHistory: _currentInvoice?.paymentHistory ?? [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentInvoice?.id ?? widget.invoice.id,
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
                        content: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: getPropScreenWidth(10)),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Update Status',
                                  style: fieldLabelStyle,
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField(
                                  value: _currentInvoice?.status ??
                                      widget.invoice.status,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: InvoiceColor.primary.color,
                                  ),
                                  style: fieldTextStyle,
                                  hint: Text(
                                    'Pilih Status',
                                    style: hintTextStyle,
                                  ),
                                  validator: (value) {
                                    final paidInput =
                                        int.tryParse(_paymentController.text) ??
                                            0;
                                    final remainingAfterPayment =
                                        outstandingAmount - paidInput;

                                    if (value == 'Lunas' &&
                                        remainingAfterPayment != 0) {
                                      return 'Harga belum lunas';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      inputFieldDecoration('Pilih Status'),
                                  items: [
                                    'Booking',
                                    'Lunas',
                                    'Issued',
                                    'Cancel'
                                  ].map((status) {
                                    return DropdownMenuItem(
                                      value: status,
                                      child: Text(status),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStatus = value;
                                    });
                                  },
                                ),
                                if (_currentInvoice?.status == 'Booking' ||
                                    _currentInvoice?.status == 'Lunas') ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    'Harga di Bayar',
                                    style: fieldLabelStyle,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Sisa Harga: ${outstandingAmount == 0 ? 'Lunas' : NumberFormat.currency(
                                        locale: 'id_ID',
                                        decimalDigits: 0,
                                        symbol: '',
                                      ).format(outstandingAmount)}',
                                    style: GoogleFonts.montserrat(
                                        color: InvoiceColor.primary.color),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _paymentController,
                                    style: fieldTextStyle,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Harga harus angka';
                                      }
                                      return null;
                                    },
                                    decoration: inputFieldDecoration(
                                        'Tanpa Titik (IDR)'),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Tanggal Dibayar',
                                    style: fieldLabelStyle,
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _paidDateController,
                                    readOnly: true,
                                    style: fieldTextStyle,
                                    decoration:
                                        inputFieldDecoration('Tanggal Dibayar'),
                                    onTap: () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2050),
                                      );
                                      if (pickedDate != null) {
                                        _paidDateController.text =
                                            DateFormat('d MMMM yyyy')
                                                .format(pickedDate);
                                        setState(() {
                                          paidDate = pickedDate;
                                        });
                                      }
                                    },
                                  ),
                                ],
                                const SizedBox(height: 24),
                                FilledButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final invoiceId = _currentInvoice?.id ??
                                          widget.invoice.id;
                                      final amountPaid = int.tryParse(
                                              _paymentController.text) ??
                                          0;
                                      final service =
                                          context.read<InvoiceService>();
                                      final uid = context
                                          .read<FirebaseAuthProvider>()
                                          .profile!
                                          .uid;
                                      final navigator = Navigator.of(context);

                                      try {
                                        await service.updateInvoicePayment(
                                          paidDate:
                                              Timestamp.fromDate(paidDate),
                                          amountPaid: amountPaid,
                                          uid: uid!,
                                          invoiceId: invoiceId,
                                          selectedStatus: selectedStatus ??
                                              _currentInvoice?.status ??
                                              widget.invoice.status,
                                        );
                                        await _loadInvoice();
                                      } on Exception catch (e) {
                                        debugPrint(e.toString());
                                      } finally {
                                        navigator.pop();
                                      }
                                    }
                                  },
                                  child: Text(
                                    _currentInvoice!.status != 'Booking' &&
                                            _currentInvoice!.status != 'Lunas'
                                        ? 'Update Status'
                                        : 'Update Pembayaran',
                                  ),
                                ),
                              ],
                            ),
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
                    Text('Status: ${_currentInvoice?.status ?? '-'}'),
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
                          _currentInvoice?.id ?? widget.invoice.id,
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
                          DateFormat('dd/MM/yyyy').format(
                              _currentInvoice?.dateCreated.toDate() ??
                                  widget.invoice.dateCreated.toDate()),
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
                        Text(
                            _currentInvoice?.travel.travelName ??
                                widget.invoice.travel.travelName,
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
                          _currentInvoice?.travel.contactPerson ??
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
                          _currentInvoice?.pnrCode.toUpperCase() ??
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
                          company?.companyPic ?? '',
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
                          _currentInvoice?.airline.airlineName ??
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
                          _currentInvoice?.program ?? widget.invoice.program,
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Departure', style: labelStyle),
                        Text(
                          DateFormat('d MMMM yyyy').format(
                              _currentInvoice?.departure.toDate() ??
                                  widget.invoice.departure.toDate()),
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (_currentInvoice!.pelunasan.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pelunasan', style: labelStyle),
                          Text(
                            _currentInvoice?.pelunasan ??
                                widget.invoice.pelunasan,
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
                      _currentInvoice?.flightNotes.toUpperCase() ??
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
                    ...?_currentInvoice?.items.map((item) {
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
                            _currentInvoice?.items.fold<int>(
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
                    if (_currentInvoice?.paymentHistory != null)
                      ..._currentInvoice!.paymentHistory!.map((payment) {
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
                        Text(outstandingAmount < 0 ? 'Kelebihan' : 'Kekurangan', style: labelStyle,),
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
                      ...?_currentInvoice?.banks.map((bank) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 1),
                          child: Text(
                            '${bank.bankName}: ${bank.accountNumber}\na/n ${bank.accountHolder}',
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
                      _currentInvoice?.note.content.toUpperCase() ??
                          widget.invoice.note.content.toUpperCase(),
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
                      _currentInvoice?.note.termPayment.toUpperCase() ??
                          widget.invoice.note.termPayment.toUpperCase(),
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
    final invoice = _currentInvoice;
    final pdfFile =
        await PdfInvoiceApi.generate(invoice ?? widget.invoice, company);
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

    return totalInvoiceAmount - totalPaid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _paymentController.dispose();
    _paidDateController.dispose();
  }
}
