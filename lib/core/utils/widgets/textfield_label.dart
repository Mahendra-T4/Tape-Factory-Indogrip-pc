import 'package:flutter/material.dart';

class TextFieldlabelText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const TextFieldlabelText(
    this.text, {
    Key? key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.color = const Color(0xFF1F2937),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
