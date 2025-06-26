import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_invoice_app/model/setup/airline.dart';
import 'package:my_invoice_app/model/setup/item.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';

class InvoiceService {
  final FirebaseFirestore _firebaseFirestore;

  InvoiceService(FirebaseFirestore? firebaseFirestore)
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<Invoice>> getInvoiceByStatus(String status, String companyId) {
    return _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('invoices')
        .where('status', isEqualTo: status)
        .orderBy('invoiceNumber', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Invoice.fromJson(e.data())).toList();
    });
  }

  Stream<List<Invoice>> getAllInvoices(String companyId) {
    return _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('invoices')
        .orderBy('invoiceNumber', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Invoice.fromJson(e.data())).toList();
    });
  }

  Future<Invoice> getInvoiceById({
    required String companyId,
    required String invoiceId,
  }) async {
    final result = await _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('invoices')
        .doc(invoiceId)
        .get();

    if (result.exists) {
      return Invoice.fromJson(result.data()!);
    } else {
      throw Exception('Invoice not found');
    }
  }

  Future<void> saveInvoice({
    required Invoice invoice,
    required String companyId,
  }) async {
    await _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('invoices')
        .doc(invoice.id)
        .set(invoice.toJson());
  }

  Future<void> updateInvoicePayment({
    required String companyId,
    required String invoiceId,
    required String selectedStatus,
    required int amountPaid,
    required Timestamp paidDate,
  }) async {
    final invoiceRef = _firebaseFirestore
        .collection('companies')
        .doc(companyId)
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

  Future<void> updateInvoice({
    required String companyId,
    required String invoiceId,
    required String pnrCode,
    required Airline airline,
    required String program,
    required String flightNotes,
    required List<InvoiceItem> items,
    required Timestamp departure,
    required String pelunasan,
  }) async {
    final invoiceRef = _firebaseFirestore
        .collection('companies')
        .doc(companyId)
        .collection('invoices')
        .doc(invoiceId);

    final data = {
      'pnrCode': pnrCode,
      'airline': airline.toJson(),
      'program': program,
      'flightNotes': flightNotes,
      'items': items.map((item) => item.toJson()).toList(),
      'departure': departure,
      'pelunasan': pelunasan,
    };

    await invoiceRef.update(data);
  }

  /// Format: SO-YYMM-XXXX
  String generateNoBukti(int sequenceNumber, DateTime date) {
    final year = date.year % 100;
    final month = date.month.toString().padLeft(2, '0');
    final sequence = sequenceNumber.toString().padLeft(4, '0');
    return 'SO-$year$month-$sequence';
  }
}
