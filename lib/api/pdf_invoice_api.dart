import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/api/pdf_api.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../model/transaction/invoice.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    // Logo
    final ByteData logoBytes =
        await rootBundle.load('assets/images/ktg_icon.png');
    final Uint8List logoImageData = logoBytes.buffer.asUint8List();

    // Tanda Tangan
    final ByteData signBytes =
        await rootBundle.load('assets/images/ktg_ttd.png');
    final Uint8List signImageData = signBytes.buffer.asUint8List();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Build header
          buildPdfHeader(logoImageData),
          // Build LOBC container
          buildLobc(),
          // Build bottom container line
          Container(
            height: 2,
            color: PdfColors.black,
          ),
          SizedBox(height: PdfPageFormat.mm * 3),
          // Sub Header
          buildSubHeader(invoice),
          SizedBox(height: PdfPageFormat.cm * 1),
          Table(
            children: [
              // Table Header
              TableRow(
                decoration: BoxDecoration(
                  color: PdfColor.fromHex('BFBFBF'),
                  border: Border(
                    top: BorderSide(width: 2, color: PdfColors.black),
                    bottom: BorderSide(width: 2, color: PdfColors.black),
                  ),
                ),
                children: [
                  Text(
                    'Deskripsi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Qty',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Harga',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Sub Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // Table Spacer between header and pnrCode
              TableRow(
                children: [
                  SizedBox(height: 6),
                  SizedBox(height: 6),
                  SizedBox(height: 6),
                  SizedBox(height: 6),
                ],
              ),
              // PNR CODE
              TableRow(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      invoice.pnrCode,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(flex: 1, child: SizedBox()),
                  Expanded(flex: 1, child: SizedBox()),
                  Expanded(flex: 1, child: SizedBox()),
                ],
              ),
              // Table Spacer between PNR CODE and Flight Notes
              TableRow(
                children: [
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                ],
              ),
              // Flight Notes
              TableRow(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      invoice.flightNotes,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(flex: 1, child: SizedBox()),
                  Expanded(flex: 1, child: SizedBox()),
                  Expanded(flex: 1, child: SizedBox()),
                ],
              ),
              // Table Spacer between Flight Notes and Items
              TableRow(
                children: [
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                ],
              ),
              ...invoice.items.map((item) {
                return TableRow(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.item.itemName} (${item.item.itemCode})'
                              .toUpperCase(),
                          style: TextStyle(color: PdfColors.grey700),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.quantity} Pcs',
                          style: TextStyle(color: PdfColors.grey700),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          NumberFormat.currency(
                            decimalDigits: 0,
                            symbol: '',
                            locale: 'id_ID',
                          ).format(item.itemPrice),
                          style: TextStyle(color: PdfColors.grey700),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          NumberFormat.currency(
                            decimalDigits: 0,
                            symbol: '',
                            locale: 'id_ID',
                          ).format(item.itemPrice * item.quantity),
                          style: TextStyle(color: PdfColors.grey700),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ],
                );
              })
            ],
          ),
          SizedBox(height: 6),
          Container(
            height: 2,
            color: PdfColors.black,
          ),
          SizedBox(height: 6),
          buildPaymentSummary(invoice),
          buildBankSection(invoice),
          SizedBox(height: PdfPageFormat.mm * 1),
          buildNoteAndFinancialSection(invoice),
          SizedBox(height: PdfPageFormat.cm * 0.4),
          buildTermPayment(),
        ],
      ),
    );

    return PdfApi.saveDocument(name: '${invoice.invoiceNumber}.pdf', pdf: pdf);
  }

  static Container buildPaymentSummary(Invoice invoice) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Biaya lain: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '0',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: '',
                        decimalDigits: 0,
                      ).format(
                        invoice.items
                            .fold<int>(0, (sum, item) => sum + item.itemPrice),
                      ),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  'Uang Muka/Dibayar: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '-',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '-0',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kekurangan: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: '',
                        decimalDigits: 0,
                      ).format(
                        invoice.items
                            .fold<int>(0, (sum, item) => sum + item.itemPrice),
                      ),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Column buildTermPayment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TERM PAYMENT',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: PdfPageFormat.cm * 1),
          child: Text(
            '1. Harga sewaktu-waktu bisa berubah tanpa pemberitahuan sebelumnya\n2. Apabila terdapat pengurangan seat dalam kurun waktu satu bulan sebelum keberangkatan maka denda yang dibebankan ke agent adalah sama dengan jumlah deposit yang sudah kami bayarkan ke airlines\n3. Deposit tidak dapat dikembalikan dan diubah ke PNR yang lain\n4. Bilamana ada pembatalan dan tidak ada pelunasan dalam pemesanan 3 minggu sebelum keberangkatan maka deposit dianggap hilang / hangus',
          ),
        ),
      ],
    );
  }

  static Row buildNoteAndFinancialSection(Invoice invoice) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CATATAN',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: PdfPageFormat.cm * 1),
                child: Text(invoice.note.note),
              ),
            ],
          ),
        ),
        SizedBox(width: PdfPageFormat.cm * 1),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'KEUANGAN',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: PdfPageFormat.cm * 1.5),
              Text(
                'RUSDI KS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                height: 2,
                color: PdfColors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Column buildBankSection(Invoice invoice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment should be paid to:'),
        SizedBox(height: PdfPageFormat.mm * 1),
        ...invoice.banks.map(
          (bank) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${bank.bankName}: ${bank.accountNumber}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: PdfPageFormat.mm * 1),
              ],
            );
          },
        ),
        Text(
          'a/n ${invoice.banks.first.accountHolder}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static Row buildSubHeader(Invoice invoice) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No Bukti: ${invoice.proofNumber}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Tanggal: ${DateFormat('dd/MM/yyyy').format(
                  invoice.dateCreated!.toDate(),
                )}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Kepada: ${invoice.travel.travelName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Alamat: ${invoice.travel.travelAddress}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: PdfPageFormat.cm * 1),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PIC: ${invoice.travel.contactPerson}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Maskapai: ${invoice.airline.airline}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Program: ${invoice.program}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Center buildLobc() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: PdfColor.fromHex('4CAF50'),
          border: Border.all(
            color: PdfColors.black,
          ),
        ),
        child: Text(
          'LOBC',
          style: TextStyle(
            color: PdfColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Row buildPdfHeader(Uint8List imageData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          MemoryImage(imageData),
          width: getPropScreenWidth(90),
          height: getPropScreenWidth(90),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'KAMIL TEKNO GLOBALINDO',
              style: TextStyle(
                fontSize: 16,
                color: PdfColors.green900,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Komplek Avenzel Hotel Mensana Tower Lt. 5\nJI. Raya Kranggan Jatisampurna Kota Bekasi',
              style: TextStyle(
                color: PdfColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Email: tiket@ktg-pt.com',
              style: TextStyle(color: PdfColors.black),
            ),
            Text(
              'https:/ktg-pt.com',
              style: TextStyle(color: PdfColors.lightBlue),
            ),
          ],
        ),
      ],
    );
  }
}
