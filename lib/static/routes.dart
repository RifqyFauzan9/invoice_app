import 'package:flutter/material.dart';
import 'package:my_invoice_app/model/common/company.dart';
import 'package:my_invoice_app/model/setup/airline.dart';
import 'package:my_invoice_app/model/setup/bank.dart';
import 'package:my_invoice_app/model/setup/item.dart';
import 'package:my_invoice_app/model/setup/note.dart';
import 'package:my_invoice_app/screens/auth/login/forgot_password/forgot_password_screen.dart';
import 'package:my_invoice_app/screens/auth/login/login_screen.dart';
import 'package:my_invoice_app/screens/auth/signup/sign_up_screen.dart';
import 'package:my_invoice_app/screens/invoice/invoice_screen.dart';
import 'package:my_invoice_app/screens/invoice/list_invoice_screen.dart';
import 'package:my_invoice_app/screens/invoice/status_invoice_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/choose_form_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/transaksi/update_invoice.dart';
import 'package:my_invoice_app/screens/profile/profile_form.dart';
import 'package:my_invoice_app/screens/report/report_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/airlines/data_airlines_form.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/airlines/data_airlines_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/bank/data_bank_form.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/bank/data_bank_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/item/data_item_form.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/item/data_item_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/note/note_form.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/note/note_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/setup_form_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/travel/data_travel_form.dart';
import 'package:my_invoice_app/screens/invoice_form/setup/travel/data_travel_screen.dart';
import 'package:my_invoice_app/screens/invoice_form/transaksi/transaksi_form.dart';
import 'package:my_invoice_app/screens/main/home_screen.dart';
import 'package:my_invoice_app/screens/profile/profile_screen.dart';
import 'package:my_invoice_app/screens/splash/real_splash_screen.dart';
import 'package:my_invoice_app/screens/splash/splash_screen.dart';
import 'package:my_invoice_app/static/form_mode.dart';
import 'package:my_invoice_app/static/screen_route.dart';

import '../model/transaction/invoice.dart';
import '../screens/auth/login/login_success/login_success_screen.dart';

final Map<String, WidgetBuilder> routes = {
  ScreenRoute.splash.route: (context) => SplashScreen(),
  ScreenRoute.login.route: (context) => LoginScreen(),
  ScreenRoute.logSuccess.route: (context) => LoginSuccessScreen(
        uid: ModalRoute.of(context)?.settings.arguments as String?,
      ),
  ScreenRoute.signUp.route: (context) => SignUpScreen(),
  ScreenRoute.forgot.route: (context) => ForgotPasswordScreen(),
  ScreenRoute.main.route: (context) => HomeScreen(
        uid: ModalRoute.of(context)?.settings.arguments as String?,
      ),
  ScreenRoute.chooseForm.route: (context) => ChooseFormScreen(),
  ScreenRoute.setup.route: (context) => SetupFormScreen(),
  ScreenRoute.transaksi.route: (context) => TransaksiForm(),
  ScreenRoute.listInvoice.route: (context) => ListInvoiceScreen(
        invoices: ModalRoute.of(context)?.settings.arguments as List<Invoice>,
      ),
  ScreenRoute.invoiceScreen.route: (context) => InvoiceScreen(
        invoice: ModalRoute.of(context)?.settings.arguments as Invoice,
      ),
  ScreenRoute.profile.route: (context) => ProfileScreen(),
  ScreenRoute.travel.route: (context) => DataTravelScreen(),
  ScreenRoute.bank.route: (context) => DataBankScreen(),
  ScreenRoute.airlines.route: (context) => DataAirlinesScreen(),
  ScreenRoute.item.route: (context) => DataItemScreen(),
  ScreenRoute.travelForm.route: (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return DataTravelForm(
      mode: args['mode'] as FormMode,
      oldTravel: args['oldTravel'] as dynamic,
    );
  },
  ScreenRoute.bankForm.route: (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return DataBankForm(
      mode: args['mode'] as FormMode,
      oldBank: args['oldBank'] as Bank?,
    );
  },
  ScreenRoute.airlinesForm.route: (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return DataAirlinesForm(
      mode: args['mode'] as FormMode,
      oldAirline: args['oldAirline'] as Airline?,
    );
  },
  ScreenRoute.itemForm.route: (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return DataItemForm(
      mode: args['mode'] as FormMode,
      oldItem: args['oldItem'] as Item?,
    );
  },
  ScreenRoute.realSplash.route: (context) => RealSplashScreen(),
  ScreenRoute.note.route: (context) => NoteScreen(),
  ScreenRoute.noteForm.route: (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return NoteForm(
      mode: args['mode'] as FormMode,
      oldNote: args['oldNote'] as Note?,
    );
  },
  ScreenRoute.report.route: (context) => ReportScreen(),
  ScreenRoute.profileForm.route: (context) => ProfileFormScreen(
        company: ModalRoute.of(context)?.settings.arguments as Company?,
      ),
  ScreenRoute.statusScreen.route: (context) => StatusInvoiceScreen(
        status: ModalRoute.of(context)?.settings.arguments as String,
      ),
  ScreenRoute.updateInvoice.route: (context) => UpdateInvoice(
        oldInvoice: ModalRoute.of(context)?.settings.arguments as Invoice,
      ),
};
