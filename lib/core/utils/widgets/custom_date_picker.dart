import 'package:flutter/material.dart';
import 'package:indogrip/core/widgets/labal_text.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key,
    this.labelText,
    required this.controller,
    this.validator,
    this.keyboardType,
  });
  final String? labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          LabelText(labelText.toString()),
          const SizedBox(height: 8),
        ],
        Container(
          //height: 38,
          // margin: const EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: controller,
            onTap: () async {
              DateTime? tillDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().day - 1),
                lastDate: DateTime.now(),
              );
              if (tillDate != null) {
                controller.text = DateFormat('yyyy-MM-dd').format(tillDate);
              }
            },
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF9499A1)),
                borderRadius: BorderRadius.circular(5),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              suffixIcon: const Icon(
                Icons.calendar_month,
                color: Color(0xFF2D8FCF),
              ),
            ),
            validator: validator,
            keyboardType: keyboardType,
          ),
        ),
      ],
    );
  }
}
