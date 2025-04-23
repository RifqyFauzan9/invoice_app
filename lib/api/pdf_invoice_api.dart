import 'dart:io';
import 'package:flutter/services.dart';
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
          Row(
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
          ),
          // Build LOBC container
          Center(
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
          ),
          // Build bottom container line
          Container(
            height: 2,
            color: PdfColors.black,
          ),
          SizedBox(height: PdfPageFormat.mm * 3),
          // Sub Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No Bukti:   SO-2502-00001',
                      style: TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: PdfPageFormat.mm * 1),
                    Text(
                      'Tanggal:   01/02/2025',
                      style: TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: PdfPageFormat.mm * 1),
                    Text(
                      'Kepada:   PT KAROMAH BAIT AL ANSOR',
                      style: TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: PdfPageFormat.mm * 1),
                    Text(
                      'Alamat:   JL. INSINYUR SUKARNO, DESA TANJUNG BARU, KEC. BARURAJA TIMUR, KAB.OGAN KEMIRING ULU, PROVINSI SUMATERA SELATAN',
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'PIC:   Eka',
                      style: TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: PdfPageFormat.mm * 1),
                    Text(
                      'Maskapai:   GARUDA',
                      style: TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: PdfPageFormat.mm * 1),
                    Text(
                      'Program:   09 HARI',
                      style: TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: PdfPageFormat.cm * 1),
          // Table Item

        ],
      ),
    );

    return PdfApi.saveDocument(name: 'Invoice KTG.pdf', pdf: pdf);
  }
}
