import 'package:flutter/material.dart';
import 'package:my_invoice_app/screens/auth/login/forgot_password/forgot_password_screen.dart';
import 'package:my_invoice_app/screens/auth/login/login_screen.dart';
import 'package:my_invoice_app/screens/auth/login/login_success/login_success_screen.dart';
import 'package:my_invoice_app/screens/auth/signup/sign_up_screen.dart';
import 'package:my_invoice_app/screens/invoice/invoice_screen.dart';
import 'package:my_invoice_app/screens/invoice/list_invoice_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/choose_form_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/airlines/data_airlines_form.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/airlines/data_airlines_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/bank/data_bank_form.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/bank/data_bank_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/item/data_item_form.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/item/data_item_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/setup_form_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/travel/data_travel_form.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/travel/data_travel_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/transaksi/transaksi_form.dart';
import 'package:my_invoice_app/screens/main/home_screen.dart';
import 'package:my_invoice_app/screens/profile/profile_screen.dart';
import 'package:my_invoice_app/screens/splash/real_splash_screen.dart';
import 'package:my_invoice_app/screens/splash/splash_screen.dart';
import 'package:my_invoice_app/static/screen_route.dart';

final Map<String, WidgetBuilder> routes = {
  ScreenRoute.splash.route: (context) => SplashScreen(),
  ScreenRoute.login.route: (context) => LoginScreen(),
  ScreenRoute.logSuccess.route: (context) => LoginSuccessScreen(),
  ScreenRoute.signUp.route: (context) => SignUpScreen(),
  ScreenRoute.forgot.route: (context) => ForgotPasswordScreen(),
  ScreenRoute.main.route: (context) => HomeScreen(),
  ScreenRoute.chooseForm.route: (context) => ChooseFormScreen(),
  ScreenRoute.setup.route: (context) => SetupFormScreen(),
  ScreenRoute.transaksi.route: (context) => TransaksiForm(),
  ScreenRoute.listInvoice.route: (context) => ListInvoiceScreen(),
  ScreenRoute.invoiceScreen.route: (context) => InvoiceScreen(),
  ScreenRoute.profile.route: (context) => ProfileScreen(),
  ScreenRoute.travel.route: (context) => DataTravelScreen(),
  ScreenRoute.bank.route: (context) => DataBankScreen(),
  ScreenRoute.airlines.route: (context) => DataAirlinesScreen(),
  ScreenRoute.item.route: (context) => DataItemScreen(),
  ScreenRoute.travelForm.route: (context) => DataTravelForm(),
  ScreenRoute.bankForm.route: (context) => DataBankForm(),
  ScreenRoute.airlinesForm.route: (context) => DataAirlinesForm(),
  ScreenRoute.itemForm.route: (context) => DataItemForm(),
  ScreenRoute.realSplash.route: (context) => RealSplashScreen(),
};