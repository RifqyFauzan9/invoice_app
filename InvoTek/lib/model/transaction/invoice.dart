import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_invoice_app/model/setup/item.dart';
import '../setup/airline.dart';
import '../setup/bank.dart';
import '../setup/note.dart';
import '../setup/travel.dart';

class Invoice {
  final String id;
  final Note note;
  final List<Bank> banks;
  final String pnrCode;
  final String program;
  final String flightNotes;
  final Travel travel;
  final Airline airline;
  final List<InvoiceItem> items;
  final Timestamp dateCreated;
  final Timestamp departure;
  final String pelunasan;
  List<Map<String, dynamic>>? paymentHistory;
  final String status;
  final String author;

  Invoice({
    required this.pelunasan,
    required this.departure,
    required this.id,
    required this.note,
    required this.banks,
    required this.pnrCode,
    required this.program,
    required this.flightNotes,
    required this.travel,
    required this.airline,
    required this.items,
    this.paymentHistory,
    required this.dateCreated,
    required this.status,
    required this.author,
  });

  // Convert Firestore JSON to Invoice object
  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        pelunasan: json['pelunasan'],
        departure: json['departure'] as Timestamp,
        id: json['invoiceNumber'],
        note: Note.fromJson(json['note']),
        banks: List<Bank>.from(json['banks'].map((x) => Bank.fromJson(x))),
        pnrCode: json['pnrCode'],
        program: json['program'],
        flightNotes: json['flightNotes'],
        paymentHistory: (json['payment_history'] as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList(),
        travel: Travel.fromJson(json['travel']),
        airline: Airline.fromJson(json['airline']),
        items: List<InvoiceItem>.from(
            json['items'].map((x) => InvoiceItem.fromJson(x))),
        dateCreated: json['dateCreated'],
        status: json['status'],
        author:
            json['author'] ?? '-', // Optional field, default to empty string
      );

  // Convert Invoice object to JSON (for Firestore)
  Map<String, dynamic> toJson() => {
        'note': note.toJson(),
        'banks': banks.map((x) => x.toJson()).toList(),
        'pnrCode': pnrCode,
        'program': program,
        'flightNotes': flightNotes,
        'travel': travel.toJson(),
        'airline': airline.toJson(),
        'items': items.map((x) => x.toJson()).toList(),
        'dateCreated': dateCreated,
        'status': status,
        'invoiceNumber': id,
        'departure': departure,
        'pelunasan': pelunasan,
        'author': author,
      };
}
