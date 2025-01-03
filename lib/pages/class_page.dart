import 'package:flutter/material.dart';

class ClassPage extends StatelessWidget {
  final int subjectId;
  const ClassPage({
    super.key,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("subjectName"),
      ),
      body: const Center(
        child: Text("DOG"),
      ),
    );
  }
}
