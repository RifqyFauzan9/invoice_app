import '../setup/airline.dart';
import '../setup/bank.dart';
import '../setup/item.dart';
import '../setup/note.dart';
import '../setup/travel.dart';

class Invoice {
  final String proofNumber;
  final String dateCreated;
  final String pnrCode;
  final String flightNotes;
  final String program;
  final dynamic travel;
  final List<dynamic> bank;
  final dynamic airline;
  final List<dynamic> items;
  final dynamic note;

  Invoice({
    required this.proofNumber,
    required this.dateCreated,
    required this.pnrCode,
    required this.flightNotes,
    required this.program,
    required this.travel,
    required this.bank,
    required this.airline,
    required this.items,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'proofNumber': proofNumber,
      'dateCreated': dateCreated,
      'pnrCode': pnrCode,
      'flightNotes': flightNotes,
      'program': program,
      'travel': travel is Map ? travel : (travel as Travel).toJson(),
      'bank': bank.map((b) => b is Map ? b : (b as Bank).toJson()).toList(),
      'airline': airline is Map ? airline : (airline as Airline).toJson(),
      'items': items.map((i) => i is Map ? i : (i as InvoiceItem).toJson()).toList(),
      'note': note is Map ? note : (note as Note).toJson(),
    };
  }
}
