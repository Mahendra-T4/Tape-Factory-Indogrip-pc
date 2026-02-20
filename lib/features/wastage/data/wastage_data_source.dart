import 'package:flutter/material.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/features/global/presentation/widget/delete_record_button.dart';
import 'package:indogrip/features/global/presentation/widget/master_user_status.dart';
import 'package:indogrip/features/wastage/data/model/view_wastage_model.dart';
import 'package:indogrip/features/wastage/data/model/view_wastage_table_column.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class WastageDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<WastageRecord> wastageData = [];
  bool isAllChecked;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(WastageRecord) onEdit;
  final Function(WastageRecord) onDelete;
  final Function(WastageRecord) onProfile;
  final void Function(String?, WastageRecord) onChanged;

  WastageDataSource({
    required this.wastageData,
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
    dataGridRows = wastageData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      // final index = entry.key;
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: WTableColumn.SrNo,
            value: data.sNo.toString(),
          ),
          DataGridCell<String>(
            columnName: WTableColumn.consigneeName,
            value: data.consigneeName.toString(),
          ),
          DataGridCell<String>(
            columnName: WTableColumn.wastageDate,
            value: WTableColumn.wastageDate,
          ),

          DataGridCell<String>(
            columnName: WTableColumn.billNumber,
            value: data.billNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: WTableColumn.Weight,
            value: data.weight.toString(),
          ),
          DataGridCell<String>(
            columnName: WTableColumn.PricePerKg,
            value: data.pricePerKG.toString(),
          ),
          DataGridCell<String>(
            columnName: WTableColumn.price,
            value: data.price.toString(),
          ),
          DataGridCell<String>(
            columnName: WTableColumn.Remark,
            value: data.remark.toString(),
          ),
          DataGridCell<Widget>(
            columnName: 'Status',
            value: MasterUserStatus(
              isShowLabel: false,
              isCustomized: false,
              onChanged: (value) {
                onChanged.call(value, data);
              },
              initialStatus: data.rStatus
                  .toString(), //! status not show because of rStatus show 1 there is no status 1 in api
              // staff: staff,
            ),
          ),
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

  Widget _buildActionButtons(WastageRecord wastage) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (HiveService.getRole() != '2')
            SizedBox(
              width: 35,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => onEdit(wastage),
                constraints: const BoxConstraints(),
              ),
            ),
          // SizedBox(
          //   width: 35,
          //   child: DeleteRecordButton(
          //     rKey: wastage.rKey.toString(),
          //     rPanel: 'view-wastage',
          //     item: wastageData,
          //     index: wastageData.indexOf(wastage),
          //     onPressed: () => onDelete(wastage),
          //   ),
          // ),
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.person, size: 18),
              onPressed: () => onProfile(wastage),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
