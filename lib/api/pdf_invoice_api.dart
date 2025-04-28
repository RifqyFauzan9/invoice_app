import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/api/pdf_api.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../model/transaction/invoice.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    final ByteData bytes = await rootBundle.load('assets/images/ktg_icon.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Build header
          buildPdfHeader(imageData),
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
          // Table Item

        ],
      ),
    );

    return PdfApi.saveDocument(name: 'Invoice KTG.pdf', pdf: pdf);
  }

  static pw.Row buildSubHeader(Invoice invoice) {
    return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No Bukti:   ${invoice.proofNumber}',
                    style: TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: PdfPageFormat.mm * 1),
                  Text(
                    'Tanggal:   ${DateFormat('dd/MM/yyyy').format(
                      invoice.dateCreated!.toDate(),
                    )}',
                    style: TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: PdfPageFormat.mm * 1),
                  Text(
                    'Kepada:   ${invoice.travel.travelName}',
                    style: TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: PdfPageFormat.mm * 1),
                  Text(
                    'Alamat:   ${invoice.travel.travelAddress}',
                    style: TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: PdfPageFormat.cm * 1),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'PIC:   ${invoice.travel.contactPerson}',
                    style: TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: PdfPageFormat.mm * 1),
                  Text(
                    'Maskapai:   ${invoice.airline.airline}',
                    style: TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: PdfPageFormat.mm * 1),
                  Text(
                    'Program:   ${invoice.program}',
                    style: TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
  }

  static pw.Center buildLobc() {
    return Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: PdfColor.fromHex('#4CAF50'),
              border: Border.all(
                color: PdfColors.black,
              ),
            ),
            child: Text(
              'LOBC',
              style: TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        );
  }

  static pw.Row buildPdfHeader(Uint8List imageData) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            pw.Image(
              pw.MemoryImage(imageData),
              width: getPropScreenWidth(80),
              height: getPropScreenWidth(80),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'KAMIL TEKNO',
                  style: TextStyle(
                      fontSize: 24,
                      color: PdfColors.green700,
                      fontWeight: pw.FontWeight.bold),
                ),
                Text(
                  'GLOBALINDO',
                  style: TextStyle(
                    fontSize: 16,
                    color: PdfColors.blue900,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Komplek Avenzel Hotel Mensana Tower Lt. 5\n'
                  'JI. Raya Kranggan Jatisampurna Kota Bekasi',
                  style: TextStyle(
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
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
