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
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb || !Platform.isWindows) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
    final SupabaseClient supabaseClient = Supabase.instance.client;
    final x = await supabaseClient
        .from("Enrollment")
        .select()
        .eq("userId", supabaseClient.auth.currentUser?.id as Object);
    print(x);
  }

  runApp(MainApp(
    lightTheme: ThemeDecoder.decodeThemeData(
      jsonDecode(
        await rootBundle.loadString(
          'assets/appainter_light_theme.json',
        ),
      ),
    )!,
    darkTheme: ThemeDecoder.decodeThemeData(
      jsonDecode(
        await rootBundle.loadString(
          'assets/appainter_dark_theme.json',
        ),
      ),
    )!,
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
      home: const AuthGate(),
    );
  }
}
