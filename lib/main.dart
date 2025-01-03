import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_up/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:json_theme_plus/json_theme_plus.dart';

const supabaseUrl = 'https://dglxeiifpmrffzimtsgb.supabase.co';
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

const textColor = Color(0xFFe6efeb);
const backgroundColor = Color(0xFF030705);
const primaryColor = Color(0xFFa6cfbd);
const primaryFgColor = Color(0xFF030705);
const secondaryColor = Color(0xFF21563e);
const secondaryFgColor = Color(0xFFe6efeb);
const accentColor = Color(0xFF5cbd92);
const accentFgColor = Color(0xFF030705);

const colorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  surface: backgroundColor,
  onSurface: textColor,
  error: Brightness.dark == Brightness.light
      ? Color(0xffB3261E)
      : Color(0xffF2B8B5),
  onError: Brightness.dark == Brightness.light
      ? Color(0xffFFFFFF)
      : Color(0xff601410),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (kIsWeb || !Platform.isWindows) {
  //   await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  // }

  runApp(MainApp(
    lightTheme: ThemeDecoder.decodeThemeData(
      jsonDecode(
        await rootBundle.loadString(
          'assets/appainter_light_theme.json',
        ),
      ),
    )!,
    darkTheme: ThemeData(colorScheme: colorScheme),
    //     await rootBundle.loadString(
    //       'assets/appainter_dark_theme.json',
    //     ),
    //   ),
    // )!,
  ));
}

class MainApp extends StatelessWidget {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  const MainApp({super.key, required this.lightTheme, required this.darkTheme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: (kIsWeb || !Platform.isWindows)
          ? const AuthGate()
          : FutureBuilder(
              future: Supabase.initialize(
                url: supabaseUrl,
                anonKey: supabaseKey,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                }
                return const AuthGate();
              },
            ),
    );
  }
}
