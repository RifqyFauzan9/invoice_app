import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:provider/provider.dart';

import '../../provider/firebase_auth_provider.dart';
import '../../provider/shared_preferences_provider.dart';
import '../../static/firebase_auth_status.dart';
import '../../static/screen_route.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: SizedBox(
            width: double.infinity,
            child: Column(
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
                SizedBox(height: getPropScreenWidth(16)),
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.6),
                  child: Text(
                    'PT. KAMIL TEKNO GLOBALINDO',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                buildProfileMenuItem(
                  context,
                  'Edit Data Travel',
                  () {
                    Navigator.pushNamed(
                      context,
                      ScreenRoute.profileForm.route,
                    );
                  },
                  Icons.person_2_outlined,
                ),
                const SizedBox(height: 16),
                buildProfileMenuItem(
                  context,
                  'Notification',
                  () => _showFlushBar(
                    'Sorry, this feature is not available yet ️ :(',
                    Colors.grey[600]!,
                    Icons.info_outline,
                  ),
                  Icons.notifications_on_outlined,
                ),
                const SizedBox(height: 16),
                buildProfileMenuItem(
                  context,
                  'Change Password',
                  () => _showFlushBar(
                    'Sorry, this feature is not available yet ️ :(',
                    Colors.grey[600]!,
                    Icons.info_outline,
                  ),
                  Icons.lock_outline,
                ),
                const SizedBox(height: 56),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Color(0xFFDC3545),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Logout'),
                          content: Text(
                            'Dengan logout, Anda harus login kembali untuk menggunakan InvoTek.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => _tapToSignOut(),
                              child: Text(
                                'Log out',
                                style: TextStyle(
                                  color: Color(0xFFDC3545),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFlushBar(String text, Color bgColor, IconData icon) {
    Flushbar(
      message: text,
      messageColor: Theme.of(context).colorScheme.onPrimary,
      messageSize: 12,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: bgColor,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    ).show(context);
  }

  Widget buildProfileMenuItem(
    BuildContext context,
    String text,
    VoidCallback onPressed,
    IconData icon,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Color(0xFFF1F2F4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                text,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
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
