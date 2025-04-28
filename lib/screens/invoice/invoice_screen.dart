import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/api/pdf_api.dart';
import 'package:my_invoice_app/api/pdf_invoice_api.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';
import 'package:my_invoice_app/static/size_config.dart';

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

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Theme.of(context).colorScheme.primary,
    );

    final TextStyle labelStyle = GoogleFonts.montserrat(
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.primary,
      fontSize: 12,
    );

    final TextStyle valueStyle = GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
      fontSize: 12,
    );

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/ktg_logo.png',
          width: getPropScreenWidth(120),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 10),
            onPressed: () async {
              final invoice = widget.invoice;

              final pdfFile = await PdfInvoiceApi.generate(invoice);

              PdfApi.openFile(pdfFile);
            },
            icon: Icon(Icons.download),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                // Informasi Perusahaan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INFORMASI PERUSAHAAN',
                      style: titleStyle,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'NO. BUKTI',
                          style: labelStyle,
                        ),
                        Text(
                          widget.invoice.proofNumber,
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TANGGAL', style: labelStyle),
                        Text(
                          widget.invoice.dateCreated != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(widget.invoice.dateCreated!.toDate())
                              : 'N/A',
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'KEPADA',
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
                          'PENERIMA',
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
                  thickness: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
                // Detail Pemesanan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DETAIL PEMESANAN',
                      style: titleStyle,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'KODE BOOKING (PNR)',
                          style: labelStyle,
                        ),
                        Text(
                          widget.invoice.pnrCode,
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
                          'MASKAPAI',
                          style: labelStyle,
                        ),
                        Text(
                          widget.invoice.airline.airline,
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PROGRAM',
                          style: labelStyle,
                        ),
                        Text(
                          '9 HARI',
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'CATATAN PENERBANGAN',
                      style: labelStyle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.invoice.flightNotes,
                      style: valueStyle,
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: Theme.of(context).colorScheme.primary,
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
                            item.item.itemName.toUpperCase(),
                            style: labelStyle,
                          ),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'RP',
                              decimalDigits: 0,
                            ).format(item.itemPrice),
                            style: valueStyle,
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total'.toUpperCase().toString(),
                          style: labelStyle,
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'RP',
                            decimalDigits: 0,
                          ).format(
                            widget.invoice.items.fold<int>(
                                0, (sum, item) => sum + item.itemPrice),
                          ),
                          style: valueStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 2,
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
                        Text('TANGGAL PEMBAYARAN', style: labelStyle),
                        Text('JUMLAH DIBAYAR', style: labelStyle),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('01-Feb-25', style: valueStyle),
                        Text('-Rp 180.000.000', style: valueStyle),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('07-Mar-25', style: valueStyle),
                        Text('-Rp 522.000.000', style: valueStyle),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('KEKURANGAN', style: labelStyle),
                        Text('Rp 0 (LUNAS)', style: valueStyle),
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 2,
                ),
                // Payment should be paid to
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment should be paid to:', style: labelStyle),
                      ...widget.invoice.banks.map((bank) {
                        return Text(
                          '${bank.bankName}: ${formatAccountNumber(bank.accountNumber)}',
                          style: valueStyle,
                        );
                      }),
                      Text('a/n ${widget.invoice.banks.first.branch}', style: valueStyle),
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
                            'View All',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: getPropScreenWidth(12),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.invoice.note.note
                          .toUpperCase()
                          .toString(),
                      maxLines: noteViewAll ? null : 5,
                      overflow: noteViewAll ? null : TextOverflow.ellipsis,
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


}
