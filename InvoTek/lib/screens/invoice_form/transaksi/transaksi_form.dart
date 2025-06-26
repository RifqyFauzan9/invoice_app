import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
import '../../../provider/profile_provider.dart';
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
  final _dateController = TextEditingController();
  final _searchTravelController = TextEditingController();
  final _travelFocusNode = FocusNode();
  final _departureController = TextEditingController();
  DateTime dateCreated = DateTime.now();
  final _pelunasanController = TextEditingController();
  DateTime? pickedDeparture;

  // List Invoice Item
  List<Map<String, dynamic>> itemController = [];

  Travel? selectedTravel;
  Airline? selectedAirline;
  Note? selectedNote;

  List<Item> availableItems = [];
  List<Travel> availableTravels = [];
  List<Airline> availableAirlines = [];
  List<Note> availableNotes = [];
  List<Bank> listBank = [];

  bool isLoading = false;

  @override
  void initState() {
    _travelFocusNode.addListener(() {
      if (!_travelFocusNode.hasFocus) {
        _handleTravelSelection(_searchTravelController.text);
      }
    });
    _dateController.text = DateFormat('d MMMM yyyy').format(dateCreated);
    // Get Travels
    context
        .read<FirebaseFirestoreService>()
        .getDocumentsOnce(
          companyId: context.read<ProfileProvider>().person!.companyId!,
          collectionName: 'travels',
          fromJson: Travel.fromJson,
        )
        .then((travels) {
      if (travels.isNotEmpty) {
        setState(() {
          availableTravels = travels;
        });
      } else {
        debugPrint('List travel empty!');
      }
    });

    //  Get Airlines
    context
        .read<FirebaseFirestoreService>()
        .getDocumentsOnce(
          companyId: context.read<ProfileProvider>().person!.companyId!,
          collectionName: 'airlines',
          fromJson: Airline.fromJson,
        )
        .then((airlines) {
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
    context
        .read<FirebaseFirestoreService>()
        .getDocumentsOnce(
          companyId: context.read<ProfileProvider>().person!.companyId!,
          collectionName: 'items',
          fromJson: Item.fromJson,
        )
        .then((items) {
      if (items.isNotEmpty) {
        setState(() {
          availableItems = items;
        });
      } else {
        debugPrint('List item empty!');
      }
    });

    // Get Notes
    context
        .read<FirebaseFirestoreService>()
        .getDocumentsOnce(
          companyId: context.read<ProfileProvider>().person!.companyId!,
          collectionName: 'notes',
          fromJson: Note.fromJson,
        )
        .then((notes) {
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
    context
        .read<FirebaseFirestoreService>()
        .getDocumentsOnce(
          companyId: context.read<ProfileProvider>().person!.companyId!,
          collectionName: 'banks',
          fromJson: Bank.fromJson,
        )
        .then((banks) {
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
                      TypeAheadField<Travel>(
                        controller: _searchTravelController,
                        focusNode: _travelFocusNode,
                        suggestionsCallback: (pattern) async {
                          return availableTravels
                              .where((travel) => travel.travelName
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
                        itemBuilder: (context, Travel travel) {
                          return ListTile(
                            title: Text(travel.travelName),
                          );
                        },
                        onSelected: (Travel travel) {
                          setState(() {
                            selectedTravel = travel;
                            _searchTravelController.text = travel.travelName;
                          });
                        },
                        emptyBuilder: (context) => ListTile(
                          title: Text('No travel found'),
                        ),
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: 'Pilih atau ketik nama travel',
                              hintStyle: hintTextStyle,
                            ),
                          );
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
                      SizedBox(height: 8),
                      Text('Tanggal Pembuatan Invoice', style: fieldLabelStyle),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050),
                          );
                          if (pickedDate != null) {
                            _dateController.text =
                                DateFormat('d MMMM yyyy').format(pickedDate);
                            setState(() {
                              dateCreated = pickedDate;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      Text('Departure', style: fieldLabelStyle),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: _departureController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText:
                              DateFormat('d MMMM yyyy').format(DateTime.now()),
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Departure harus diisi';
                          }
                          return null;
                        },
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050),
                          );
                          if (pickedDate != null) {
                            _departureController.text =
                                DateFormat('d MMMM yyyy').format(pickedDate);
                            setState(() {
                              pickedDeparture = pickedDate;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Pelunasan', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: _pelunasanController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Pelunasan',
                          hintStyle: hintTextStyle,
                        ),
                      ),
                      SizedBox(height: itemController.isEmpty ? 16 : 8),
                      ...List.generate(
                        itemController.length,
                        (index) => buildItemForm(index, availableItems),
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
                                    backgroundColor: InvoiceColor.error.color),
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
                        itemLabelBuilder: (note) => note.noteName,
                        onChanged: (Note? note) async {
                          if (note != null && note != selectedNote) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(note.noteName),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Note',
                                        style: TextStyle(
                                          fontSize: getPropScreenWidth(16),
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        note.content,
                                        maxLines: 7,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: getPropScreenWidth(6)),
                                      Text(
                                        'Term Payment',
                                        style: TextStyle(
                                          fontSize: getPropScreenWidth(16),
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        note.termPayment,
                                        maxLines: 7,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            setState(() {
                              selectedNote = note;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Detail Penerbangan', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        minLines: 1,
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
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

  void _handleTravelSelection(String inputText) {
    final enteredText = inputText.toLowerCase();
    final matches = availableTravels
        .where(
            (travel) => travel.travelName.toLowerCase().contains(enteredText))
        .toList();

    setState(() {
      selectedTravel = matches.isNotEmpty ? matches.first : null;
      _searchTravelController.text = selectedTravel?.travelName ?? inputText;
    });
  }

  Future<void> _submitForm() async {
    final service = context.read<InvoiceService>();
    final firestoreService = context.read<FirebaseFirestoreService>();
    final navigator = Navigator.of(context);

    if (selectedTravel == null || itemController.isEmpty) {
      _showFlushbar(
        'Semua Dropdown dan Item wajib dipilih',
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
      final companyId = context.read<ProfileProvider>().person!.companyId!;
      final sequenceNumber = await firestoreService.generateAutoIncrementType(
        companyId: companyId,
        prefix: '',
        docType: 'invoices',
        padding: 0,
        returnType: AutoIncrementReturnType.number,
        date:
            dateCreated, // Tetap kirim dateCreated meskipun parameter nullable
      );

      List<InvoiceItem> items = itemController.map((item) {
        return InvoiceItem(
          item: item['item'],
          quantity: int.tryParse(item['quantityController'].text) ?? 0,
          itemPrice: int.tryParse(item['priceController'].text) ?? 0,
        );
      }).toList();

      final invoice = Invoice(
        pelunasan: _pelunasanController.text,
        departure: Timestamp.fromDate(pickedDeparture!),
        dateCreated: Timestamp.fromDate(dateCreated),
        flightNotes: _flightNotesController.text,
        pnrCode: _pnrController.text,
        program: _programController.text,
        id: service.generateNoBukti(sequenceNumber, dateCreated),
        airline: selectedAirline!,
        items: items,
        note: selectedNote!,
        travel: selectedTravel!,
        banks: listBank,
        status: 'Booking',
        author: context.read<ProfileProvider>().person!.email!,
      );

      await service.saveInvoice(
        companyId: context.read<ProfileProvider>().person!.companyId!,
        invoice: invoice,
      );

      navigator.pushReplacementNamed(ScreenRoute.main.route,
          arguments: companyId);
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
        'quantityController': TextEditingController(text: 1.toString()),
        'priceController': TextEditingController(),
      });
    });
  }

  void _removeItem() {
    setState(() {
      itemController.removeLast();
    });
  }

  Widget buildItemForm(int index, List<Item> items) {
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
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: itemData['quantityController'],
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Quantity tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Quantity harus berupa angka';
                  }
                  return null;
                },
              ),
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
      itemController.clear();
      _pnrController.clear();
      _flightNotesController.clear();
      _programController.clear();
    });
  }

  @override
  void dispose() {
    _pelunasanController.dispose();
    _departureController.dispose();
    _programController.dispose();
    _pnrController.dispose();
    _flightNotesController.dispose();
    _dateController.dispose();
    _searchTravelController.dispose();
    _travelFocusNode.dispose();
    for (var item in itemController) {
      (item['priceController'] as TextEditingController).dispose();
      (item['quantityController'] as TextEditingController).dispose();
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
