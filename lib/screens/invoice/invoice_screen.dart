import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/api/pdf_api.dart';
import 'package:my_invoice_app/api/pdf_invoice_api.dart';
import 'package:my_invoice_app/model/invoice.dart';
import 'package:my_invoice_app/static/size_config.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

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
        toolbarHeight: getPropScreenWidth(80),
        elevation: 4,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        title: Image.asset(
          'assets/images/ktg_logo.png',
          width: getPropScreenWidth(120),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 10),
            onPressed: () {},
            icon: Icon(Icons.share),
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
                          'SO-2502-00001',
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
                          '01/02/2025',
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
                        Text('PT KAROMAH BAIT AL ANSOR', style: valueStyle),
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
                          'Bp. Juremi',
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
                          '6TWQV3',
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
                          'EKA',
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
                          'GARUDA INDONESIA',
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
                      'JADWAL PENERBANGAN',
                      style: labelStyle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '11 APR 25 | GA990 | CGK → JED | HK45 | 08:45 - 14:35\n18 APR 25 | GA991 | JED → CGK | KK45 | 16:35 - 06:55',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Adult Ticket'.toUpperCase().toString(),
                          style: labelStyle,
                        ),
                        Text('Rp 14.750.000', style: valueStyle),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Airport Tax'.toUpperCase().toString(),
                          style: labelStyle,
                        ),
                        Text('Rp 100.000', style: valueStyle),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'QTY'.toUpperCase().toString(),
                          style: labelStyle,
                        ),
                        Text('43', style: valueStyle),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total'.toUpperCase().toString(),
                          style: labelStyle,
                        ),
                        Text('RP 706.500.000', style: valueStyle),
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
                      Text('Mandiri : 006 00 1152547 8', style: valueStyle),
                      Text('BSI : 0719 846 1387', style: valueStyle),
                      Text('a/n pt.kamil tekno globalindo', style: valueStyle),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
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
                      '1. Deposit Sebesar Rp.4.000.000 / Pax (45)\n2. Limit Pembayaran Deposit 1 x 24 Jam Setelah LOBC Diterima\n3. Change Name & Core Name (Sebelum Issue Ticket) 10% dari Jumlah Group\n4. Full payment time limit 30 Hari sebelum keberangkatan\n5. Insert name time limit 21 Hari sebelum keberangkatan'
                          .toUpperCase()
                          .toString(),
                      maxLines: noteViewAll ? null : 5,
                      overflow: noteViewAll ? null : TextOverflow.ellipsis,
                      style: labelStyle,
                    ),
                  ],
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 2,
                ),
                // Term Payment
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
                          onPressed: () {
                            setState(() {
                              termViewAll = !termViewAll;
                            });
                          },
                        ),
                      ],
                    ),
                    Text(
                      '1. Harga sewaktu-waktu bisa berubah tanpa pemberitahuan sebelumnya\n2. Apabila terdapat pengurangan seat dalam kurun waktu satu bulan sebelum keberangkatan maka denda yang dibebankan ke agent adalah sama dengan jumlah deposit yang sudah kami bayarkan ke airlines\n3. Deposit tidak dapat dikembalikan dan diubah ke PNR yang lain\n4. ﻿﻿Bilamana ada pembatalan dan tidak ada pelunasan dalam pemesanan 3 minggu sebelum keberangkatan maka deposit dianggap hilang / hangus'
                          .toUpperCase()
                          .toString(),
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(30),
        child: FilledButton(
          onPressed: () async {
            final date = DateTime.now();
            final dueDate = date.add(Duration(days: 7));

            final invoice = Invoice(
              travel: Travel(
                travelId: 'dgkhasbavbzcuihzcs',
                travelName: 'Rihlah Wisata',
                contactPerson: 'Eka',
                address: 'Jalan Batubara',
                travelPhoneNumber: 089518853275,
                travelEmail: 'r1fqyf4uz4n@gmail.com',
              ),
              bank: Bank(
                  bankName: 'Mandiri',
                  accountNumber: 3456789876543,
                  branch: 'Tangerang Selatan'),
              airlines: Airlines(
                airlineName: 'Garuda Indonesia',
                code: 'KDX-0897',
              ),
              item: [
                Item(itemCode: 'KDC-489', itemName: 'ADULT'),
                Item(itemCode: 'KDC-489', itemName: 'CHILD'),
                Item(itemCode: 'KDC-489', itemName: 'INFANT'),
              ],
              note: Note(
                type: 'Type 2',
                note: 'jbdasjidbaknmdacbiuzbxciahsdausdhdj',
              ),
            );

            final pdfFile = await PdfInvoiceApi.generate(invoice);

            PdfApi.openFile(pdfFile);
          },
          child: const Text('Download'),
        ),
      ),
    );
  }
}
