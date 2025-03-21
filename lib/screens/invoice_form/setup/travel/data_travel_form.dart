import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';

import '../../../../widgets/invoice_form/section_title_form.dart';

class DataTravelForm extends StatefulWidget {
  const DataTravelForm({super.key});

  @override
  State<DataTravelForm> createState() => _DataTravelFormState();
}

class _DataTravelFormState extends State<DataTravelForm> {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                    CustomIconButton(
                      icon: Icons.sync,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: SectionTitleForm(
                    text: 'Add Travel Data',
                  ),
                ),
                const SizedBox(height: 16),
                Text('No ID Travel', style: fieldLabelStyle),
                const SizedBox(height: 4),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan No ID Travel',
                    hintStyle: hintTextStyle,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Nama Travel', style: fieldLabelStyle),
                const SizedBox(height: 4),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan Nama Travel',
                    hintStyle: hintTextStyle,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Kontak Person', style: fieldLabelStyle),
                const SizedBox(height: 4),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan Kontak Person',
                    hintStyle: hintTextStyle,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Alamat', style: fieldLabelStyle),
                const SizedBox(height: 4),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan Alamat Travel',
                    hintStyle: hintTextStyle,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Nomor Telepon', style: fieldLabelStyle),
                const SizedBox(height: 4),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan Nomor Telepon',
                    hintStyle: hintTextStyle,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Email', style: fieldLabelStyle),
                const SizedBox(height: 4),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan Email Travel',
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

