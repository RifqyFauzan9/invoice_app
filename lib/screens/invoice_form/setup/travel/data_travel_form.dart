import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/services/firebase_firestore_service.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/invoice_form/section_title_form.dart';

class DataTravelForm extends StatefulWidget {
  const DataTravelForm({super.key});

  @override
  State<DataTravelForm> createState() => _DataTravelFormState();
}

class _DataTravelFormState extends State<DataTravelForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

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
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Travel', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nama Travel',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon isi form dengan benar!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Kontak Person', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _contactPersonController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Kontak Person',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon isi form dengan benar!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Alamat', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _addressController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Alamat Travel',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon isi form dengan benar!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Nomor Telepon', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _phoneController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nomor Telepon',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon isi form dengan benar!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Email', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Email Travel',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon isi form dengan benar!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveTravel();
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
      ),
    );
  }

  void _saveTravel() async {
    final service = context.read<FirebaseFirestoreService>();
    final travelName = _nameController.text;
    final contactPerson = _contactPersonController.text;
    final address = _addressController.text;
    final phone = int.tryParse(_phoneController.text);
    final email = _emailController.text;
    final navigator = Navigator.of(context);

    try {
      await service.saveTravel(
        travelName: travelName,
        contactPerson: contactPerson,
        travelAddress: address,
        phoneNumber: phone ?? 08,
        emailAddress: email,
      );
      debugPrint('data travel berhasil disimpan!');
      navigator.pop();
    } catch (e) {
      debugPrint('Error: $e');
    }
    _nameController.clear();
    _contactPersonController.clear();
    _addressController.clear();
    _phoneController.clear();
    _emailController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactPersonController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
