import 'package:flutter/material.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/utils/widgets/delete_alert.dart';
import 'package:indogrip/features/global/presentation/widget/delete_record_button.dart';
import 'package:indogrip/features/global/presentation/widget/master_user_status.dart';
import 'package:indogrip/features/round/data/models/round_table_column.dart';
import 'package:indogrip/features/round/data/models/view_round_modeld.dart';
import 'package:indogrip/features/round/presentation/widgets/round_status_dropdown.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RoundDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  final BuildContext context;
  List<RoundRecord> roundData = [];
  bool isAllChecked;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(RoundRecord) onEdit;
  final Function(RoundRecord) onDelete;
  final Function(RoundRecord) onProfile;
  final Function(RoundRecord) stickerPopup;
  final void Function(String?, RoundRecord) onChanged;

  RoundDataSource({
    required this.context,
    required this.roundData,
    required this.isAllChecked,
    required this.onStatusChanged,
    required this.onCheckboxChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onProfile,
    required this.stickerPopup,
    required this.onChanged,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = roundData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      // final index = entry.key; // Adjust index for display
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: RoundTableColumn.srNo,
            value: data.sNo.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.rollNumber,
            value: data.rollNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.width,
            value: data.width.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.base,
            value: data.base.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.mic,
            value: data.mic.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.length,
            value: data.length.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.totalWeight,
            value: data.totalWeight.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.amountPerKG,
            value: data.amountPerKG.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.cutMMMeter,
            value: data.cutMMMeter.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.roundCount,
            value: data.roundCount.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.tapeLength,
            value: data.tapeLength.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.wastagePercentage,
            value: data.wastagePercentage.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.conversionRate,
            value: data.conversionRate.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.usedLength,
            value: data.usedLength.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.piecesPerCarton,
            value: data.piecesPerCarton.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.usedSquareMeter,
            value: data.usedSquareMeter.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.rollCost,
            value: data.rollCost.toString(),
          ),

          DataGridCell<String>(
            columnName: RoundTableColumn.totalSquareMtr,
            value: data.totalSquareMtr.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.ratePerSquareMeter,
            value: data.ratePerSquareMeter.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.cartonMaterialCost,
            value: data.cartonMaterialCost.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.cartonRate,
            value: data.cartonRate.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.marginWithTenPercentage,
            value: data.marginWithTenPercentage.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.marginWithTwelvePercentage,
            value: data.marginWithTwelvePercentage.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.marginWithFifteenPercentage,
            value: data.marginWithFifteenPercentage.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.totalCarton,
            value: data.totalCarton.toString(),
          ),
          DataGridCell<String>(
            columnName: RoundTableColumn.roundStatusLabel,
            value: data.roundStatusLabel.toString(),
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
    Color? rowBackgroundColor;
    try {
      final statusCell = row.getCells().firstWhere(
        (cell) => cell.columnName == RoundTableColumn.roundStatusLabel,
      );
      final statusText = statusCell.value?.toString().toLowerCase() ?? '';
      if (statusText.contains('out')) {
        rowBackgroundColor = Colors.red;
      } else if (statusText.contains('in')) {
        rowBackgroundColor = Colors.white;
      }
    } catch (e) {
      rowBackgroundColor = null;
    }
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'actions') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: rowBackgroundColor,
            child: cell.value as Widget,
          );
        }

        if (cell.columnName == RoundTableColumn.roundStatusLabel) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: rowBackgroundColor,
            child: cell.value is Widget
                ? cell.value as Widget
                : Text(cell.value.toString(), overflow: TextOverflow.ellipsis),
          );
        }

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: rowBackgroundColor,
          child: SelectableText(
            cell.value?.toString() ?? '',
            maxLines: 1,
            toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(RoundRecord round) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
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
                onPressed: () => onEdit(round),
                constraints: const BoxConstraints(),
              ),
            ),
          if (HiveService.getRole() != '2')
            SizedBox(
              width: 35,
              child: IconButton(
                icon: const Icon(Icons.delete, size: 20),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
                onPressed: () {
                  DeleteConfirmationAlert.show(
                    context,
                    title: 'Delete Record',
                    message: 'Are Your to Delete This Round Record',
                    itemName: '${round.rollNumber} ',

                    onConfirm: () {
                      onDelete(round);
                    },
                    rPanel: 'view-round',
                    item: roundData,
                    index: roundData.indexOf(round),
                    rKey: round.rKey.toString(),
                  );
                },
              ),
            ),
          // SizedBox(
          //   width: 35,
          //   child: DeleteRecordButton(
          //     rKey: round.rKey.toString(),
          //     rPanel: 'view-round',
          //     item: roundData,
          //     index: roundData.indexOf(round),
          //     onPressed: () => onDelete(round),
          //   ),
          // ),
          if (round.batchInformation != null &&
              round.batchInformation?.batchID != '')
            SizedBox(
              width: 35,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.person, size: 18),
                onPressed: () => onProfile(round),
                constraints: const BoxConstraints(),
              ),
            ),
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.label, size: 18),
              onPressed: () => stickerPopup(round),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
