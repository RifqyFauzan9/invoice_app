import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/model/setup/airline.dart';
import 'package:my_invoice_app/model/setup/bank.dart';
import 'package:my_invoice_app/model/setup/item.dart';
import 'package:my_invoice_app/model/setup/note.dart';
import 'package:my_invoice_app/model/setup/travel.dart';
import 'package:my_invoice_app/services/app_service/firebase_firestore_service.dart';
import 'package:my_invoice_app/services/invoice_service.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/widgets/invoice_form/custom_dropdown.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:provider/provider.dart';

import '../../../model/transaction/invoice.dart';
import '../../../provider/firebase_auth_provider.dart';
import '../../../style/colors/invoice_color.dart';

class TransaksiForm extends StatefulWidget {
  const TransaksiForm({super.key});

  @override
  State<TransaksiForm> createState() => _TransaksiFormState();
}

class _TransaksiFormState extends State<TransaksiForm> {
  final _formKey = GlobalKey<FormState>();
  final _pnrController = TextEditingController();
  final _programController = TextEditingController();
  final _flightNotesController = TextEditingController();

  Future<List<T>> getDocumentsOnce<T>({
    required String collectionPath,
    required T Function(Map<String, dynamic> data) fromJson,
  }) async {
    final uid = context.read<FirebaseAuthProvider>().profile!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(uid)
        .collection(collectionPath)
        .get();
    return snapshot.docs.map((doc) => fromJson(doc.data())).toList();
  }

  // List Invoice Item
  List<Map<String, dynamic>> itemController = [];

  Travel? selectedTravel;
  Airline? selectedAirline;
  Note? selectedNote;

  List<int> quantities = List.generate(100, (index) => index + 1);
  List<Item> availableItems = [];
  List<Travel> availableTravels = [];
  List<Airline> availableAirlines = [];
  List<Note> availableNotes = [];
  List<Bank> listBank = [];

  bool isLoading = false;

