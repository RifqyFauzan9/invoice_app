import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/invoice_form/section_title_form.dart';
import '../../../../widgets/main_widgets/custom_icon_button.dart';

class DataAirlinesForm extends StatefulWidget {
  const DataAirlinesForm({super.key});

  @override
  State<DataAirlinesForm> createState() => _DataAirlinesFormState();
}

class _DataAirlinesFormState extends State<DataAirlinesForm> {
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
                  text: 'Add Data Maskapai',
                ),
              ),
              const SizedBox(height: 16),
              Text('Nama Maskapai', style: fieldLabelStyle),
              const SizedBox(height: 4),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Masukkan Nama Maskapai',
                  hintStyle: hintTextStyle,
                ),
              ),
              const SizedBox(height: 8),
              Text('Kode', style: fieldLabelStyle),
              const SizedBox(height: 4),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Masukkan Kode Maskapai',
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
    );
  }
}
