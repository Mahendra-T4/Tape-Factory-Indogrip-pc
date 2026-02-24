import 'package:flutter/material.dart';

class CustomTextFieldExtra extends StatelessWidget {
  CustomTextFieldExtra({
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
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText(labelText.toString()),
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

  Widget TextFieldlabelText(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Color(0xFF3D475C),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
