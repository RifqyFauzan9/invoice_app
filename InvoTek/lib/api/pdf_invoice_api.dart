import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/api/pdf_api.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../model/common/profile.dart';
import '../model/setup/item.dart';
import '../model/transaction/invoice.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice, Profile? profile) async {
    final pdf = Document();

    final poppinsRegular =
        await rootBundle.load('assets/fonts/poppins/Poppins-Regular.ttf');
    final regularPoppins = Font.ttf(poppinsRegular);
    final poppinsBold =
        await rootBundle.load('assets/fonts/poppins/Poppins-Bold.ttf');
    final boldPoppins = Font.ttf(poppinsBold);
    final poppinsMedium =
        await rootBundle.load('assets/fonts/poppins/Poppins-Medium.ttf');
    final mediumPoppins = Font.ttf(poppinsMedium);
    final poppinsSemiBold =
        await rootBundle.load('assets/fonts/poppins/Poppins-SemiBold.ttf');
    final semiBoldPoppins = Font.ttf(poppinsSemiBold);

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a3,
        build: (context) => [
          buildPdfHeader(
              profile, boldPoppins, mediumPoppins, semiBoldPoppins),
          // Build LOBC container
          buildLobc(semiBoldPoppins),
          // Build bottom container line
          Container(
            height: 2,
            color: PdfColors.black,
          ),
          SizedBox(height: PdfPageFormat.mm * 3),
          // Sub Header
          buildSubHeader(invoice, semiBoldPoppins, profile),
          SizedBox(height: PdfPageFormat.cm * 1),
          // Build Item Table
          buildItemTable(invoice, semiBoldPoppins, mediumPoppins),
          SizedBox(height: getPropScreenWidth(6)),
          // Black width 2 line
          Container(
            height: 2,
            color: PdfColors.black,
          ),
          SizedBox(height: getPropScreenWidth(8)),
          buildPaymentSummary(semiBoldPoppins, regularPoppins, invoice),
          SizedBox(height: PdfPageFormat.cm * 1),
          buildFinancialSection(profile, semiBoldPoppins),
          buildNote(invoice, regularPoppins),
          SizedBox(height: PdfPageFormat.cm * 0.6),
          // Term Payment
          buildTermPayment(regularPoppins, invoice),
        ],
      ),
    );

    return PdfApi.saveDocument(name: 'INV-${invoice.id}.pdf', pdf: pdf);
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

  static Container buildFinancialSection(Profile? profile, Font poppinsFont) {
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
                  'Person in Charge',
                  style: TextStyle(font: poppinsFont),
                ),
                ...[
                  if (profile?.profileSignature != null) ...[
                    SizedBox(height: PdfPageFormat.mm * 3),
                    Image(
                      // profile.profileSignature
                      MemoryImage(base64Decode(profile!.profileSignature!)),
                      width: PdfPageFormat.cm * 5,
                      height: PdfPageFormat.cm * 2,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: PdfPageFormat.mm * 4),
                  ] else
                    SizedBox(height: PdfPageFormat.cm * 2),
                ],
                Text(
                  profile?.profilePic ?? '-',
                  style: TextStyle(font: poppinsFont),
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

  static Row buildPaymentSummary(
      Font poppinsFont, Font regularPoppins, Invoice invoice) {
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
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment should be paid to:',
                style: TextStyle(font: regularPoppins),
              ),
              ...invoice.banks.map((bank) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  child: Text(
                    '${bank.bankName}: ${bank.accountNumber}\na/n ${bank.accountHolder}',
                    style: TextStyle(font: poppinsFont),
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
                    style: TextStyle(font: poppinsFont),
                  ),
                  Text(
                    '0',
                    style: TextStyle(font: poppinsFont),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(font: poppinsFont),
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
                    style: TextStyle(font: poppinsFont),
                  ),
                ],
              ),
              Text(
                'Uang Muka/Dibayar: ',
                style: TextStyle(font: poppinsFont),
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
                        style: TextStyle(font: poppinsFont),
                      ),
                      Text(
                        formattedAmount,
                        style: TextStyle(font: poppinsFont),
                      ),
                    ],
                  ),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    outstandingAmount < 0 ? 'Kelebihan: ' : 'Kekurangan: ',
                    style: TextStyle(font: poppinsFont),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id_ID', symbol: '', decimalDigits: 0)
                        .format(outstandingAmount),
                    style: TextStyle(font: poppinsFont),
                  ),
                ],
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
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

  static Table buildItemTable(
      Invoice invoice, Font semiBoldPoppins, Font mediumPoppins) {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
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
                style: TextStyle(font: semiBoldPoppins),
              ),
            ),
            Center(
              child: Text(
                'Qty',
                style: TextStyle(font: semiBoldPoppins),
              ),
            ),
            Center(
              child: Text(
                'Harga',
                style: TextStyle(font: semiBoldPoppins),
              ),
            ),
            Center(
              child: Text(
                'Sub Total',
                style: TextStyle(font: semiBoldPoppins),
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
            Text(
              invoice.pnrCode,
              style: TextStyle(font: semiBoldPoppins),
            ),
          ],
        ),
        // Flight Notes
        TableRow(
          children: [
            Text(
              invoice.flightNotes,
              style: TextStyle(font: semiBoldPoppins),
            ),
          ],
        ),
        // Table Spacer between Flight Notes and Items
        TableRow(
          children: [
            SizedBox(height: PdfPageFormat.mm * 3),
            SizedBox(height: PdfPageFormat.mm * 3),
            SizedBox(height: PdfPageFormat.mm * 3),
            SizedBox(height: PdfPageFormat.mm * 3),
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
                      font: mediumPoppins,
                    ),
                  ),
                  SizedBox(height: PdfPageFormat.mm * 1),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${item.quantity} Pcs',
                    style: TextStyle(
                      color: PdfColors.grey700,
                      font: mediumPoppins,
                    ),
                  ),
                  SizedBox(height: PdfPageFormat.mm * 1),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    NumberFormat.currency(
                      decimalDigits: 0,
                      symbol: '',
                      locale: 'id_ID',
                    ).format(item.itemPrice),
                    style: TextStyle(
                      color: PdfColors.grey700,
                      font: mediumPoppins,
                    ),
                  ),
                  SizedBox(height: PdfPageFormat.mm * 1),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    NumberFormat.currency(
                      decimalDigits: 0,
                      symbol: '',
                      locale: 'id_ID',
                    ).format(item.itemPrice * item.quantity),
                    style: TextStyle(
                      color: PdfColors.grey700,
                      font: mediumPoppins,
                    ),
                  ),
                  SizedBox(height: PdfPageFormat.mm * 1),
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

  static Row buildSubHeader(Invoice invoice, Font poppins, Profile? profile) {
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
                style: TextStyle(font: poppins),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Tanggal: ${DateFormat('dd/MM/yyyy').format(
                  invoice.dateCreated.toDate(),
                )}',
                style: TextStyle(font: poppins),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Kepada: ${invoice.travel.travelName}',
                style: TextStyle(font: poppins),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Alamat: ${invoice.travel.travelAddress}',
                style: TextStyle(font: poppins),
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
              invoice.pelunasan.isNotEmpty ? Text(
                'Pelunasan: ${invoice.pelunasan}',
                style: TextStyle(font: poppins),
              )
              : Text(
                'Pelunasan: -',
                style: TextStyle(font: poppins),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Maskapai: ${invoice.airline.airlineName}',
                style: TextStyle(font: poppins),
              ),
              SizedBox(height: PdfPageFormat.mm * 1),
              Text(
                'Program: ${invoice.program}',
                style: TextStyle(font: poppins),
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
            font: poppins,
            fontSize: getPropScreenWidth(20),
          ),
        ),
      ),
    );
  }

  static Row buildPdfHeader(Profile? profile, Font poppinsBold,
      Font mediumPoppins, Font semiBoldPoppins) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: profile?.profileLogo != null
              ? Image(
                  // profile.profileLogo
                  MemoryImage(base64Decode(profile!.profileLogo!)),
                  width: getPropScreenWidth(200),
                  height: getPropScreenWidth(90),
                  fit: BoxFit.contain,
                )
              : SizedBox(),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                profile?.profileName.toUpperCase() ?? 'No Profile Name',
                textAlign: TextAlign.end,
                style: TextStyle(
                  font: poppinsBold,
                  fontSize: getPropScreenWidth(20),
                  color: PdfColors.black,
                ),
              ),
              Text(
                profile?.profileAddress ?? 'No Profile Address',
                maxLines: 2,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: PdfColors.black,
                  font: semiBoldPoppins,
                  fontSize: getPropScreenWidth(13),
                ),
              ),
              Text(
                'Email: ${profile?.profileEmail ?? 'No Profile Email'}',
                style: TextStyle(
                  color: PdfColors.black,
                  font: mediumPoppins,
                  fontSize: getPropScreenWidth(13),
                ),
              ),
              UrlLink(
                child: Text(
                  profile?.profileWebsite ?? 'https://',
                  style: TextStyle(
                    color: PdfColors.lightBlue,
                    font: mediumPoppins,
                    decoration: TextDecoration.underline,
                    fontSize: getPropScreenWidth(13),
                  ),
                ),
                destination: profile?.profileWebsite ?? 'https://',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
