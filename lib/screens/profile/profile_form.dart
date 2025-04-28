import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../static/size_config.dart';
import '../../style/colors/invoice_color.dart';
import '../../widgets/main_widgets/custom_icon_button.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileFormScreen> {
  File? imageFile;
  String? base64String;
  final _formKey = GlobalKey<FormState>();
  final _travelNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _picController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 50,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: getPropScreenWidth(40)),
                    Text(
                      'Data Perusahaan',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: getPropScreenWidth(18),
                        letterSpacing: 0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: getPropScreenWidth(110),
                        width: getPropScreenWidth(110),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: imageFile != null
                                ? FileImage(imageFile!)
                                : AssetImage('assets/images/profile.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _chooseImage(),
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
                      FilledButton(
                        onPressed: _formKey.currentState!.validate() ? () {} : null,
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
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan nama travel',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAddressField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alamat Travel',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan alamat travel',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEmailField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Travel',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan email travel',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildWebsiteField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Website Travel',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan website travel',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPhoneNumberField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nomor Telepon',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan nomor telepon',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPicField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PIC',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan PIC',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
          ),
        )
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
