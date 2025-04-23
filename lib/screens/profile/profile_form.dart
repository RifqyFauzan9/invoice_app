import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/firebase_auth_provider.dart';
import '../../services/firebase_firestore_service.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  // Text Controllers
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _companyWebsiteController = TextEditingController();
  final _companyPhoneController = TextEditingController();
  final _companyPicController = TextEditingController();

  // Form Key
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _loadData();
    });
  }

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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama Perusahaan', style: fieldLabelStyle),
          const SizedBox(height: 4),
          TextFormField(
            controller: _companyNameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Masukkan Nama Perusahaan',
              hintStyle: hintTextStyle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Silahkan isi formnya dengan benar!';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text('Alamat Perusahaan', style: fieldLabelStyle),
          const SizedBox(height: 4),
          TextFormField(
            controller: _companyAddressController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Masukkan Alamat Perusahaan',
              hintStyle: hintTextStyle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Silahkan isi formnya dengan benar!';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text('Email Perusahaan', style: fieldLabelStyle),
          const SizedBox(height: 4),
          TextFormField(
            controller: _companyEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Masukkan Email Perusahaan',
              hintStyle: hintTextStyle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Silahkan isi formnya dengan benar!';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text('Website Perusahaan', style: fieldLabelStyle),
          const SizedBox(height: 4),
          TextFormField(
            controller: _companyWebsiteController,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Masukkan Website Perusahaan',
              hintStyle: hintTextStyle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Silahkan isi formnya dengan benar!';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text('Nomor Telepon Perusahaan', style: fieldLabelStyle),
          const SizedBox(height: 4),
          TextFormField(
            controller: _companyPhoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Masukkan Nomor Telepon Perusahaan',
              hintStyle: hintTextStyle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Silahkan isi formnya dengan benar!';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text('PIC Perusahaan', style: fieldLabelStyle),
          const SizedBox(height: 4),
          TextFormField(
            controller: _companyPicController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Masukkan PIC Perusahaan',
              hintStyle: hintTextStyle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Silahkan isi formnya dengan benar!';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveData();
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    final profile = context.read<FirebaseAuthProvider>().profile;
    if (profile == null || profile.uid == null) return;
    final uid = profile.uid;
    final service = context.read<FirebaseFirestoreService>();
    final data = await service.getCompanyData(uid!);

    if (data != null) {
      _companyNameController.text = data['companyName'] ?? '';
      _companyAddressController.text = data['companyAddress'] ?? '';
      _companyEmailController.text = data['companyEmail'] ?? '';
      _companyWebsiteController.text = data['companyWebsite'] ?? '';
      _companyPhoneController.text = data['companyPhone'].toString();
      _companyPicController.text = data['companyPic'] ?? '';
    } else {
      debugPrint('Data null!');
    }
  }

  Future<void> _saveData() async {
    final service = context.read<FirebaseFirestoreService>();
    final uid = context.read<FirebaseAuthProvider>().profile?.uid;
    final companyName = _companyNameController.text.trim();
    final companyAddress = _companyAddressController.text.trim();
    final companyEmail = _companyEmailController.text.trim();
    final companyWebsite = _companyWebsiteController.text.trim();
    final companyPhone = int.tryParse(_companyPhoneController.text.trim())!;
    final companyPic = _companyPicController.text.trim();

    await service.saveCompanyData(
      uid: uid!,
      companyName: companyName,
      companyAddress: companyAddress,
      companyEmail: companyEmail,
      companyWebsite: companyWebsite,
      companyPhone: companyPhone,
      companyPic: companyPic,
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _companyEmailController.dispose();
    _companyWebsiteController.dispose();
    _companyPhoneController.dispose();
    _companyPicController.dispose();
    super.dispose();
  }
}
