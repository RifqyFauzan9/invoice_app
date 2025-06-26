import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_invoice_app/firebase_options.dart';
import 'package:my_invoice_app/provider/profile_provider.dart';
import 'package:my_invoice_app/provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/provider/shared_preferences_provider.dart';
import 'package:my_invoice_app/services/airline_service.dart';
import 'package:my_invoice_app/services/app_service/firebase_auth_service.dart';
import 'package:my_invoice_app/services/app_service/firebase_firestore_service.dart';
import 'package:my_invoice_app/services/app_service/shared_preferences_service.dart';
import 'package:my_invoice_app/services/bank_service.dart';
import 'package:my_invoice_app/services/profile_service.dart';
import 'package:my_invoice_app/services/invoice_service.dart';
import 'package:my_invoice_app/services/item_service.dart';
import 'package:my_invoice_app/services/note_service.dart';
import 'package:my_invoice_app/services/travel_service.dart';
import 'package:my_invoice_app/static/routes.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/style/theme/invoice_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => SharedPreferencesService(pref),
        ),
        Provider(
          create: (context) => FirebaseAuthService(firebaseAuth),
        ),
        Provider(
          create: (context) => FirebaseFirestoreService(firebaseFirestore),
        ),
        Provider(
          create: (context) => AirlineService(firebaseFirestore),
        ),
        Provider(
          create: (context) => BankService(firebaseFirestore),
        ),
        Provider(
          create: (context) => ProfileService(firebaseFirestore),
        ),
        Provider(
          create: (context) => InvoiceService(firebaseFirestore),
        ),
        Provider(
          create: (context) => ItemService(firebaseFirestore),
        ),
        Provider(
          create: (context) => NoteService(
            firebaseFirestore,
          ),
        ),
        Provider(
          create: (context) => TravelService(firebaseFirestore),
        ),
        ChangeNotifierProvider(
          create: (context) => SharedPreferencesProvider(
            context.read<SharedPreferencesService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseAuthProvider(
            context.read<FirebaseAuthService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Brigthness of the platform
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Generate default text theme of the App
    TextTheme textTheme = Theme.of(context).textTheme;

    // Generate theme of the App
    InvoiceTheme theme = InvoiceTheme(textTheme);

    return MaterialApp(
      builder: (context, child) {
        SizeConfig().init(context);
        return child!;
      },
      debugShowCheckedModeBanner: false,
      title: 'InvoTek',
      theme: theme.light(),
      initialRoute: ScreenRoute.realSplash.route,
      routes: routes,
    );
  }
}
