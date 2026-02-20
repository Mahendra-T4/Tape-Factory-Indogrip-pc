import 'package:flutter/material.dart';

class TextFieldlabelText extends StatelessWidget {
  final String title;

  const TextFieldlabelText(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
