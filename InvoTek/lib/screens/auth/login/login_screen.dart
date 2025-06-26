import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_invoice_app/screens/auth/login/login_form.dart';
import 'package:my_invoice_app/static/size_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                      top: SizeConfig.screenHeight * 0.03,
                      left: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        'assets/svgs/sign_in.svg',
                        width: SizeConfig.screenWidth * 0.85,
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
                                'Let\'s Sign in',
                                style: TextStyle(
                                  fontSize: getPropScreenWidth(24),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                ),
                              ),
                              const SizedBox(height: 16),
                              LoginForm(),
                              const SizedBox(height: 16),
                              Text.rich(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                                TextSpan(
                                    text: 'By signing in, You agree to our ',
                                    children: [
                                      TextSpan(
                                        text: 'Term of Service ',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(text: 'and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
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
        ));
  }
}
