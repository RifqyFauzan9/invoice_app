import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../provider/firebase_auth_provider.dart';
import '../../static/firebase_auth_status.dart';

class ProfileForm extends StatelessWidget {
  ProfileForm({super.key});

  final _formKey = GlobalKey<FormState>();

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
            decoration: InputDecoration(
              hintText: 'Masukkan Nama Perusahaan',
              hintStyle: hintTextStyle,
            ),
          ),
          const SizedBox(height: 16),
          Text('Alamat Perusahaan', style: fieldLabelStyle),
          const SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Masukkan Alamat Perusahaan',
              hintStyle: hintTextStyle,
            ),
          ),
          const SizedBox(height: 16),
          Text('Email Perusahaan', style: fieldLabelStyle),
          const SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Masukkan Email Perusahaan',
              hintStyle: hintTextStyle,
            ),
          ),
          const SizedBox(height: 16),
          Text('Website Perusahaan', style: fieldLabelStyle),
          const SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Masukkan Website Perusahaan',
              hintStyle: hintTextStyle,
            ),
          ),
          const SizedBox(height: 16),
          Text('Nomor Telepon Perusahaan', style: fieldLabelStyle),
          const SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Masukkan Nomor Telepon Perusahaan',
              hintStyle: hintTextStyle,
            ),
          ),
          const SizedBox(height: 16),
          Text('PIC Perusahaan', style: fieldLabelStyle),
          const SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Masukkan PIC Perusahaan',
              hintStyle: hintTextStyle,
            ),
          ),
          const SizedBox(height: 32),
          Consumer<FirebaseAuthProvider>(
            builder: (context, value, child) {
              return switch (value.authStatus) {
                FirebaseAuthStatus.signingOut => Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Theme.of(context).colorScheme.error,
                      size: 32,
                    ),
                  ),
                _ => SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: null,
                      child: const Text('Save'),
                    ),
                  ),
              };
            },
          )
        ],
      ),
    );
  }
}
