import 'package:flutter/material.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/features/dashboard/presentation/widget/product_type_widget_db.dart';
import 'package:intl/intl.dart';

class AnalyticsDropdownWidget extends StatefulWidget {
  AnalyticsDropdownWidget({
    super.key,
    required this.fromDateController,
    required this.toDateController,
    this.onFromChanged,
    this.onToChanged,
  });
  final TextEditingController fromDateController;
  final TextEditingController toDateController;
  void Function(String)? onToChanged;
  void Function(String)? onFromChanged;

  @override
  State<AnalyticsDropdownWidget> createState() =>
      _AnalyticsDropdownWidgetState();
}

class _AnalyticsDropdownWidgetState extends State<AnalyticsDropdownWidget> {
  final List<String> timeRanges = ['Today', 'Weekly', 'Monthly', 'Yearly'];

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    void Function(String)? onChanged,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        controller.text = formattedDate;
      });
      onChanged?.call(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        Expanded(
          child: Container(
            height: 37,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: widget.fromDateController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Select From Date',
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                prefixIcon: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF2D8FCF),
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF2D8FCF),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
              ),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ColourPalette.textFieldLabelColor,
              ),
              readOnly: true,
              onChanged: widget.onFromChanged,
              onTap: () => _selectDate(
                context,
                widget.fromDateController,
                widget.onFromChanged,
              ),
            ),
          ),
        ),
        // const SizedBox(height: 16),
        Expanded(
          child: Container(
            height: 37,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: widget.toDateController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Select To Date',
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                prefixIcon: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF2D8FCF),
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF2D8FCF),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
              ),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ColourPalette.textFieldLabelColor,
              ),
              readOnly: true,
              onChanged: widget.onToChanged,
              onTap: () => _selectDate(
                context,
                widget.toDateController,
                widget.onToChanged,
              ),
            ),
          ),
        ),
        Expanded(child: MasterProductTypeDBWidget(onChanged: (value) {})),
        Expanded(child: SizedBox()),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
