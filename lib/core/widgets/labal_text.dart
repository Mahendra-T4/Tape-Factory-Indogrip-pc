import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const LabelText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight = FontWeight.w400,
    this.color = const Color(0xFF1F2937),
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: fontWeight,
        color: color,
      ).copyWith(fontSize: fontSize),
    );
  }
}
