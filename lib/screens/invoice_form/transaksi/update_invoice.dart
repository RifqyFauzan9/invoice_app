import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/model/transaction/invoice.dart';
import 'package:my_invoice_app/services/app_service/firebase_firestore_service.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:provider/provider.dart';

import '../../../model/setup/airline.dart';
import '../../../model/setup/item.dart';
import '../../../provider/firebase_auth_provider.dart';
import '../../../services/invoice_service.dart';
import '../../../style/colors/invoice_color.dart';

import '../../../widgets/main_widgets/custom_icon_button.dart';

class UpdateInvoice extends StatefulWidget {
  const UpdateInvoice({super.key, required this.oldInvoice});

  final Invoice oldInvoice;

  @override
  State<UpdateInvoice> createState() => _UpdateInvoiceState();
}

class _UpdateInvoiceState extends State<UpdateInvoice> {
  final _formKey = GlobalKey<FormState>();
  final _pnrController = TextEditingController();
  final _programController = TextEditingController();
  final _flightNotesController = TextEditingController();
  List<Airline> availableAirlines = [];
  List<Item> availableItems = [];
  Airline? selectedAirline;
  bool isLoading = false;
  bool isInitialLoading = true; // Add this for initial data loading

  List<Map<String, Object>> itemController = [];

  void resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      selectedAirline = availableAirlines.first;
      itemController.clear();
      _pnrController.clear();
      _flightNotesController.clear();
      _programController.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pnrController.dispose();
    _programController.dispose();
    _flightNotesController.dispose();
    for (var item in itemController) {
      (item['priceController'] as TextEditingController).dispose();
      (item['quantityController'] as TextEditingController).dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    _pnrController.text = widget.oldInvoice.pnrCode;
    _programController.text = widget.oldInvoice.program;
    _flightNotesController.text = widget.oldInvoice.flightNotes;

    // Set loading state to true when starting to fetch data
    setState(() => isInitialLoading = true);

    // Fetch airlines and items
    final uid = context.read<FirebaseAuthProvider>().profile!.uid!;
    final firestoreService = context.read<FirebaseFirestoreService>();

    // Use Future.wait to fetch both data simultaneously
    Future.wait([
      firestoreService.getDocumentsOnce(
        uid: uid,
        collectionPath: 'airlines',
        fromJson: Airline.fromJson,
      ),
      firestoreService.getDocumentsOnce(
        uid: uid,
        collectionPath: 'items',
        fromJson: Item.fromJson,
      ),
    ]).then((results) {
      final airlines = results[0] as List<Airline>;
      final items = results[1] as List<Item>;

      setState(() {
        availableAirlines = airlines;
        availableItems = items;

        // Set selected airline
        selectedAirline = airlines.firstWhere(
          (a) => a.airlineId == widget.oldInvoice.airline.airlineId,
          orElse: () => airlines.first,
        );

        // Initialize item controllers
        _initializeItemControllers(widget.oldInvoice.items);

        // Data loading complete
        isInitialLoading = false;
      });
    }).catchError((error) {
      debugPrint('Error loading data: $error');
      setState(() => isInitialLoading = false);
      _showFlushbar(
        'Gagal memuat data',
        InvoiceColor.error.color,
        Icons.error_outline,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while initial data is loading
    if (isInitialLoading) {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: InvoiceColor.primary.color,
            size: getPropScreenWidth(40),
          ),
        ),
      );
    }

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
                      'Edit ${widget.oldInvoice.id}',
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
                      DropdownButtonFormField(
                        value: selectedAirline,
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: InvoiceColor.primary.color),
                        hint: Text(
                            selectedAirline?.airlineName ?? 'Pilih Maskapai'),
                        items: availableAirlines.map((airline) {
                          return DropdownMenuItem(
                            value: airline,
                            child: Text(airline.airlineName),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => selectedAirline = value),
                        validator: (value) =>
                            value == null ? 'Pilih Maskapai' : null,
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
                      SizedBox(height: itemController.isEmpty ? 16 : 8),
                      ...List.generate(
                        itemController.length,
                        (index) =>
                            buildItemForm(index, availableItems, hintTextStyle),
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
                      const SizedBox(height: 24),
                      isLoading
                          ? Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: InvoiceColor.primary.color,
                                size: getPropScreenWidth(30),
                              ),
                            )
                          : FilledButton(
                              onPressed: () => _updateInvoice(),
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

  void _addItem() {
    if (availableItems.isEmpty) return;

    setState(() {
      itemController.add(<String, Object>{
        'item': availableItems.first,
        'quantityController': TextEditingController(text: '1'),
        'priceController': TextEditingController(),
      });
    });
  }

  void _removeItem() {
    setState(() {
      itemController.removeLast();
    });
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

  void _updateInvoice() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedAirline == null || itemController.isEmpty) {
      _showFlushbar(
        'Semua Dropdown dan Item wajib dipilih',
        InvoiceColor.error.color,
        Icons.info_outline,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final items = itemController.map((item) {
        return InvoiceItem(
          item: item['item'] as Item,
          quantity: int.parse(
              (item['quantityController'] as TextEditingController).text),
          itemPrice: int.parse(
              (item['priceController'] as TextEditingController).text),
        );
      }).toList();

      await context.read<InvoiceService>().updateInvoice(
            uid: context.read<FirebaseAuthProvider>().profile!.uid!,
            invoiceId: widget.oldInvoice.id,
            pnrCode: _pnrController.text,
            airline: selectedAirline!,
            program: _programController.text,
            flightNotes: _flightNotesController.text,
            items: items,
          );

      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _initializeItemControllers(List<InvoiceItem> existingItems) {
    itemController = existingItems.map((invoiceItem) {
      // Cari item yang sesuai dari availableItems berdasarkan ID
      final matchedItem = availableItems.firstWhere(
        (item) => item.itemId == invoiceItem.item.itemId,
        orElse: () => invoiceItem.item, // Fallback jika tidak ditemukan
      );

      return <String, Object>{
        'item': matchedItem, // Gunakan item yang sudah dicocokkan
        'quantityController': TextEditingController(
          text: invoiceItem.quantity.toString(),
        ),
        'priceController': TextEditingController(
          text: invoiceItem.itemPrice.toString(),
        ),
      };
    }).toList();
  }

  Widget buildItemForm(int index, List<Item> items, TextStyle hintTextStyle) {
    final itemData = itemController[index];
    final item = itemData['item'] as Item;
    final quantityController =
        itemData['quantityController'] as TextEditingController;
    final priceController =
        itemData['priceController'] as TextEditingController;

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
              child: DropdownButtonFormField<Item>(
                value: item, // Pastikan value ada di items
                icon: Icon(Icons.keyboard_arrow_down,
                    color: InvoiceColor.primary.color),
                hint: Text('Pilih Item', style: hintTextStyle),
                items: items.map((item) {
                  return DropdownMenuItem<Item>(
                    value: item, // Pastikan nilai unik (berdasarkan ID)
                    child: Text(item.itemName),
                  );
                }).toList(),
                onChanged: (Item? newValue) {
                  if (newValue != null) {
                    setState(() {
                      itemData['item'] = newValue; // Update item yang dipilih
                    });
                  }
                },
                validator: (value) => value == null ? 'Pilih Item' : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Quantity tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) return 'Harus angka';
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: priceController,
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
            if (int.tryParse(value) == null) return 'Harus angka';
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
