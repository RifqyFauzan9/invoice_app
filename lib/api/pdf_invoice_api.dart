import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/api/pdf_api.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../model/common/company.dart';
import '../model/setup/item.dart';
import '../model/transaction/invoice.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice, Company? company) async {
    final pdf = Document();

    final fontData =
        await rootBundle.load('assets/fonts/poppins/Poppins-Regular.ttf');
    final poppinsFont = Font.ttf(fontData);

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Build header
          buildPdfHeader(company, poppinsFont),
          // Build LOBC container
          buildLobc(poppinsFont),
          // Build bottom container line
          Container(
            height: 2,
            color: PdfColors.black,
          ),
          SizedBox(height: PdfPageFormat.mm * 3),
          // Sub Header
          buildSubHeader(invoice, poppinsFont),
          SizedBox(height: PdfPageFormat.cm * 0.5),
          // Build Item Table
          buildItemTable(invoice, poppinsFont),
          SizedBox(height: 6),
          // Black width 2 line
          Container(
            height: 2,
            color: PdfColors.black,
          ),
          SizedBox(height: getPropScreenWidth(8)),
          buildPaymentSummary(poppinsFont, invoice),
          SizedBox(height: PdfPageFormat.cm * 1),
          buildFinancialSection(company, poppinsFont),
          SizedBox(height: PdfPageFormat.cm * 1),
          buildNote(invoice, poppinsFont),
          SizedBox(height: PdfPageFormat.cm * 0.6),
          // Term Payment
          buildTermPayment(poppinsFont, invoice),
        ],
      ),
    );

    return PdfApi.saveDocument(name: '${invoice.id}.pdf', pdf: pdf);
  }

  static Column buildNote(Invoice invoice, Font poppinsFont) {
    return Column(
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
          child: Text(
            invoice.note.content,
            style: TextStyle(font: poppinsFont),
          ),
        ),
      ],
    );
  }

  static Container buildFinancialSection(Company? company, Font poppinsFont) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 7),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Person In Charge',
                  style: TextStyle(
                    font: poppinsFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: PdfPageFormat.cm * 1.5),
                Text(
                  company?.companyPic ?? '-',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, font: poppinsFont),
                ),
                Container(
                  height: 2,
                  color: PdfColors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Row buildPaymentSummary(Font poppinsFont, Invoice invoice) {
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

    final outstandingAmount = calculateOutstandingAmount(
      items: invoice.items,
      paymentHistory: invoice.paymentHistory ?? [],
    );

    final history = invoice.paymentHistory ??
        [
          {
            'last_payment': null,
            'last_payment_date': null,
          }
        ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment should be paid to:',
                style: TextStyle(font: poppinsFont),
              ),
              ...invoice.banks.take(2).map((bank) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  child: Text(
                    '${bank.bankName}: ${bank.accountNumber}\na/n ${bank.accountHolder}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      font: poppinsFont,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Biaya lain: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      font: poppinsFont,
                    ),
                  ),
                  Text(
                    '0',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      font: poppinsFont,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      font: poppinsFont,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: '',
                      decimalDigits: 0,
                    ).format(
                      invoice.items.fold<int>(
                          0,
                          (sum, item) =>
                              sum + (item.itemPrice * item.quantity)),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      font: poppinsFont,
                    ),
                  ),
                ],
              ),
              Text(
                'Uang Muka/Dibayar: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppinsFont,
                ),
              ),
              ...history.map((payment) {
                final timestamp = payment['last_payment_date'];
                final amount = payment['last_payment'];

                final formattedDate = timestamp != null
                    ? DateFormat('dd-MMM-yy')
                        .format((timestamp as Timestamp).toDate())
                    : '-';

                final formattedAmount = amount != null
                    ? NumberFormat.currency(
                        decimalDigits: 0,
                        symbol: '-',
                        locale: 'id_ID',
                      ).format(amount)
                    : '-0';

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          font: poppinsFont,
                        ),
                      ),
                      Text(
                        formattedAmount,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          font: poppinsFont,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kekurangan: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      font: poppinsFont,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id_ID', symbol: '', decimalDigits: 0)
                        .format(outstandingAmount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      font: poppinsFont,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Table buildItemTable(Invoice invoice, Font poppins) {
    return Table(
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
            Center(
              child: Text(
                'Deskripsi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppins,
                ),
              ),
            ),
            Center(
              child: Text(
                'Qty',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppins,
                ),
              ),
            ),
            Center(
              child: Text(
                'Harga',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppins,
                ),
              ),
            ),
            Center(
              child: Text(
                'Sub Total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppins,
                ),
              ),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppins,
                ),
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(flex: 1, child: SizedBox()),
          ],
        ),
        // Flight Notes
        TableRow(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                invoice.flightNotes,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppins,
                ),
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
            SizedBox(height: getPropScreenWidth(4)),
            SizedBox(height: getPropScreenWidth(4)),
            SizedBox(height: getPropScreenWidth(4)),
            SizedBox(height: getPropScreenWidth(4)),
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
                    style: TextStyle(
                      color: PdfColors.grey700,
                      font: poppins,
                    ),
                  ),
                  SizedBox(height: 2),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.quantity} Pcs',
                    style: TextStyle(
                      color: PdfColors.grey700,
                      font: poppins,
                    ),
                  ),
                  SizedBox(height: 2),
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
                    style: TextStyle(
                      color: PdfColors.grey700,
                      font: poppins,
                    ),
                  ),
                  SizedBox(height: 2),
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
                    style: TextStyle(
                      color: PdfColors.grey700,
                      font: poppins,
                    ),
                  ),
                  SizedBox(height: 2),
                ],
              ),
            ],
          );
        })
      ],
    );
  }

  static Column buildTermPayment(Font poppins, Invoice invoice) {
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
            invoice.note.termPayment,
            style: TextStyle(font: poppins),
          ),
        ),
      ],
    );
  }

  static Row buildSubHeader(Invoice invoice, Font poppins) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No Bukti: ${invoice.id}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppins,
                ),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Tanggal: ${DateFormat('dd/MM/yyyy').format(
                  invoice.dateCreated!.toDate(),
                )}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppins,
                ),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Kepada: ${invoice.travel.travelName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppins,
                ),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Alamat: ${invoice.travel.travelAddress}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppins,
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
                  font: poppins,
                ),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Maskapai: ${invoice.airline.airlineName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: poppins,
                ),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Program: ${invoice.program}',
                style: TextStyle(
                  font: poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Center buildLobc(Font poppins) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: PdfColor.fromHex('4CAF50'),
          border: Border.all(color: PdfColors.black),
        ),
        child: Text(
          'LOBC',
          style: TextStyle(
            color: PdfColors.white,
            fontWeight: FontWeight.bold,
            font: poppins,
          ),
        ),
      ),
    );
  }

  static Row buildPdfHeader(Company? company, Font poppins) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: company?.companyLogo != null
              ? Image(
                  MemoryImage(base64Decode(company!.companyLogo!)),
                  width: getPropScreenWidth(150),
                  height: getPropScreenWidth(70),
                  fit: BoxFit.contain,
                )
              : SizedBox(),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                company?.companyName ?? 'No Company Name',
                style: TextStyle(
                  font: poppins,
                  fontSize: 16,
                  color: PdfColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                company?.companyAddress ?? 'No Company Address',
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: PdfColors.black,
                  font: poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Email: ${company?.companyEmail ?? 'No Company Email'}',
                style: TextStyle(color: PdfColors.black, font: poppins),
              ),
              Text(
                company?.companyWebsite ?? 'https://',
                style: TextStyle(color: PdfColors.lightBlue, font: poppins),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
