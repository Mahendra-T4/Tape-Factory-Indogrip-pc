import 'package:flutter/material.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/features/loss%20meters/pages/view/view_loss_meter.dart';

abstract class ViewLossMeterBuilder extends State<ViewLossMeterPanel>{
   bool isMultipleSelection = false;
  List<Map<String, dynamic>> selectedItems = [];

  // Define table columns
  final List<String> columns = [
    'Sr No',
    'Jumbo Roll',
    'Total Consume Meter',
    'Total Receive Meter',
    'Loss Meters',
  ];

  // Sample data with serial numbers
  final List<Map<String, dynamic>> lossMetersData = [
    {
      'Sr No': '1',
      'Jumbo Roll': 'JR101',
      'Total Consume Meter': '5000',
      'Total Receive Meter': '4850',
      'Loss Meters': '150',
    },
    {
      'Sr No': '2',
      'Jumbo Roll': 'JR102, JR103',
      'Total Consume Meter': '7500',
      'Total Receive Meter': '7300',
      'Loss Meters': '200',
    },
    {
      'Sr No': '3',
      'Jumbo Roll': 'JR104',
      'Total Consume Meter': '4200',
      'Total Receive Meter': '4100',
      'Loss Meters': '100',
    },
    {
      'Sr No': '4',
      'Jumbo Roll': 'JR105, JR106',
      'Total Consume Meter': '6800',
      'Total Receive Meter': '6600',
      'Loss Meters': '200',
    },
    {
      'Sr No': '5',
      'Jumbo Roll': 'JR107',
      'Total Consume Meter': '3500',
      'Total Receive Meter': '3400',
      'Loss Meters': '100',
    },
  ];

   List recordList = [
    "All Records",
    "Requested",
    "In-Progress",
    "Approved",
    "Rejected",
    "Block",
  ];
  List filterList = ["Newest", "Oldest"];
  List entryList = ["10", "25", "50", "100", "500"];
  var recordValue, filterValue, entryValue;


  void handleEdit(Map<String, dynamic> wastage) {
    // Implement edit functionality
    print(
      'Editing wastage entry: ${wastage['Bill No']} - ${wastage['Client Name']}',
    );
  }

  void handleDelete(Map<String, dynamic> wastage) {
    // Implement delete functionality
    print(
      'Deleting wastage entry: ${wastage['Bill No']} - ${wastage['Client Name']}',
    );
  }

  void handleProfile(Map<String, dynamic> wastage) {
    // Implement profile view functionality
    print('Viewing details: ${wastage['Bill No']} - ${wastage['Client Name']}');
  }

  void handleSelectionChanged(List<Map<String, dynamic>> items) {
    setState(() {
      selectedItems = items;
    });
  }

  void handleBulkDelete() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No entries selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk delete functionality
    print('Bulk deleting ${selectedItems.length} entries');
  }

  void handleBulkEdit() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No entries selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Implement bulk edit functionality
    print('Bulk editing ${selectedItems.length} entries');
  }

  Widget buildSelectionActions() {
    if (!isMultipleSelection || selectedItems.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '${selectedItems.length} entries selected',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: handleBulkEdit,
            icon: const Icon(Icons.edit),
            label: const Text('Edit Selected'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: handleBulkDelete,
            icon: const Icon(Icons.delete),
            label: const Text('Delete Selected'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget get buildFilterFieldsDesktop => Padding(
    padding: const EdgeInsets.only(top: kDefaultVerticalPadding),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              // flex: 14,
              child: SizedBox(
                height: 30,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Search....",
                    isDense: true,
                    hintStyle: TextStyle(
                      // fontFamily: AppFonts.pageHeadingFont,
                      color: ColourPalette.textFieldLabelColor,
                      fontSize: 13,
                    ),
                    suffixIcon: Container(
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: const Border(
                          left: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              // flex: 8,
              child: _buildDropdown(
                value: recordValue,
                items: recordList,
                hint: "All Records",
                onChanged: (val) => setState(() => recordValue = val),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              // flex: 8,
              child: _buildDropdown(
                value: filterValue,
                items: filterList,
                hint: "Newest",
                onChanged: (val) => setState(() => filterValue = val),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              // flex: 8,
              child: _buildDropdown(
                value: entryValue,
                items: entryList,
                hint: "Entries",
                onChanged: (val) => setState(() => entryValue = val),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  isMultipleSelection = !isMultipleSelection;
                  if (!isMultipleSelection) {
                    selectedItems.clear();
                  }
                });
              },
              icon: Icon(
                isMultipleSelection
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: Colors.blue,
              ),
              label: Text(
                isMultipleSelection ? 'Multiple Selection' : 'Single Selection',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  //! tablet

  Widget get buildFilterFieldsTablet => Padding(
    padding: const EdgeInsets.only(top: kDefaultVerticalPadding),
    child: Column(
      spacing: 16,
      children: [
        Row(
          spacing: 16,
          children: [
            Expanded(
              // flex: 14,
              child: SizedBox(
                height: 30,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Search....",
                    isDense: true,
                    hintStyle: TextStyle(
                      // fontFamily: AppFonts.pageHeadingFont,
                      color: ColourPalette.textFieldLabelColor,
                      fontSize: 13,
                    ),
                    suffixIcon: Container(
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: const Border(
                          left: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              // flex: 8,
              child: _buildDropdown(
                value: recordValue,
                items: recordList,
                hint: "All Records",
                onChanged: (val) => setState(() => recordValue = val),
              ),
            ),
          ],
        ),

        Row(
          spacing: 16,
          children: [
            Expanded(
              // flex: 8,
              child: _buildDropdown(
                value: filterValue,
                items: filterList,
                hint: "Newest",
                onChanged: (val) => setState(() => filterValue = val),
              ),
            ),

            Expanded(
              // flex: 8,
              child: _buildDropdown(
                value: entryValue,
                items: entryList,
                hint: "Entries",
                onChanged: (val) => setState(() => entryValue = val),
              ),
            ),
          ],
        ),
        // SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  isMultipleSelection = !isMultipleSelection;
                  if (!isMultipleSelection) {
                    selectedItems.clear();
                  }
                });
              },
              icon: Icon(
                isMultipleSelection
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: Colors.blue,
              ),
              label: Text(
                isMultipleSelection ? 'Multiple Selection' : 'Single Selection',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildDropdown({
    required dynamic value,
    required List items,
    required String hint,
    required Function(dynamic) onChanged,
  }) {
    return SizedBox(
      height: 30,
      child: DropdownButtonFormField(
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xFF2D8FCF),
          size: 24,
        ),
        value: value,
        isExpanded: true,
        style: TextStyle(
          // fontFamily: AppFonts.pageHeadingFont,
          color: ColourPalette.textFieldLabelColor,
          fontSize: 13,
        ),
        items:
            items.map((valueItem) {
              return DropdownMenuItem(value: valueItem, child: Text(valueItem));
            }).toList(),
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        hint: Text(
          hint,
          style: TextStyle(
            // fontFamily: AppFonts.pageHeadingFont,
            color: ColourPalette.textFieldLabelColor,
            fontSize: 13,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}