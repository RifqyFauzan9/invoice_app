import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:provider/provider.dart';

import '../../model/profile.dart';
import '../../provider/firebase_auth_provider.dart';
import '../../provider/shared_preferences_provider.dart';
import '../../static/screen_route.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? imageFile;
  bool _isObsecure = true;
  late final Profile? _profile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    _profile = firebaseAuthProvider.profile;
    _emailController.text = _profile!.email!;
    _roleController.text = _profile.role!.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Hint Text Style
    TextStyle hintTextStyle = GoogleFonts.montserrat(
      color: Theme.of(context).colorScheme.primary,
      fontSize: getPropScreenWidth(16),
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Personal Data',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return buildLogoutAlert(context);
                },
              );
            },
            icon: Icon(Icons.logout_outlined),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: IntrinsicWidth(
                    child: Container(
                      padding: EdgeInsets.all(getPropScreenWidth(30)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        _profile!.email!.substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: getPropScreenWidth(35),
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your Role',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  style: hintTextStyle,
                  readOnly: true,
                  controller: _roleController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          width: 2,
                        ),
                      )),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your Email',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  readOnly: true,
                  style: hintTextStyle,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your Password',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  style: hintTextStyle,
                  readOnly: true,
                  obscureText: _isObsecure,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObsecure = !_isObsecure;
                        });
                      },
                      icon: Icon(
                        _isObsecure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog buildLogoutAlert(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Logout',
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      content: Text(
          'Dengan logout, anda harus login kembali untuk bisa menggunakan aplikasi InvoTek.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => _tapToSignOut(),
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Color(0xFFDC3545),
            ),
          ),
        ),
      ],
    );
  }

  void chooseImage() async {
    final getImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      if (getImage != null) {
        imageFile = File(getImage.path);
      }
    });
  }

  void _tapToSignOut() async {
    final sharedPreferenceProvider = context.read<SharedPreferencesProvider>();
    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    final navigator = Navigator.of(context);

    await firebaseAuthProvider.signOutUser().then((value) async {
      await sharedPreferenceProvider.logout();
      navigator.pushReplacementNamed(
        ScreenRoute.login.route,
      );
    }).whenComplete(() {
      Flushbar(
        message: 'Berhasil Logout!',
        messageColor: Theme.of(context).colorScheme.onPrimary,
        messageSize: 12,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Color(0xFF28A745),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
        icon: Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ).show(context);
    });
  }
}
