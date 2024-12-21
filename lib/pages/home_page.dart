import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
          },
          child: Text(Supabase.instance.client.auth.currentUser!.identities![0]
              .identityData!["display_name"]),
        ),
      ),
    );
  }
}
