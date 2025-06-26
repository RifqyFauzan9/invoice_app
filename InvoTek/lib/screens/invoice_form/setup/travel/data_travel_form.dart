import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/provider/profile_provider.dart';
import 'package:my_invoice_app/services/travel_service.dart';
import 'package:my_invoice_app/static/form_mode.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:provider/provider.dart';

import '../../../../model/setup/travel.dart';
import '../../../../style/colors/invoice_color.dart';
import '../../../../widgets/invoice_form/section_title_form.dart';

class DataTravelForm extends StatefulWidget {
  const DataTravelForm({
    super.key,
    required this.mode,
    this.oldTravel,
  });

  final FormMode mode;
  final Travel? oldTravel;

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == FormMode.edit && widget.oldTravel != null) {
      _nameController.text = widget.oldTravel!.travelName;
      _contactPersonController.text = widget.oldTravel!.contactPerson;
      _addressController.text = widget.oldTravel!.travelAddress;
      _phoneController.text = widget.oldTravel!.phoneNumber.toString();
      _emailController.text = widget.oldTravel!.emailAddress;
    }
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
    TextStyle hintTextStyle = GoogleFonts.montserrat(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                    CustomIconButton(
                      icon: Icons.sync,
                      onPressed: () => _resetForm(),
                    ),
                  ],
                ),
                SizedBox(height: getPropScreenWidth(15)),
                Align(
                  alignment: Alignment.center,
                  child: SectionTitleForm(
                    text: widget.mode == FormMode.add
                        ? 'Add Travel Data'
                        : 'Edit Travel Data',
                  ),
                ),
                SizedBox(height: getPropScreenWidth(15)),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Travel', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nama Travel',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama travel tidak boleh kosong!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Kontak Person', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _contactPersonController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Kontak Person',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kontak person tidak boleh kosong!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Alamat', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _addressController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Alamat Travel',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat travel tidak boleh kosong!';
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nomor Telepon',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor telepon tidak boleh kosong!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Email', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _emailController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Email Travel',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email travel tidak boleh kosong!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      isLoading
                          ? Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: InvoiceColor.primary.color,
                                size: getPropScreenWidth(30),
                              ),
                            )
                          : FilledButton(
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
    final service = context.read<TravelService>();
    final travelName = _nameController.text;
    final contactPerson = _contactPersonController.text;
    final address = _addressController.text;
    final phone = _phoneController.text;
    final email = _emailController.text;
    final navigator = Navigator.of(context);
    final travelId = widget.oldTravel != null && widget.mode == FormMode.edit
        ? widget.oldTravel!.travelId
        : await service.generateTravelIdFromFirestore(
            context.read<ProfileProvider>().person!.companyId!);

    setState(() {
      isLoading = true;
    });

    try {
      await service.saveTravel(
        companyId: context.read<ProfileProvider>().person!.companyId!,
        travelId: travelId,
        travelName: travelName,
        contactPerson: contactPerson,
        travelAddress: address,
        phoneNumber: phone,
        emailAddress: email,
      );
      debugPrint('data travel berhasil disimpan!');
      navigator.pop();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    _nameController.clear();
    _contactPersonController.clear();
    _addressController.clear();
    _phoneController.clear();
    _emailController.clear();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
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
