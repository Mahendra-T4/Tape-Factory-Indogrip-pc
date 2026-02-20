import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';

class GeneralOptionalField extends StatelessWidget {
  GeneralOptionalField({
    super.key,
    this.controller,
    this.reg,
    this.regReturn,
    this.keyboardType,
    this.inputFormatters,
    required this.labelText,
    this.textInputAction,
    this.onFieldSubmitted,
    this.spacing,
    this.validator,
  });
  final TextEditingController? controller;
  final String? reg;
  final String? regReturn;
  final double? spacing;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String labelText;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        spacing: spacing ?? 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldlabelText(labelText.toString()),
          SizedBox(
            height: 60,
            child: TextFormField(
              controller: controller,
              inputFormatters: inputFormatters,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onFieldSubmitted: onFieldSubmitted,
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
      ),
    );
  }
}
