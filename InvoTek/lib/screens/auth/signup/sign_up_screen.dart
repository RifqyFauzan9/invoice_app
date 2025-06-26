import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_invoice_app/screens/auth/signup/sign_up_form.dart';
import 'package:my_invoice_app/static/size_config.dart';
import '../../../static/screen_route.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                    left: 0,
                    right: 0,
                    child: Positioned(
                      top: SizeConfig.screenHeight * 0.03,
                      left: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        'assets/svgs/sign_up.svg',
                        width: SizeConfig.screenWidth * 0.85,
                      ),
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
                              'Hello,',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'Please Sign Up',
                              style: TextStyle(
                                fontSize: getPropScreenWidth(24),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                              ),
                            ),
                            SizedBox(height: getPropScreenWidth(14)),
                            SignUpForm(),
                            SizedBox(height: getPropScreenWidth(14)),
                            Center(
                              child: Text.rich(
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                                TextSpan(
                                  text: 'Already have an account? ',
                                  children: [
                                    TextSpan(
                                      text: 'Sign In',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushNamed(
                                              context,
                                              ScreenRoute.login.route,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
}
