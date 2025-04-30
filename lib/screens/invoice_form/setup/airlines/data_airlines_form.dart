import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/firebase_firestore_service.dart';
import '../../../../widgets/invoice_form/section_title_form.dart';
import '../../../../widgets/main_widgets/custom_icon_button.dart';

class DataAirlinesForm extends StatefulWidget {
  const DataAirlinesForm({super.key});

  @override
  State<DataAirlinesForm> createState() => _DataAirlinesFormState();
}

class _DataAirlinesFormState extends State<DataAirlinesForm> {
  final _formKey = GlobalKey<FormState>();
  final _airlineNameController = TextEditingController();
  final _airlineCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Field label style
    TextStyle fieldLabelStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );

    // Hint Text Style
    TextStyle hintTextStyle = TextStyle(
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
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama Maskapai', style: fieldLabelStyle),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _airlineNameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Maskapai',
                        hintStyle: hintTextStyle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Kode', style: fieldLabelStyle),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _airlineCodeController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Kode Maskapai',
                        hintStyle: hintTextStyle,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveAirline();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveAirline() async {
    final service = context.read<FirebaseFirestoreService>();
    final airlineName = _airlineNameController.text;
    final airlineCode = _airlineCodeController.text;
    final navigator = Navigator.of(context);

    try {
      await service.saveAirline(
        airlineName: airlineName,
        airlineCode: airlineCode,
      );
      debugPrint('data airline berhasil disimpan!');
      navigator.pop();
    } catch (e) {
      debugPrint('Error: $e');
    }
    _airlineNameController.clear();
    _airlineCodeController.clear();
  }

  @override
  void dispose() {
    _airlineNameController.dispose();
    _airlineCodeController.dispose();
    super.dispose();
  }
}
