import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/screens/auth/login/forgot_password/forgot_password_form.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: SizeConfig.screenHeight * 0.04,
                    left: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      'assets/svgs/otp.svg',
                      width: SizeConfig.screenWidth * 0.9,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: SizeConfig.screenHeight * 0.65,
                      ),
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                        horizontal: getPropScreenWidth(25),
                        vertical: getPropScreenWidth(60),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: getPropScreenWidth(24),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                                'Enter your email, and we\'ll send you a magic link to bring you back to your account!',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                )),
                            const SizedBox(height: 16),
                            ForgotPasswordForm(),
                            const SizedBox(height: 16),
                            Center(
                              child: Text.rich(
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                                TextSpan(
                                  text: 'Don\'t have an account? ',
                                  children: [
                                    TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushNamed(
                                              context,
                                              ScreenRoute.signUp.route,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       backgroundColor: Theme.of(context).colorScheme.primary,
  //       body: SafeArea(
  //         child: SizedBox(
  //           width: double.infinity,
  //           child: SingleChildScrollView(
  //             child: Stack(
  //               children: [
  //                 SizedBox(height: MediaQuery.of(context).size.height),
  //                 Positioned(
  //                   left: 0,
  //                   right: 0,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(32),
  //                     child: SvgPicture.asset('assets/images/otp.svg'),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   bottom: 0,
  //                   child: Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     padding: EdgeInsets.symmetric(
  //                       horizontal: 30,
  //                       vertical: 60,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: Theme.of(context).colorScheme.surface,
  //                       borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(20),
  //                         topRight: Radius.circular(20),
  //                       ),
  //                     ),
  //                     child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'Forgot Password?',
  //                             style: GoogleFonts.montserrat(
  //                               fontSize: 28,
  //                               fontWeight: FontWeight.bold,
  //                               letterSpacing: 0,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 7),
  //                           Text(
  //                             'Enter your email, and we\'ll send you a magic link to bring you back to your account!',
  //                             style: GoogleFonts.montserrat(
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w500,
  //                               letterSpacing: 0,
  //                             )
  //                           ),
  //                           const SizedBox(height: 16),
  //                           ForgotPasswordForm(),
  //                           const SizedBox(height: 16),
  //                           Align(
  //                             alignment: Alignment.center,
  //                             child: Text.rich(
  //                               style: GoogleFonts.montserrat(
  //                                 fontSize: 14,
  //                                 letterSpacing: 0,
  //                                 fontWeight: FontWeight.normal,
  //                               ),
  //                               TextSpan(
  //                                 text: 'Don\'t have an account? ',
  //                                 children: [
  //                                   TextSpan(
  //                                     text: 'Sign Up',
  //                                     style: TextStyle(
  //                                       color: Theme.of(context).colorScheme.primary,
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                     recognizer: TapGestureRecognizer()
  //                                       ..onTap = () => Navigator.pushNamed(
  //                                         context,
  //                                         ScreenRoute.signUp.route,
  //                                       ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ));
  // }
}
