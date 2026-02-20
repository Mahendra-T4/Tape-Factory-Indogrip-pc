import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';

class AlternateMobile extends StatelessWidget {
  AlternateMobile({
    super.key,
    required this.controller,
    this.compareController,
  });

  final TextEditingController controller;
  final TextEditingController? compareController;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText("Alternate Mobile Number"),
        TextFormField(
          controller: controller,

          keyboardType: TextInputType.phone,
          style: const TextStyle(
            color: Color(0xFF3D475C),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontFamily: 'Inter',
            ),

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
          validator: (value) {
            if (value == compareController?.text) {
              return 'Alternate Mobile Number should not be same as Mobile Number';
            }
            return null;
          },
        ),
      ],
    );
  }
}
