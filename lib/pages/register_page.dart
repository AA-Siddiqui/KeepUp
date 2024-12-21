import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  void signUp() async {
    setState(() {
      _submitted = true;
    });

    final name = _nameTextController.text;
    final email = _emailTextController.text;
    final password = _passwordTextController.text;

    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
          data: {
            "display_name": name,
          },
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
      appBar: AppBar(),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
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
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      // fontFamily: TODO: Get a looking title font
                    ),
                  ),
                  TextFormField(
                    controller: _nameTextController,
                    decoration: const InputDecoration(
                      label: Text("Full Name"),
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
                  TextFormField(
                    obscureText: true,
                    controller: _confirmPasswordTextController,
                    decoration: const InputDecoration(
                      label: Text("Confirm Password"),
                    ),
                    autovalidateMode: _submitted
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    validator: (text) {
                      setState(() {
                        _submitted = false;
                      });
                      if (text != _passwordTextController.text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    onPressed: signUp,
                    style: ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(
                        Size(
                          min(MediaQuery.sizeOf(context).width - 20, 500),
                          20,
                        ),
                      ),
                      backgroundColor: const WidgetStatePropertyAll(
                        Colors.deepPurpleAccent,
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
}
