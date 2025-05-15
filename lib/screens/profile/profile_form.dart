import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/model/common/company.dart';
import 'package:my_invoice_app/provider/company_provider.dart';
import 'package:my_invoice_app/provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/services/company_service.dart';
import 'package:provider/provider.dart';

import '../../static/size_config.dart';
import '../../style/colors/invoice_color.dart';
import '../../widgets/main_widgets/custom_icon_button.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({
    super.key,
    required this.company,
  });

  final Company? company;

  @override
  State<ProfileFormScreen> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileFormScreen> {
  File? imageFile;
  String? base64String;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _travelNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _picController = TextEditingController();
  Uint8List? _companyLogoBytes;

  @override
  void initState() {
    _initializeFormData();
    super.initState();
  }

  void _initializeFormData() {
    final company = widget.company;

    if (company != null) {
      _travelNameController.text = company.companyName;
      _addressController.text = company.companyAddress;
      _emailController.text = company.companyEmail;
      _websiteController.text = company.companyWebsite;
      _phoneNumberController.text = company.companyPhone.toString();
      _picController.text = company.companyPic;

      base64String = company.companyLogo;
      if (base64String != null) {
        try {
          _companyLogoBytes = base64Decode(base64String!);
        } catch (e) {
          debugPrint('Failed to decode logo: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      'Edit Profile',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: getPropScreenWidth(20),
                        letterSpacing: 0,
                        color: InvoiceColor.primary.color,
                      ),
                    ),
                    SizedBox(width: getPropScreenWidth(30)),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Card(
                        color: Colors.white,
                        child: Container(
                          height: SizeConfig.screenHeight * 0.1,
                          width: SizeConfig.screenWidth * 0.65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image:
                                imageFile != null || _companyLogoBytes != null
                                    ? DecorationImage(
                                        image: imageFile != null
                                            ? FileImage(imageFile!)
                                            : MemoryImage(_companyLogoBytes!),
                                      )
                                    : null,
                          ),
                          child: imageFile == null && _companyLogoBytes == null
                              ? Center(
                                  child: Text(
                                    'Landscape Logo',
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: getPropScreenWidth(18),
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        right: -5,
                        bottom: -5,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(
                                      'For better appearance, use a landscape logo with background removed'),
                                );
                              },
                            );
                            _chooseImage();
                          },
                          icon: Icon(Icons.edit_outlined),
                          color: Theme.of(context).colorScheme.onPrimary,
                          iconSize: getPropScreenWidth(16),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTravelField(_travelNameController),
                      const SizedBox(height: 8),
                      _buildAddressField(_addressController),
                      const SizedBox(height: 8),
                      _buildEmailField(_emailController),
                      const SizedBox(height: 8),
                      _buildWebsiteField(_websiteController),
                      const SizedBox(height: 8),
                      _buildPhoneNumberField(_phoneNumberController),
                      const SizedBox(height: 8),
                      _buildPicField(_picController),
                      const SizedBox(height: 24),
                      isLoading
                          ? Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: Theme.of(context).colorScheme.primary,
                                size: getPropScreenWidth(30),
                              ),
                            )
                          : FilledButton(
                              onPressed: () => _saveCompany(),
                              child: Text('Save'),
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

  @override
  void dispose() {
    _travelNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _phoneNumberController.dispose();
    _picController.dispose();
    super.dispose();
  }

  void _saveCompany() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final service = context.read<CompanyService>();
      final navigator = Navigator.of(context);

      try {
        final newCompany = Company(
          base64String ??
              (_companyLogoBytes != null
                  ? base64Encode(_companyLogoBytes!)
                  : null),
          companyName: _travelNameController.text,
          companyAddress: _addressController.text,
          companyEmail: _emailController.text,
          companyWebsite: _websiteController.text,
          companyPhone: int.tryParse(_phoneNumberController.text) ?? 0,
          companyPic: _picController.text,
        );

        await service.saveCompanyData(
          context.read<FirebaseAuthProvider>().profile!.uid!,
          newCompany,
        );
        context.read<CompanyProvider>().setCompany(newCompany);
        debugPrint('Data company berhasil disimpan!');
        navigator.pop(newCompany);
      } catch (e) {
        debugPrint('Error saving company data: $e');
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  Widget _buildTravelField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama Travel',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan nama travel',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill up the form!';
            }
            return null;
          },
        )
      ],
    );
  }

  Widget _buildAddressField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alamat Travel',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )),
        const SizedBox(height: 4),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.next,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan alamat travel',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill up the form!';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email Travel',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )),
        const SizedBox(height: 4),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan email travel',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill up the form!';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildWebsiteField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Website Travel',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )),
        const SizedBox(height: 4),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan website travel',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill up the form!';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nomor Telepon',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )),
        const SizedBox(height: 4),
        TextFormField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan nomor telepon',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill up the form!';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPicField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PIC',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )),
        const SizedBox(height: 4),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan PIC',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill up the form!';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _chooseImage() async {
    final getImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (getImage != null) {
      setState(() {
        imageFile = File(getImage.path);
      });

      List<int> imageBytes = File(getImage.path).readAsBytesSync();
      base64String = base64Encode(imageBytes);
    } else {
      debugPrint('getImage null!');
    }
  }
}
