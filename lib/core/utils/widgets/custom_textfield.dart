import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/widgets/labal_text.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.validator,
    this.readOnly = false,
    this.onChanged,
    this.inputFormatters,
    this.fillColor,
  });
  final TextEditingController controller;
  final String? labelText;
  String? Function(String?)? validator;
  final bool readOnly;
  void Function(String)? onChanged;
  List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          LabelText(labelText.toString()),
          const SizedBox(height: 8),
        ],
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            readOnly: readOnly,
            validator: validator,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              fillColor: fillColor,
              filled: fillColor != null,
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
