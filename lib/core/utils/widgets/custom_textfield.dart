import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.validator,
  });
  final TextEditingController controller;
  final String? labelText;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: controller,

            validator: validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9499A1)),
                borderRadius: BorderRadius.circular(5),
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
