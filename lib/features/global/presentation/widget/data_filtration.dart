import 'package:flutter/material.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/features/chalan/presentation/widget/staff_dropdown.dart';
import 'package:indogrip/features/global/presentation/widget/read_unread_master_status_widget.dart';
import 'package:indogrip/features/wastage/presentation/widgets/client_list_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:indogrip/core/theme/color_conts.dart';

class DateFiltration extends StatefulWidget {
  DateFiltration({
    super.key,
    required this.fromDateController,
    required this.toDateController,
    this.onFromChanged,
    this.onToChanged,
    this.isChalan = false,
    this.clientKey,
    this.onChanged,
    this.staffKey,
    this.onStaffChanged,
    this.readUnreadStatus,
    this.onReadUnreadChanged,
    this.readUnread = false,
  });
  final String? readUnreadStatus;
  final bool readUnread;
  final TextEditingController fromDateController;
  final TextEditingController toDateController;
  final void Function(String)? onFromChanged;
  final void Function(String)? onToChanged;
  final bool isChalan;
  String? clientKey;
  String? staffKey;
  final void Function(String?)? onStaffChanged;
  final void Function(String?)? onChanged;
  final void Function(String?)? onReadUnreadChanged;

  @override
  State<DateFiltration> createState() => _DateFiltrationState();
}

class _DateFiltrationState extends State<DateFiltration> {
  // final TextEditingController _fromDateController = TextEditingController();
  // final TextEditingController _toDateController = TextEditingController();

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
    return Padding(
      padding: EdgeInsets.only(
        left: Responsive.kHZRowPaddingTB - 5,
        right: Responsive.kHZRowPaddingTB - 5,
        top: Responsive.kHZRowPaddingTB,
      ),
      child: Row(
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
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
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
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
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
          if (widget.readUnread)
            Expanded(
              child: ReadUnreadMasterStatusWidget(
                initialStatus: widget.readUnreadStatus.toString(),
                onChanged: widget.onReadUnreadChanged!,
              ),
            ),
          widget.isChalan
              ? Expanded(
                  child: ClientsListDropdown(
                    isFilter: true,
                    label: 'Select Client',
                    value: widget.clientKey,
                    onChanged: widget.onChanged!,
                  ),
                )
              : Expanded(child: SizedBox()),
          widget.isChalan
              ? Expanded(
                  child: StaffListDropdown(
                    isFilter: true,
                    label: 'Select Staff',
                    value: widget.staffKey,
                    onChanged: widget.onStaffChanged!,
                  ),
                )
              : Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
