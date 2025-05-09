// import 'dart:io';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keep_up/pages/test_page.dart'; // FIXME: alternate between main_page and test_page for direct comparison
import 'package:keep_up/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return !kIsWeb && Platform.isWindows
        ? const MainPage()
        : StreamBuilder(
            stream: Supabase.instance.client.auth.onAuthStateChange,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final session = snapshot.hasData ? snapshot.data!.session : null;
              if (session == null) {
                return const LoginPage();
              }

              return const MainPage();
            },
          );
  }
}
