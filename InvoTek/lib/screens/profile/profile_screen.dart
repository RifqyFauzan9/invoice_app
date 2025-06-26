import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/provider/profile_provider.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';
import '../../provider/firebase_auth_provider.dart';
import '../../provider/shared_preferences_provider.dart';
import '../../static/firebase_auth_status.dart';
import '../../static/screen_route.dart';
import '../../widgets/main_widgets/custom_icon_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getPropScreenWidth(30),
            vertical: getPropScreenWidth(60),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
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
                      'My Profile',
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
                SizedBox(height: SizeConfig.screenHeight * 0.07),
                Card(
                  color: Colors.white,
                  child: Container(
                      padding: EdgeInsets.all(getPropScreenWidth(8)),
                      alignment: Alignment.center,
                      height: SizeConfig.screenHeight * 0.1,
                      width: SizeConfig.screenWidth * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: profile?.profileLogo != null
                          ? Image.memory(
                              base64Decode(profile!.profileLogo!),
                              fit: BoxFit.contain,
                            )
                          : null),
                ),
                SizedBox(height: getPropScreenWidth(12)),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.8,
                  child: Column(
                    children: [
                      Text(
                        profile?.profileName ?? 'No Profile Name',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: getPropScreenWidth(20),
                          letterSpacing: 0,
                        ),
                      ),
                      Text(
                        profile?.profileAddress ?? 'No Profile Address',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: getPropScreenWidth(17),
                          letterSpacing: 0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
                      arguments: profile,
                    );
                  },
                  Icons.person_2_outlined,
                ),
                const SizedBox(height: 16),
                buildProfileMenuItem(
                  context,
                  'Change Password',
                  () async {
                    final result = await Navigator.pushNamed(
                        context, ScreenRoute.changePassword.route);

                    if (result == true) {
                      _showFlushBar(
                        'Password Changed Successfully!',
                        Color(0xFF28A745),
                        Icons.check_circle_outline,
                      );
                    }
                  },
                  Icons.lock_outline,
                ),
                const SizedBox(height: 16),
                buildProfileMenuItem(
                  context,
                  'Notification',
                  () => _showFlushBar(
                    'Sorry, this feature is not available yet ️ :(',
                    InvoiceColor.info.color,
                    Icons.info_outline,
                  ),
                  Icons.notifications_on_outlined,
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
          color: Colors.white,
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
    final profileProvider = context.read<ProfileProvider>();
    final navigator = Navigator.of(context);

    await firebaseAuthProvider.signOutUser();
    firebaseAuthProvider.reset();
    profileProvider.reset();
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
          backgroundColor: InvoiceColor.error.color,
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
