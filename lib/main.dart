import 'package:air_bnb_clone/config/dependencies.dart';
import 'package:air_bnb_clone/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'commons/constants/app_constants.dart';
import 'firebase_options.dart';

// ========== Entry Point ==========
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env before any dotenv.env access
  await dotenv.load(fileName: '.env');

  // Firebase
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );

  // Stripe
  Stripe.publishableKey = dotenv.env[AppConstants.stripePublicKey]!;
  await Stripe.instance.applySettings();

  runApp(MultiProvider(providers: providers, child: const MainApp()));
}

// ========== Main App Widget ==========
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AirBnB Clone',
      theme: ThemeData(
        fontFamily: "ProximaNova",
        brightness: Brightness.dark,
      ).copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: "ProximaNova",
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: const ColorScheme.dark(
            surface: Colors.black,
            primary: Colors.white,
            onPrimary: Colors.black,
            secondary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.white),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black,
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
      routerConfig: router(context.read()),
    );
  }
}
