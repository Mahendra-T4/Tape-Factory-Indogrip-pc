import 'package:flutter/material.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';

class CustomField extends StatelessWidget {
  CustomField({
    super.key,
    required this.controller,
    this.label,
    this.regax,
    this.warning,
    this.validator,
    this.onChanged,
  });
  final TextEditingController controller;
  final String? label;
  final String? regax;
  final String? warning;
  String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != '' && label != null) TextFieldlabelText(label.toString()),
        Container(
          // margin: EdgeInsets.only(top: marginTop),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                // height: 60,
                child: TextFormField(
                  controller: controller,
                  // inputFormatters: inputFormatters,
                  onChanged: onChanged,
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
        ),
      ],
    );
  }
}
