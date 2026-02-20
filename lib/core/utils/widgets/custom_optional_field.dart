import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';

class CustomOptionalField extends StatelessWidget {
  CustomOptionalField({
    super.key,
    this.controller,
    this.onFieldSubmitted,
    this.keyboardType,
    this.inputFormatters,
    this.labelText,
    this.spacing,
    this.compareController,
    this.sameValueError,
    this.validator
  });
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  final double? spacing;
  final TextInputType? keyboardType;
  final String? sameValueError;

  final List<TextInputFormatter>? inputFormatters;
  final String? labelText;
  final TextEditingController? compareController;
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
              onFieldSubmitted: onFieldSubmitted,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF9499A1)),
                  borderRadius: BorderRadius.circular(5),
                ),
                isDense: true,
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
