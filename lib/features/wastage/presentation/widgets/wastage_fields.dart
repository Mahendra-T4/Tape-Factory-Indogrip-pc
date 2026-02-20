import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget formTextFieldDigit(
  String pattern,
  String errorText,
  TextInputType keyboardType, {
  bool isReadOnly = false,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
  required TextEditingController controller,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        // hintText: hintText,
      ),
      validator: validator,
      keyboardType: keyboardType,
    ),
  );
}


Widget formTextFieldDigit2(
  String pattern,
  String errorText,
  void Function(String)? onChanged,
  
  TextInputType keyboardType, {
  bool isReadOnly = false,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
  required TextEditingController controller,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        // hintText: hintText,
      ),
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
    ),
  );
}
