import 'package:flutter/material.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/features/core/data/models/view_core_model.dart';
import 'package:indogrip/features/global/presentation/widget/delete_record_button.dart';
import 'package:indogrip/features/global/presentation/widget/master_user_status.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Core {
  static final String srNo = 'Sr No';
  static final String coreType = 'Core Type';
  static final String date = 'Date';
  static final String quantity = 'Quantity';
  static final String billNo = 'Bill No';
  static final String companyName = 'Company Name';
}

class CoreDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<CoreDataRecord> coreData = [];
  bool isAllChecked;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(CoreDataRecord) onEdit;
  final Function(CoreDataRecord) onDelete;
  final Function(CoreDataRecord) onProfile;
  final void Function(String?, CoreDataRecord) onChanged;

  CoreDataSource({
    required this.coreData,
    required this.isAllChecked,
    required this.onStatusChanged,
    required this.onCheckboxChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onProfile,
    required this.onChanged,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = coreData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      // final index = entry.key;
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: Core.srNo,
            value: data.sNo.toString(),
          ),
          DataGridCell<String>(
            columnName: Core.companyName,
            value: data.companyName.toString(),
          ),
          DataGridCell<String>(
            columnName: Core.coreType,
            value: data.coreTypeText.toString(),
          ),
          DataGridCell<String>(
            columnName: Core.date,
            value: data.coreDateText.toString(),
          ),
          DataGridCell<String>(
            columnName: Core.quantity,
            value: data.coreQuantity.toString(),
          ),
          DataGridCell<String>(
            columnName: Core.billNo,
            value: data.coreQuantity.toString(),
          ),
          DataGridCell<Widget>(
            columnName: 'Status',
            value: MasterUserStatus(
              isShowLabel: false,
              isCustomized: false,
              onChanged: (value) {
                onChanged.call(value, data);
              },
              initialStatus: data.rStatus?.toString() ?? '1',
            ),
          ),
          if (HiveService.getRole() != '2')
            DataGridCell<Widget>(
              columnName: 'actions',
              value: _buildActionButtons(data),
            ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'Status') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: cell.value as Widget,
          );
        }
        if (cell.columnName == 'actions') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: cell.value as Widget,
          );
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SelectableText(
            cell.value?.toString() ?? '',
            maxLines: 1,
            toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(CoreDataRecord core) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // if (HiveService.getRole() != '2')
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.edit, size: 18),
              onPressed: () => onEdit(core),
              constraints: const BoxConstraints(),
            ),
          ),
          // SizedBox(
          //   width: 35,
          //   child: DeleteRecordButton(
          //     rKey: core.rKey.toString(),
          //     rPanel: 'view-core',
          //     item: coreData,
          //     index: coreData.indexOf(core),
          //     onPressed: () => onDelete(core),
          //   ),
          // ),

          // SizedBox(
          //   width: 35,
          //   child: IconButton(
          //     padding: EdgeInsets.zero,
          //     icon: const Icon(Icons.person, size: 18),
          //     onPressed: () => onProfile(core),
          //     constraints: const BoxConstraints(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
