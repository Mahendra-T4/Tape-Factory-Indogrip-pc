import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget formTextFieldVendor(
  String pattern,
  String hintText,
  List<TextInputFormatter>? inputFormatters,
  TextInputType keyboardType, {
  required TextEditingController controller,

  Widget? suffixIcon,
  String? Function(String?)? validator,
}) {
  return SizedBox(
    child: TextFormField(
      controller: controller,

      keyboardType: keyboardType,
      style: const TextStyle(
        color: Color(0xFF3D475C),
        fontSize: 14,
        fontFamily: 'Inter',
      ),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF9499A1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF9499A1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF2D8FCF)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            if (!RegExp(pattern).hasMatch(value)) {
              return 'Invalid format';
            }
            return null;
          },
      // inputFormatters: [
      //   FilteringTextInputFormatter.allow(RegExp(pattern)),
      // ],
    ),
  );
}
