import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/main_widgets/custom_icon_button.dart';

class TransaksiForm extends StatefulWidget {
  const TransaksiForm({super.key});

  @override
  State<TransaksiForm> createState() => _TransaksiFormState();
}

class _TransaksiFormState extends State<TransaksiForm> {
  final _formKey = GlobalKey<FormState>();

  // Note Types
  String defaultNoteType = 'Type 1';
  final List<String> _noteTypes = [
    'Type 1',
    'Type 2',
    'Type 3',
  ];

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
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Travel', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      DropdownButtonFormField(
                        value: 'Pilih Travel',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        items: ['Pilih Travel', 'Rihlah Wisata'].map((travel) {
                          return DropdownMenuItem(
                            value: travel,
                            child: Text(travel),
                          );
                        }).toList(),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                      Text('PNR', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Masukkan PNR',
                          hintStyle: hintTextStyle,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Item 1', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField(
                              value: 'Pilih Item',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              items: ['Pilih Item', 'Adult', 'Child', 'Infant']
                                  .map((travel) {
                                return DropdownMenuItem(
                                  value: travel,
                                  child: Text(travel),
                                );
                              }).toList(),
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField(
                              value: 1,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              items: List.generate(100, (index) => index + 1)
                                  .map((quantity) {
                                return DropdownMenuItem(
                                  value: quantity,
                                  child: Text(quantity.toString()),
                                );
                              }).toList(),
                              onChanged: (value) {},
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Harga Per Item (IDR)',
                          hintStyle: hintTextStyle,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {},
                          label: Text('Tambah Item'),
                          icon: Icon(Icons.add),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Note Invoice', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      DropdownButtonFormField(
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        items: _noteTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            defaultNoteType = value!;
                          });
                        },
                        value: defaultNoteType,
                      ),
                      const SizedBox(height: 8),
                      Text('Catatan Penerbangan', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Masukkan Catatan Penerbangan',
                          hintStyle: hintTextStyle,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {},
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
}
