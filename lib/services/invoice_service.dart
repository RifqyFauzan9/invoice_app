import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_invoice_app/model/setup/item.dart';

import '../model/setup/airline.dart';
import '../model/transaction/invoice.dart';

class InvoiceService {
  final FirebaseFirestore _firebaseFirestore;

  InvoiceService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  Stream<List<Invoice>> getInvoiceByStatus(String status, String uid) {
    return _firebaseFirestore
        .collection('invoices')
        .doc(uid)
        .collection('invoices')
        .orderBy('invoiceNumber', descending: true)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((event) {
      return event.docs.map(
        (e) {
          final data = Invoice.fromJson(e.data());
          return data;
        },
      ).toList();
    });
  }

  String generateNoBukti(int lastNumber) {
    final now = DateTime.now();
    final year = now.year % 100; // ambil dua digit terakhir tahun
    final month = now.month.toString().padLeft(2, '0'); // misal 04
    final sequence = (lastNumber + 1).toString().padLeft(4, '0'); // misal 00001

    return 'SO-$year$month-$sequence';
  }

  Future<void> saveInvoice({
    required Invoice invoice,
    required String uid,
  }) async {
    await _firebaseFirestore
        .collection('invoices')
        .doc(uid)
        .collection('invoices')
        .doc(invoice.id)
        .set(invoice.toJson());
  }

  Future<void> updateInvoicePayment({
    required String uid,
    required String invoiceId,
    required selectedStatus,
    required int amountPaid,
    required Timestamp paidDate,
  }) async {
    final invoiceRef = _firebaseFirestore
        .collection('invoices')
        .doc(uid)
        .collection('invoices')
        .doc(invoiceId);

    if (amountPaid != 0) {
      final paymentEntry = {
        'last_payment': amountPaid,
        'last_payment_date': paidDate,
      };

      await invoiceRef.update({
        'status': selectedStatus,
        'payment_history': FieldValue.arrayUnion([paymentEntry]),
      });
    } else {
      await invoiceRef.update({'status': selectedStatus});
    }
  }

  Future<void> deleteInvoice({required String uid, required String invoiceId}) {
    return _firebaseFirestore
        .collection('invoices')
        .doc(uid)
        .collection('invoices')
        .doc(invoiceId)
        .delete();
  }

  Stream<List<Invoice>> getAllInvoices(String uid) {
    return _firebaseFirestore
        .collection('invoices')
        .doc(uid)
        .collection('invoices')
        .orderBy('invoiceNumber', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map(
        (e) {
          final data = Invoice.fromJson(e.data());
          return data;
        },
      ).toList();
    });
  }

  Future<void> updateInvoice({
    required String uid,
    required String invoiceId,
    required String pnrCode,
    required Airline airline,
    required String program,
    required String flightNotes,
    required List<InvoiceItem> items,
  }) async {
    final invoiceRef = _firebaseFirestore
        .collection('invoices')
        .doc(uid)
        .collection('invoices')
        .doc(invoiceId);

    final data = {
      'pnrCode': pnrCode,
      'airline': airline.toJson(),
      'program': program,
      'flightNotes': flightNotes,
      'items': items.map((item) => item.toJson()).toList(),
    };

    await invoiceRef.update(data);
  }
}
