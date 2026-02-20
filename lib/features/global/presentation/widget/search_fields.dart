import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/widgets/labal_text.dart';
import 'package:indogrip/features/global/presentation/widget/master_user_status.dart';
import 'package:indogrip/features/global/presentation/widget/stock_status.dart';

class SearchFields extends ConsumerStatefulWidget {
  SearchFields({
    super.key,
    this.status,
    this.statusValue,
    this.orderByValue,
    this.sortByValue,
    this.controller,
    this.isStatus = false,
    this.isJumbo = false,
    this.onSearch,
    this.onChangedStatus,
    this.onChangedOrder,
    this.onChangedSort,
    this.panelStatus,
    this.onStockStatusChanged,

    this.searchHint = 'Search...',
  });
  String? status;
  String? statusValue;
  bool isStatus;
  bool isJumbo;
  String? orderByValue;
  String? sortByValue;
  TextEditingController? controller;
  final Function(String)? onSearch;
  final Function(dynamic)? onChangedStatus;
  final Function(dynamic)? onChangedOrder;
  final Function(dynamic)? onChangedSort;
  final void Function(dynamic)? onStockStatusChanged;
  final String searchHint;
  final Widget? panelStatus;

  @override
  ConsumerState<SearchFields> createState() => _SearchFieldsState();
}

class _SearchFieldsState extends ConsumerState<SearchFields> {
  // List statusList = ["Active", "Inactive"];
  List orderByList = ["Newest", "Oldest"];
  List sortByList = ["10", "25", "50", "100", "500"];

  Widget get statusWidget => Expanded(
    child: MasterUserStatus(
      initialStatus: widget.status,
      onChanged: widget.onChangedStatus!,
    ),
  );

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Responsive.kHZRowPaddingTB - 5,
        vertical: Responsive.kHZRowPaddingTB,
      ),
      child: Responsive.isDesktop(context)
          ? Row(
              spacing: 16,
              children: [
                Expanded(
                  // flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      LabelText('Search'),
                      Container(
                        height: 37,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: widget.controller,

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: widget.searchHint,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF2D8FCF),
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color(0xFF2D8FCF),
                                width: 1.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: ColourPalette.textFieldLabelColor,
                          ),
                          onChanged: widget.onSearch,
                        ),
                      ),
                    ],
                  ),
                ),
                widget.isJumbo
                    ? Expanded(child: StockStatus(onChanged: (value) {}))
                    : SizedBox(width: 0),
                if (widget.isStatus) widget.panelStatus ?? statusWidget,
                _buildDropdown(
                  label: 'Order By',
                  value: widget.status,
                  items: orderByList,
                  hint: 'Select Order',
                  onChanged: widget.onChangedOrder!,
                ),
                _buildDropdown(
                  label: 'Sort By',
                  value: widget.status,
                  items: sortByList,
                  hint: 'Select Length',
                  onChanged: widget.onChangedSort!,
                ),
              ],
            )
          : Column(
              spacing: Responsive.spacingHzTB,
              children: [
                Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      // flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          LabelText('Search'),
                          Container(
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: widget.controller,

                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: widget.searchHint,
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF2D8FCF),
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color(0xFF2D8FCF),
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 0,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: ColourPalette.textFieldLabelColor,
                              ),
                              onChanged: widget.onSearch,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.isStatus) statusWidget,
                  ],
                ),
                Row(
                  spacing: Responsive.spacingHzTB,
                  children: [
                    _buildDropdown(
                      label: 'Order By',
                      value: widget.status,
                      items: orderByList,
                      hint: 'Select Order',
                      onChanged: widget.onChangedOrder!,
                    ),
                    _buildDropdown(
                      label: 'Sort By',
                      value: widget.status,
                      items: sortByList,
                      hint: 'Select Length',
                      onChanged: widget.onChangedSort!,
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildDropdown({
    required dynamic value,
    required List items,
    required String hint,
    required String label,
    required Function(dynamic) onChanged,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          LabelText(label),
          Container(
            height: 37,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF2D8FCF),
                size: 24,
              ),
              value: value,
              isExpanded: true,
              style: TextStyle(
                color: ColourPalette.textFieldLabelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              items: items.map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
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
                  borderSide: BorderSide(color: Color(0xFF2D8FCF), width: 1.5),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              hint: Text(
                hint,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              onChanged: onChanged,
              dropdownColor: Colors.white,
              elevation: 3,
            ),
          ),
        ],
      ),
    );
  }
}
