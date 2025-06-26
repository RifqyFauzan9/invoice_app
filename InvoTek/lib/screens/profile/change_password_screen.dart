import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../static/size_config.dart';
import '../../style/colors/invoice_color.dart';
import '../../widgets/main_widgets/custom_icon_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreen();
}

class _ChangePasswordScreen extends State<ChangePasswordScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _lastPasswordCotroller = TextEditingController();
  final _newPasswordController = TextEditingController();
  String? _lastPasswordError;
  bool _lastPwObsecure = true;
  bool _newPwObsecure = true;

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
                      'Change Password',
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
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEmailField(_emailController),
                      const SizedBox(height: 8),
                      _buildLastPasswordField(_lastPasswordCotroller),
                      const SizedBox(height: 8),
                      _buildNewPasswordField(_newPasswordController),
                      const SizedBox(height: 24),
                      isLoading
                          ? Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: Theme.of(context).colorScheme.primary,
                                size: getPropScreenWidth(30),
                              ),
                            )
                          : FilledButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Change Password?'),
                                      content: Text(
                                        'By changing your password, you must enter the app with new password you submitted',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _tapToChangePassword();
                                          },
                                          child: const Text('Change Password'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Change Password'),
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

  Future<void> changeUserPassword({
    required String email,
    required String lastPassword,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email != email) {
      throw 'Current user email does not match the provided email.';
    }

    // Re-authenticate
    final credential = EmailAuthProvider.credential(
      email: email,
      password: lastPassword,
    );

    await user.reauthenticateWithCredential(credential);

    // Update password
    await user.updatePassword(newPassword);
  }

  void _tapToChangePassword() async {
    final email = _emailController.text.trim();
    final lastPassword = _lastPasswordCotroller.text.trim();
    final newPassword = _newPasswordController.text.trim();

    setState(() {
      _lastPasswordError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(context); // tutup dialog
    setState(() => isLoading = true);

    try {
      await changeUserPassword(
        email: email,
        lastPassword: lastPassword,
        newPassword: newPassword,
      );

      Navigator.pop(context, true); // tutup screen ini
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        setState(() {
          _lastPasswordError = 'Old password is incorrect';
        });
      } else {
        _showFlushbar(
          e.message ?? 'Something went wrong',
          Theme.of(context).colorScheme.error,
          Icons.error_outline,
        );
      }
    } catch (e) {
      _showFlushbar(
        e.toString(),
        Theme.of(context).colorScheme.error,
        Icons.error_outline,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showFlushbar(String message, Color bgColor, IconData icon) {
    Flushbar(
      message: message,
      messageColor: Theme.of(context).colorScheme.onPrimary,
      messageSize: 12,
      duration: const Duration(seconds: 3),
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

  @override
  void dispose() {
    _lastPasswordCotroller.dispose();
    _newPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget _buildEmailField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Email',
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
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan email anda',
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

  Widget _buildLastPasswordField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last Password',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )),
        const SizedBox(height: 4),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          controller: controller,
          obscureText: _lastPwObsecure,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _lastPwObsecure = !_lastPwObsecure;
                  });
                },
                icon: Icon(
                  _lastPwObsecure ? Icons.visibility : Icons.visibility_off,
                )),
            hintText: 'Masukkan last password',
            hintStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: InvoiceColor.primary.color.withOpacity(0.3),
            ),
            errorText: _lastPasswordError, // Tambahkan ini
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill up the form!';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 letters!';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNewPasswordField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('New Password',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0,
            )),
        const SizedBox(height: 4),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          controller: controller,
          obscureText: _newPwObsecure,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _newPwObsecure = !_newPwObsecure;
                  });
                },
                icon: Icon(
                  _newPwObsecure ? Icons.visibility : Icons.visibility_off,
                )),
            hintText: 'Masukkan New Password',
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
            if (value.length < 6) {
              return 'Password must be at least 6 letters!';
            }
            return null;
          },
        ),
      ],
    );
  }
}
