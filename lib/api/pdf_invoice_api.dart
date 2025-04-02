import 'dart:io';
import 'package:my_invoice_app/api/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../model/invoice.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        build: (context) => [
          Text('Halo ges')
        ],
      ),
    );

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }
}
