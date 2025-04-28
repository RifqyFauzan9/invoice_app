import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_invoice_app/model/setup/item.dart';

import '../setup/airline.dart';
import '../setup/bank.dart';
import '../setup/note.dart';
import '../setup/travel.dart';

class Invoice {
  final Note note;
  final List<Bank> banks;
  Timestamp? dateCreated;
  final String pnrCode;
  final String proofNumber;
  final String program;
  String? status;
  final String flightNotes;
  final Travel travel;
  final Airline airline;
  final List<InvoiceItem> items;

  Invoice({
    required this.note,
    required this.banks,
    this.dateCreated,
    required this.pnrCode,
    required this.proofNumber,
    required this.program,
    this.status,
    required this.flightNotes,
    required this.travel,
    required this.airline,
    required this.items,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        note: Note.fromJson(json["note"]),
        banks: List<Bank>.from(json["banks"].map((x) => Bank.fromJson(x))),
        dateCreated: json['dateCreated'],
        pnrCode: json["pnrCode"],
        proofNumber: json["proofNumber"],
        program: json["program"],
        status: json["status"],
        flightNotes: json["flightNotes"],
        travel: Travel.fromJson(json["travel"]),
        airline: Airline.fromJson(json["airline"]),
        items: List<InvoiceItem>.from(
            json["items"].map((x) => InvoiceItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    dateCreated ??= Timestamp.now();
    status ??= 'Pending';
    return {
      "note": note.toJson(),
      "banks": List<dynamic>.from(banks.map((x) => x.toJson())),
      "dateCreated": dateCreated,
      "pnrCode": pnrCode,
      "proofNumber": proofNumber,
      "program": program,
      "status": status,
      "flightNotes": flightNotes,
      "travel": travel.toJson(),
      "airline": airline.toJson(),
      "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
  }
}
