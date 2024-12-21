import 'package:flutter/material.dart';
import 'package:keep_up/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://dglxeiifpmrffzimtsgb.supabase.co';
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

Future<void> main() async {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthGate(),
    );
  }
}
