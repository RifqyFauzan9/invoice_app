import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/firebase_firestore_service.dart';
import '../../../../widgets/invoice_form/section_title_form.dart';
import '../../../../widgets/main_widgets/custom_icon_button.dart';

class DataItemForm extends StatefulWidget {
  const DataItemForm({super.key});

  @override
  State<DataItemForm> createState() => _DataItemFormState();
}

class _DataItemFormState extends State<DataItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _itemCodeController = TextEditingController();

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
                  text: 'Add Item Data',
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kode Item', style: fieldLabelStyle),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _itemCodeController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Kode Item',
                        hintStyle: hintTextStyle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Nama Item', style: fieldLabelStyle),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _itemNameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Item',
                        hintStyle: hintTextStyle,
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveItem();
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

  void _saveItem() async {
    final service = context.read<FirebaseFirestoreService>();
    final itemName = _itemNameController.text;
    final itemCode = _itemCodeController.text;
    final navigator = Navigator.of(context);

    try {
      await service.saveItem(
        itemName: itemName,
        itemCode: itemCode,
      );
      debugPrint('data item berhasil disimpan!');
      navigator.pop();
    } catch (e) {
      debugPrint('Error: $e');
    }
    _itemNameController.clear();
    _itemCodeController.clear();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemCodeController.dispose();
    super.dispose();
  }
}
