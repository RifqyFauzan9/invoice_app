import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/main_widgets/custom_icon_button.dart';

class TransaksiForm extends StatefulWidget {
  const TransaksiForm({super.key});

  @override
  State<TransaksiForm> createState() => _TransaksiFormState();
}

class _TransaksiFormState extends State<TransaksiForm> {
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
                  decoration: InputDecoration(
                    hintText: 'Masukkan PNR',
                    hintStyle: hintTextStyle,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Adult', style: fieldLabelStyle),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Harga Adult',
                          hintStyle: hintTextStyle,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove),
                      visualDensity: VisualDensity.compact,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {},
                    label: const Text('Tambah Item'),
                    icon: Icon(Icons.add),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Catatan Invoice', style: fieldLabelStyle),
                const SizedBox(height: 4),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan Catatan Invoice',
                    hintStyle: hintTextStyle,
                  ),
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
          ),
        ),
      ),
    );
  }
}
