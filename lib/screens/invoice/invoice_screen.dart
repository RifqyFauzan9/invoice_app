import 'package:dotted_line/dotted_line.dart';
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
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'No. Bukti',
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
                        Text('Tanggal', style: labelStyle),
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
                      'Catatan Penerbangan',
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
                            item.item.itemName,
                            style: labelStyle,
                          ),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'RP ',
                              decimalDigits: 0,
                            ).format(item.itemPrice),
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
                                0, (sum, item) => sum + item.itemPrice),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Kekurangan', style: labelStyle),
                        Text('Rp 0 (Lunas)', style: valueStyle),
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
                      ...widget.invoice.banks.map((bank) {
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
                            'View All',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: getPropScreenWidth(12),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.invoice.note.note.toUpperCase().toString(),
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
                            'View All',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: getPropScreenWidth(12),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '1. Harga sewaktu-waktu bisa berubah tanpa pemberitahuan sebelumnya\n2. Apabila terdapat pengurangan seat dalam kurun waktu satu bulan sebelum keberangkatan maka denda yang dibebankan ke agent adalah sama dengan jumlah deposit yang sudah kami bayarkan ke airlines\n 3. Deposit tidak dapat dikembalikan dan diubah ke PNR yang lain\n 4. Bilamana ada pembatalan dan tidak ada pelunasan dalam pemesanan 3 minggu sebelum keberangkatan maka deposit dianggap hilang / hangus'
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
