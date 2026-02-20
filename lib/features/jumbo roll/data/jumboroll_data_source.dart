import 'package:flutter/material.dart';
import 'package:indogrip/core/utils/widgets/delete_alert.dart';
import 'package:indogrip/features/global/presentation/widget/delete_record_button.dart';
import 'package:indogrip/features/jumbo%20roll/data/models/view_jumbo_roll_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class JumboRollDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  List<JumboRollRecord> jumboRollData = [];

  bool isAllChecked;
  final Function(bool) onStatusChanged;
  final Function(bool, int) onCheckboxChanged;
  final Function(JumboRollRecord) onEdit;
  final Function(JumboRollRecord) onDelete;
  // final Function(JumboRollRecord) onProfile;
  final Function(JumboRollRecord) stickerPopup;
  final BuildContext context;

  JumboRollDataSource({
    required this.jumboRollData,
    required this.isAllChecked,
    required this.onStatusChanged,
    required this.onCheckboxChanged,
    required this.onEdit,
    required this.onDelete,
    // required this.onProfile,
    required this.stickerPopup,
    required this.context,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = jumboRollData.asMap().entries.map<DataGridRow>((entry) {
      final data = entry.value;
      // final index = entry.key;
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: JumboRoll.srNo,
            value: data.sNo.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.vendorCode,
            value: data.vendorInfo?.vendorCode.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.vendorName,
            value: data.vendorInfo?.companyName.toString(),
          ),

          DataGridCell<String>(
            columnName: 'Record Date',
            value: data.jumboDate.toString(),
          ),

          DataGridCell<String>(
            columnName: JumboRoll.billDate,
            value: data.jBillDate.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.billNo,
            value: data.jBillNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.rollPacketNo,
            value: data.jRollNumber.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.base,
            value: data.baseLabel.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.mic,
            value: data.micLabel.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.length,
            value: data.jLength.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.consumeLength,
            value: data.consumeLength.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.availableLength,
            value: data.availableLength.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.width,
            value: data.jWidth.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.netWeight,
            value: data.jWeight.toString(),
          ),

          DataGridCell<String>(
            columnName: JumboRoll.square,
            value: data.jSquareMeter.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.amountPerKg,
            value: data.amountPerKG.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.rollCost,
            value: data.rollCost.toString(),
          ),

          DataGridCell<String>(
            columnName: JumboRoll.remark,
            value: data.jRemark.toString(),
          ),
          DataGridCell<String>(
            columnName: JumboRoll.jumboStatusLabel,
            value: data.jumboStatusLabel.toString(),
          ),

          DataGridCell<Widget>(
            columnName: 'actions',
            value: _buildActionButtons(data),
          ),
          // DataGridCell<Widget>(
          //   columnName: 'Select & Print',
          //   value: ,
          // ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // Get consume length value from the row
    Color? rowBackgroundColor;
    try {
      // Use Available Length for coloring as requested
      final availableLengthCell = row.getCells().firstWhere(
        (cell) => cell.columnName == JumboRoll.availableLength,
      );
      final availableLength = double.parse(
        availableLengthCell.value?.toString() ?? '0',
      );

      if (availableLength <= 0) {
        rowBackgroundColor = Colors.red; // Red for <= 0
      } else if (availableLength >= 1 && availableLength <= 100) {
        rowBackgroundColor = Colors.yellow[100]; // Yellow for 1-100
      } else if (availableLength > 100) {
        rowBackgroundColor = Colors.white; // White for > 100
      }
    } catch (e) {
      // If parsing fails, use default color
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

  Widget _buildActionButtons(JumboRollRecord jumboRoll) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.edit, size: 18),
              onPressed: () => onEdit(jumboRoll),
              constraints: const BoxConstraints(),
            ),
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
                message: 'Are Your to Delete This jumbo Record',
                itemName: '${jumboRoll.jumboCode}',

                onConfirm: () {
                  onDelete(jumboRoll);
                },
                rPanel: 'view-jumbo-roll',
                item: jumboRollData,
                index: jumboRollData.indexOf(jumboRoll),
                rKey: jumboRoll.rKey.toString(),
              );
            },
          ),
          // SizedBox(
          //   width: 35,
          //   child: DeleteRecordButton(
          //     rKey: jumboRoll.rKey.toString(),
          //     rPanel: 'view-jumbo-roll',
          //     item: jumboRollData,
          //     index: jumboRollData.indexOf(jumboRoll),
          //     onPressed: () => onDelete(jumboRoll),
          //   ),
          // ),
          // SizedBox(
          //   width: 35,
          //   child: IconButton(
          //     padding: EdgeInsets.zero,
          //     icon: const Icon(Icons.person, size: 18),
          //     onPressed: () => onProfile(jumboRoll),
          //     constraints: const BoxConstraints(),
          //   ),
          // ),
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.label, size: 18),
              onPressed: () => stickerPopup(jumboRoll),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}

class JumboRoll {
  static final String srNo = 'Sr No';
  static final String billDate = 'Bill Date';
  static final String billNo = 'Bill No';
  static final String rollPacketNo = 'Roll/Packet No';
  static final String square = 'Square';
  static final String base = 'Base';
  static final String mic = 'Mic';
  static final String length = 'Length';
  static final String width = 'Width';
  static final String netWeight = 'Net Weight';
  static final String remark = 'Remark';
  static final String vendorCode = 'Vendor Code';
  static final String vendorName = 'Vendor Name';
  static final String amountPerKg = 'Amount Per KG';
  static final String rollCost = 'Roll Cost';
  static final String consumeLength = 'Consume Length';
  static final String availableLength = 'Available Length';
  static final String jumboStatusLabel = 'Jumbo Status';
}
