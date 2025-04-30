import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/firebase_firestore_service.dart';
import '../../../../widgets/invoice_form/section_title_form.dart';
import '../../../../widgets/main_widgets/custom_icon_button.dart';

class DataBankForm extends StatefulWidget {
  const DataBankForm({super.key});

  @override
  State<DataBankForm> createState() => _DataBankFormState();
}

class _DataBankFormState extends State<DataBankForm> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _branchController = TextEditingController();
  final _accountHolderController = TextEditingController();

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
                  text: 'Add Bank Data',
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama Bank', style: fieldLabelStyle),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _bankNameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Bank',
                        hintStyle: hintTextStyle,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon isi form dengan benar.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text('Nomor Rekening', style: fieldLabelStyle),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _accountNumberController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nomor Rekening',
                        hintStyle: hintTextStyle,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon isi form dengan benar.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text('Cabang', style: fieldLabelStyle),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _branchController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Cabang Bank',
                        hintStyle: hintTextStyle,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon isi form dengan benar.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text('Atas Nama', style: fieldLabelStyle),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _accountHolderController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Pemegang Akun',
                        hintStyle: hintTextStyle,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon isi form dengan benar.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveBank();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBank() async {
    final service = context.read<FirebaseFirestoreService>();
    final bankName = _bankNameController.text;
    final accountNumber = int.tryParse(_accountNumberController.text);
    final branch = _branchController.text;
    final accountHolder = _accountHolderController.text;
    final navigator = Navigator.of(context);

    try {
      await service.saveBank(
        bankName: bankName,
        accountNumber: accountNumber ?? 0,
        branch: branch,
        accountHolder: accountHolder,
      );
      debugPrint('data bank berhasil disimpan!');
      navigator.pop();
    } catch (e) {
      debugPrint('Error: $e');
    }
    _bankNameController.clear();
    _accountNumberController.clear();
    _branchController.clear();
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _branchController.dispose();
    super.dispose();
  }
}
