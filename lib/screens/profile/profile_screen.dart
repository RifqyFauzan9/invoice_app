import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_invoice_app/screens/profile/profile_form.dart';
import 'package:provider/provider.dart';

import '../../provider/firebase_auth_provider.dart';
import '../../provider/shared_preferences_provider.dart';
import '../../static/firebase_auth_status.dart';
import '../../static/screen_route.dart';
import '../../static/size_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? imageFile;

  Future chooseImage() async {
    final getImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (getImage != null) {
        imageFile = File(getImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getPropScreenWidth(70),
        elevation: 4,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 10),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return buildLogoutAlert(context);
                },
              );
            },
            icon: Icon(Icons.logout),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
        title: Text(
          'Data Perusahaan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            fontSize: getPropScreenWidth(20),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: getPropScreenWidth(120),
                        width: getPropScreenWidth(120),
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
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.zero,
                          ),
                          iconSize: 18,
                          onPressed: () => chooseImage(),
                          icon: Icon(Icons.edit_outlined),
                          color: Theme.of(context).colorScheme.onPrimary,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ProfileForm(),
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
          'Dengan logout, anda harus login kembali untuk menggunakan aplikasi InvoTek.'),
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

  void _tapToSignOut() async {
    final sharedPreferenceProvider = context.read<SharedPreferencesProvider>();
    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    final navigator = Navigator.of(context);

    await firebaseAuthProvider.signOutUser();
    switch (firebaseAuthProvider.authStatus) {
      case FirebaseAuthStatus.unauthenticated:
        await sharedPreferenceProvider.logout();
        navigator.pushReplacementNamed(ScreenRoute.login.route);

      case _:
        Flushbar(
          message: firebaseAuthProvider.message ?? '',
          messageColor: Theme.of(context).colorScheme.onError,
          messageSize: 14,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(20),
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Theme.of(context).colorScheme.error,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          icon: Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onError,
          ),
        ).show(context);
    }
  }
}
