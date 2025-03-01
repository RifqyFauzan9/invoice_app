import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_invoice_app/firebase_options.dart';
import 'package:my_invoice_app/screens/auth/login/forgot_password/forgot_password_screen.dart';
import 'package:my_invoice_app/screens/auth/login/login_screen.dart';
import 'package:my_invoice_app/screens/auth/login/login_success/login_success_screen.dart';
import 'package:my_invoice_app/screens/auth/signup/sign_up_screen.dart';
import 'package:my_invoice_app/screens/home/home_screen.dart';
import 'package:my_invoice_app/screens/home/invoice/invoice_form.dart';
import 'package:my_invoice_app/screens/home/invoice/invoice_screen.dart';
import 'package:my_invoice_app/screens/splash/splash_screen.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/style/theme/invoice_theme.dart';
import 'package:my_invoice_app/style/typography/text_theme.dart';

import 'screens/home/invoice/list_invoice_screen.dart';
import 'screens/home/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Brigthness of the platform
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Generate text theme
    TextTheme textTheme = createTextTheme(context, "Montserrat", "Montserrat");

    // Generate theme of the App
    InvoiceTheme theme = InvoiceTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Invoice App',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      initialRoute: ScreenRoute.splash.route,
      routes: {
        ScreenRoute.splash.route: (context) => SplashScreen(),
        ScreenRoute.login.route: (context) => LoginScreen(),
        ScreenRoute.logSuccess.route: (context) => LoginSuccessScreen(),
        ScreenRoute.signUp.route: (context) => SignUpScreen(),
        ScreenRoute.forgot.route: (context) => ForgotPasswordScreen(),
        ScreenRoute.main.route: (context) => HomeScreen(),
        ScreenRoute.listInvoice.route: (context) => ListInvoiceScreen(),
        ScreenRoute.invoiceForm.route: (context) => InvoiceForm(),
        ScreenRoute.invoiceScreen.route: (context) => InvoiceScreen(),
        ScreenRoute.profile.route: (context) => ProfileScreen(),
      },
    );
  }
}
