import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/model/setup/airline.dart';
import 'package:my_invoice_app/model/setup/bank.dart';
import 'package:my_invoice_app/model/setup/item.dart';
import 'package:my_invoice_app/model/setup/note.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';
import 'package:my_invoice_app/services/firebase_firestore_service.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';
import '../../../model/setup/travel.dart';
import '../../../widgets/main_widgets/custom_icon_button.dart';

class TransaksiForm extends StatefulWidget {
  const TransaksiForm({super.key});

  @override
  State<TransaksiForm> createState() => _TransaksiFormState();
}

class _TransaksiFormState extends State<TransaksiForm> {
  final _formKey = GlobalKey<FormState>();

  Travel? travel;
  Note? note;
  Airline? airline;
  final _pnrController = TextEditingController();
  final _programController = TextEditingController();
  final _flightNoteController = TextEditingController();

  List<Map<String, dynamic>> itemControllers = [];

  final date = DateTime.now();

  @override
  void initState() {
    itemControllers.add({
      'selectedItem': 'Adult',
      'quantity': 1,
      'priceController': TextEditingController(),
    });
    super.initState();
  }

  Widget buildItemForm(int index) {
    final itemData = itemControllers[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item ${index + 1}',
          style: GoogleFonts.montserrat(
            color: InvoiceColor.primary.color,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: StreamProvider<List<Item>>(
                create: (context) =>
                    context.read<FirebaseFirestoreService>().getItem(),
                initialData: const <Item>[],
                catchError: (context, error) {
                  debugPrint('Error: $error');
                  return [];
                },
                builder: (context, child) {
                  final items = Provider.of<List<Item>>(context);
                  return items.isEmpty
                      ? SizedBox()
                      : DropdownButtonFormField(
                          value: items.first.itemName,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          items: items.map((item) {
                            return DropdownMenuItem(
                              value: item.itemName,
                              child: Text(item.itemName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            itemData['selectedItem'] = value!;
                          },
                        );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<int>(
                value: itemData['quantity'],
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: InvoiceColor.primary.color,
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: InvoiceColor.primary.color,
                ),
                items: List.generate(100, (index) => index + 1).map((quantity) {
                  return DropdownMenuItem(
                    value: quantity,
                    child: Text(quantity.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    itemControllers[index]['quantity'] = value;
                  });
                },
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: itemData['priceController'],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Harga Per Item (IDR)',
            hintStyle: GoogleFonts.montserrat(
              color: InvoiceColor.primary.color.withOpacity(0.3),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Field label style
    TextStyle fieldLabelStyle = GoogleFonts.montserrat(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );

    // Hint Text Style
    TextStyle hintTextStyle = GoogleFonts.montserrat(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 60,
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Create Invoice',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    CustomIconButton(
                      icon: Icons.sync,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Travel', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      StreamProvider<List<Travel>>(
                        create: (context) => context
                            .read<FirebaseFirestoreService>()
                            .getTravel(),
                        initialData: const <Travel>[],
                        catchError: (context, error) {
                          debugPrint('Error: $error');
                          return [];
                        },
                        builder: (context, child) {
                          final travels = Provider.of<List<Travel>>(context);
                          Travel selectedTravel = travels.first;
                          return travels.isEmpty
                              ? SizedBox()
                              : DropdownButtonFormField(
                                  value: selectedTravel,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  items: travels.map((travel) {
                                    return DropdownMenuItem(
                                      value: travel,
                                      child: Text(travel.travelName),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      travel = value!;
                                    });
                                  },
                                );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('PNR', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _pnrController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Masukkan PNR',
                          hintStyle: hintTextStyle,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Maskapai', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      StreamProvider<List<Airline>>(
                        create: (context) => context
                            .read<FirebaseFirestoreService>()
                            .getAirline(),
                        initialData: const <Airline>[],
                        catchError: (context, error) {
                          debugPrint('Error: $error');
                          return [];
                        },
                        builder: (context, child) {
                          final airlines = Provider.of<List<Airline>>(context);
                          Airline selectedAirline = airlines.first;
                          return airlines.isEmpty
                              ? SizedBox()
                              : DropdownButtonFormField(
                                  value: selectedAirline,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  items: airlines.map((airline) {
                                    return DropdownMenuItem(
                                      value: airline,
                                      child: Text(airline.airline),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      airline = value!;
                                    });
                                  },
                                );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Program', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _programController,
                        decoration: InputDecoration(
                          hintText: 'Contoh: 09 Hari',
                          hintStyle: hintTextStyle,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(itemControllers.length,
                          (index) => buildItemForm(index)),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              itemControllers.add({
                                'selectedItem': 'Adult',
                                'quantity': 1,
                                'priceController': TextEditingController(),
                              });
                            });
                          },
                          label: Text('Tambah Item'),
                          icon: Icon(Icons.add),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Note Invoice', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      StreamProvider<List<Note>>(
                        create: (context) =>
                            context.read<FirebaseFirestoreService>().getNote(),
                        initialData: const <Note>[],
                        catchError: (context, error) {
                          debugPrint('Error: $error');
                          return [];
                        },
                        builder: (context, child) {
                          final notes = Provider.of<List<Note>>(context);
                          Note selectedNote = notes.first;
                          return notes.isEmpty
                              ? SizedBox()
                              : DropdownButtonFormField(
                                  value: selectedNote,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  items: notes.map((note) {
                                    return DropdownMenuItem(
                                      value: note,
                                      child: Text(note.type),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      note = value!;
                                    });
                                  },
                                );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Catatan Penerbangan', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _flightNoteController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Catatan Penerbangan',
                          hintStyle: hintTextStyle,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () async {
                            final service =
                                context.read<FirebaseFirestoreService>();
                            if (_formKey.currentState!.validate()) {
                              List<InvoiceItem> items =
                                  itemControllers.map((item) {
                                return InvoiceItem(
                                  item: item['selectedItem'],
                                  itemQuantity: item['quantity'],
                                  itemPrice: int.tryParse(
                                          item['priceController'].text) ??
                                      0,
                                );
                              }).toList();

                              await service.saveInvoice(
                                invoice: Invoice(
                                  proofNumber: generateNoBukti(0),
                                  dateCreated: DateFormat('dd/MM/yyyy').format(date),
                                  pnrCode: _pnrController.text,
                                  flightNotes: _flightNoteController.text,
                                  program: _programController.text,
                                  travel: travel?.toJson() ?? {
                                    'travelName': 'null',
                                    'contactPerson': 'null',
                                    'address': 'null',
                                    'phoneNumber': 0,
                                    'emailAddress': 'null',
                                  },
                                  bank: [
                                    Bank(
                                      bankName: 'percobaan',
                                      accountNumber: 5689876543,
                                      branch: 'Jomokerto',
                                    ).toJson(),
                                    Bank(
                                      bankName: 'percobaan',
                                      accountNumber: 5689876543,
                                      branch: 'Jomokerto',
                                    ).toJson(),
                                  ],
                                  airline: airline?.toJson() ?? {
                                    'airline': 'null',
                                    'code': 'null',
                                  },
                                  items: items.map((item) => item.toJson()).toList(),
                                  note: note?.toJson() ?? {
                                    'type': 'null',
                                    'note': 'null',
                                  },
                                ),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invoice berhasil disimpan!'),
                                ),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateNoBukti(int lastNumber) {
    final now = date;
    final year = now.year % 100; // ambil dua digit terakhir tahun
    final month = now.month.toString().padLeft(2, '0'); // misal 04
    final sequence = (lastNumber + 1).toString().padLeft(4, '0'); // misal 00001

    return 'SO-$year$month-$sequence'; // hasil: SO-2504-00001
  }

  @override
  void dispose() {
    for (var item in itemControllers) {
      item['priceController'].dispose();
    }
    super.dispose();
  }
}
