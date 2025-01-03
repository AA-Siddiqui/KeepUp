import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keep_up/auth/auth_service.dart';
import 'package:keep_up/pages/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _submitted = false;

  void login() async {
    setState(() {
      _submitted = true;
    });
    final email = _emailTextController.text;
    final password = _passwordTextController.text;

    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Form Inputs are not valid")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondaryContainer,
            boxShadow: const [
              BoxShadow(
                spreadRadius: 5,
                blurRadius: 50,
              ),
            ],
          ),
          width: min(MediaQuery.sizeOf(context).width - 20, 500),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Log In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      // fontFamily: TODO: Get a looking title font
                    ),
                  ),
                  TextFormField(
                    controller: _emailTextController,
                    decoration: const InputDecoration(label: Text("Email")),
                    autovalidateMode: _submitted
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    validator: (text) {
                      setState(() {
                        _submitted = false;
                      });
                      if (text == null || text.isEmpty) {
                        return "Email Field is Required";
                      }
                      if (!RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(text)) {
                        return "Invalid Email!";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTextController,
                    decoration: const InputDecoration(label: Text("Password")),
                    autovalidateMode: _submitted
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    validator: (text) {
                      setState(() {
                        _submitted = false;
                      });
                      if (text == null || text.isEmpty) {
                        return 'Can\'t be empty';
                      }
                      if (text.length < 6) {
                        return 'Too short';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    onPressed: login,
                    style: ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(
                        Size(
                          min(MediaQuery.sizeOf(context).width - 20, 500),
                          20,
                        ),
                      ),
                      // backgroundColor: const WidgetStatePropertyAll(
                      //   Colors.deepPurpleAccent,
                      // ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: signInWithGoogle,
                    style: ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(
                        Size(
                          min(MediaQuery.sizeOf(context).width - 20, 500),
                          20,
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    child: const Text(
                      "Login with Google",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    ),
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(fontSize: 10),
                          children: [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signInWithGoogle() async {
    if (kIsWeb) {
      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
      return;
    }
    const webClientId =
        '502027430645-kht5a922ucqcodlgnu7u9kadnu2efnvr.apps.googleusercontent.com';
    const iosClientId =
        '502027430645-td1e7k7bnl2dn7p8ll00j0vqma8qvrdp.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final GoogleSignInAccount? googleUser;
    try {
      googleUser = await googleSignIn.signIn();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
      return;
    }
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    try {
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
      return;
    }
  }
}
