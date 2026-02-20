import 'package:flutter/material.dart';
import 'package:indogrip/core/utils/widgets/delete_alert.dart';
import 'package:indogrip/features/global/presentation/widget/delete_record_button.dart';
import 'package:indogrip/features/staff/data/models/view_staff_model.dart';
import 'package:indogrip/features/staff/presentation/widgets/view_staff_master_dropdown.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StaffDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<StaffRecords> staffData = [];
  final BuildContext context;
  String? value;
  bool isAllChecked;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(StaffRecords) onEdit;
  final Function(StaffRecords) onDelete;

  // final Function(StaffRecords) onProfile;
  final void Function(String?, StaffRecords) onChanged;

  StaffDataSource({
    required this.staffData,
    required this.isAllChecked,
    required this.onStatusChanged,
    required this.onCheckboxChanged,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
    required this.context,

    // required this.onProfile,
    required this.value,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = staffData.asMap().entries.map<DataGridRow>((entry) {
      final index = entry.key;
      final staff = entry.value;
      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'srno', value: staff.SNo.toString()),
          DataGridCell<String>(
            columnName: 'staff_name',
            value: '${staff.uFirstName} ${staff.uLastName}',
          ),
          DataGridCell<String>(
            columnName: 'department',
            value: staff.uRoleText.toString(),
          ),

          DataGridCell<String>(
            columnName: 'mobile',
            value: staff.uMobileNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'altmobile',
            value: staff.uAlternateNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: 'email',
            value: staff.uEmail.toString(),
          ),
          DataGridCell<String>(
            columnName: 'personalemail',
            value: staff.uPersonalEmail.toString(),
          ),

          // DataGridCell<String>(
          //   columnName: 'status',
          //   value: staff.rStatus.toString(),
          // ),
          DataGridCell<Widget>(
            columnName: 'Status',
            value: ViewStaffMasterDropdown(
              onChanged: (value) {
                onChanged.call(value, staff);
              },
              value: staff.rStatus.toString(),
              // staff: staff,
            ),
          ),
          DataGridCell<Widget>(
            columnName: 'actions',
            value: _buildActionButtons(staff),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildActionButtons(StaffRecords staff) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
            onPressed: () => onEdit(staff),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
            onPressed: () {
              DeleteConfirmationAlert.show(
                context,
                title: 'Delete Record',
                message: 'Are Your to Delete This Staff Record',
                itemName: '${staff.uFirstName} ${staff.uLastName}',

                onConfirm: () {
                  onDelete(staff);
                },
                rPanel: 'view-staff',
                item: staffData,
                index: staffData.indexOf(staff),
                rKey: staff.rKey.toString(),
              );
            },
          ),
          // SizedBox(
          //   width: 35,
          //   child: DeleteRecordButton(
          //     rKey: staff.rKey.toString(),
          //     rPanel: 'view-staff',
          //     item: staffData,
          //     index: staffData.indexOf(staff),
          //     onPressed: () => onDelete(staff),
          //   ),
          // ),
          // IconButton(
          //   icon: const Icon(Icons.person, size: 20),
          //   visualDensity: VisualDensity.compact,
          //   padding: EdgeInsets.zero,
          //   constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
          //   onPressed: () => onProfile(staff),
          // ),
        ],
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'actions' || cell.columnName == 'Status') {
          return cell.value as Widget;
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SelectableText(
            cell.value.toString(),
            maxLines: 1,
            toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
          ),
        );
      }).toList(),
    );
  }

  void removeRow(StaffRecords staff) {
    // Find and remove the staff from the data source
    staffData.removeWhere((item) => item.rKey == staff.rKey);
    // Rebuild the grid rows
    buildDataGridRows();
  }
}