  @override
  void initState() {
    // Get Travels
    getDocumentsOnce(
      collectionPath: 'travels',
      fromJson: Travel.fromJson,
    ).then((travels) {
      if (travels.isNotEmpty) {
        setState(() {
          availableTravels = travels;
          selectedTravel = travels.first;
        });
      } else {
        debugPrint('List travel empty!');
      }
    });

    //  Get Airlines
    getDocumentsOnce(
      collectionPath: 'airlines',
      fromJson: Airline.fromJson,
    ).then((airlines) {
      if (airlines.isNotEmpty) {
        setState(() {
          availableAirlines = airlines;
          selectedAirline = airlines.first;
        });
      } else {
        debugPrint('List airline empty!');
      }
    });

    // Get Items
    getDocumentsOnce(
      collectionPath: 'items',
      fromJson: Item.fromJson,
    ).then((items) {
      if (items.isNotEmpty) {
        setState(() {
          availableItems = items;
        });
      } else {
        debugPrint('List item empty!');
      }
    });

    // Get Notes
    getDocumentsOnce(
      collectionPath: 'notes',
      fromJson: Note.fromJson,
    ).then((notes) {
      if (notes.isNotEmpty) {
        setState(() {
          availableNotes = notes;
          selectedNote = notes.first;
        });
      } else {
        debugPrint('List note empty!');
      }
    });

    // Get Banks
    getDocumentsOnce(
      collectionPath: 'banks',
      fromJson: Bank.fromJson,
    ).then((banks) {
      if (banks.isNotEmpty) {
        setState(() {
          listBank = banks;
        });
      } else {
        debugPrint('List bank empty!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Field label style
    TextStyle fieldLabelStyle = GoogleFonts.montserrat(
      color: InvoiceColor.primary.color,
      fontSize: getPropScreenWidth(15),
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );

    // Hint Text Style
    TextStyle hintTextStyle = TextStyle(
      color: InvoiceColor.primary.color.withOpacity(0.3),
      fontSize: getPropScreenWidth(14),
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getPropScreenWidth(25),
            vertical: getPropScreenWidth(60),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Create Invoice',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: getPropScreenWidth(18),
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0,
                      ),
                    ),
                    CustomIconButton(
                      icon: Icons.sync,
                      onPressed: () => resetForm(),
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
                      CustomDropdown(
                        items: availableTravels,
                        itemLabelBuilder: (travel) => travel.travelName,
                        onChanged: (Travel? value) {
                          setState(() {
                            selectedTravel = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('PNR', style: fieldLabelStyle),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: _pnrController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan code PNR',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'PNR tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Maskapai', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      CustomDropdown(
                        items: availableAirlines,
                        itemLabelBuilder: (airline) => airline.airlineName,
                        onChanged: (Airline? value) {
                          setState(() {
                            selectedAirline = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Program', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: _programController,
                        decoration: InputDecoration(
                          hintText: 'Cth: 09 Hari',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Program tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: itemController.isEmpty ? 16 : 8),
                      ...List.generate(
                        itemController.length,
                        (index) =>
                            buildItemForm(index, availableItems, quantities),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                if (availableItems.isEmpty) {
                                  _showFlushbar(
                                    'Silahkan setup data item terlebih dahulu!',
                                    InvoiceColor.error.color,
                                    Icons.info_outline,
                                  );
                                } else {
                                  _addItem();
                                }
                              },
                              label: Text('Tambah'),
                              icon: Icon(Icons.add),
                            ),
                          ),
                          if (itemController.isNotEmpty)
                            SizedBox(width: getPropScreenWidth(8)),
                          if (itemController.isNotEmpty)
                            Expanded(
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                    backgroundColor: Color(0xFFDC3545)),
                                onPressed: () => _removeItem(),
                                label: Text('Hapus'),
                                icon: Icon(Icons.remove),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Note Invoice', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      CustomDropdown(
                        items: availableNotes,
                        itemLabelBuilder: (note) => note.type,
                        onChanged: (Note? note) {
                          setState(() {
                            selectedNote = note;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Detail Penerbangan', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: _flightNotesController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan catatan penerbangan',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Catatan penerbangan tidak boleh kosong.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      isLoading
                          ? Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: InvoiceColor.primary.color,
                                size: getPropScreenWidth(30),
                              ),
                            )
                          : FilledButton(
                              onPressed: () => _submitForm(),
                              child: const Text('Submit'),
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

  Future<void> _submitForm() async {
    final service = context.read<InvoiceService>();
    final firestoreService = context.read<FirebaseFirestoreService>();
    final navigator = Navigator.of(context);

    if (itemController.isEmpty) {
      _showFlushbar(
        'Semua Item wajib dipilih',
        InvoiceColor.error.color,
        Icons.info_outline,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final uid = context.read<FirebaseAuthProvider>().profile!.uid!;
      final lastNumber =
          await firestoreService.generateAutoIncrementType(uid: uid, prefix: '',docType: 'invoices', padding: 0, returnType: AutoIncrementReturnType.number,);

      List<InvoiceItem> items = itemController.map((item) {
        return InvoiceItem(
          item: item['item'],
          quantity: item['quantity'],
          itemPrice: int.tryParse(item['priceController'].text) ?? 0,
        );
      }).toList();

      final invoice = Invoice(
        flightNotes: _flightNotesController.text,
        pnrCode: _pnrController.text,
        program: _programController.text,
        id: service.generateNoBukti(lastNumber),
        airline: selectedAirline!,
        items: items,
        note: selectedNote!,
        travel: selectedTravel!,
        banks: listBank,
      );

      await service.saveInvoice(
        uid: uid,
        invoice: invoice,
      );

      navigator.pushReplacementNamed(ScreenRoute.main.route, arguments: uid);
    } on Exception catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _addItem() {
    setState(() {
      itemController.add({
        'item': availableItems.first,
        'quantity': quantities.first,
        'priceController': TextEditingController(),
      });
    });
  }

  void _removeItem() {
    setState(() {
      itemController.removeLast();
    });
  }

  Widget buildItemForm(int index, List<Item> items, List<int> quantities) {
    final itemData = itemController[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item ${index + 1}',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.primary,
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
              child: CustomDropdown(
                items: items,
                itemLabelBuilder: (item) => item.itemName,
                onChanged: (Item? item) {
                  setState(() {
                    itemData['item'] = item;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: CustomDropdown(
                  items: quantities,
                  itemLabelBuilder: (qty) => qty.toString(),
                  onChanged: (int? qty) {
                    setState(() {
                      itemData['quantity'] = qty;
                    });
                  }),
            )
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          textInputAction: TextInputAction.done,
          controller: itemData['priceController'],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Harga per item tanpa titik (IDR)',
            hintStyle: GoogleFonts.montserrat(
              color: InvoiceColor.primary.color.withOpacity(0.3),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harga tidak boleh kosong';
            }
            if (int.tryParse(value) == null) {
              return 'Harga harus berupa angka';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      selectedTravel = availableTravels.first;
      selectedAirline = availableAirlines.first;
      selectedNote = availableNotes.first;
      itemController.clear();
      _pnrController.clear();
      _flightNotesController.clear();
      _programController.clear();
    });
  }

  @override
  void dispose() {
    _programController.dispose();
    _pnrController.dispose();
    _flightNotesController.dispose();
    for (var item in itemController) {
      (item['priceController'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _showFlushbar(String message, Color bgColor, IconData icon) {
    Flushbar(
      message: message,
      messageColor: Colors.white,
      messageSize: 12,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: bgColor,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    ).show(context);
  }
}
