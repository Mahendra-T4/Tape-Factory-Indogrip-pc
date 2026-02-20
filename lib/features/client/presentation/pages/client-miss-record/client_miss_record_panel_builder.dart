import 'package:flutter/material.dart';
import 'package:indogrip/features/client/data/client_miss_record_datasource.dart';
import 'package:indogrip/features/client/data/model/view_staff_modeld.dart';
import 'package:indogrip/features/client/presentation/pages/client-miss-record/client_miss_record_panel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../core/utils/widgets/textfield_label.dart';

abstract class ClientMissRecordPanelBuilder
    extends State<ClientMissRecordPanel> {
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  final GlobalKey _key = GlobalKey();
  late ClientMIssRecordDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];

  @override
  void initState() {
    super.initState();
    _dataSource = ClientMIssRecordDataSource(
      context: context,
      clientData: getDummyClientData(),
    );
  }

  List<ClientRecord> getDummyClientData() {
    return [
      ClientRecord(
        sNo: 1,
        cCode: 'CC001',
        cConsigneeName: 'John Doe',
        cMobileNumber: '9876543210',
        cGSTIN: '27AAPCI1234R0Z1',
        cOwnerName: 'Mr. Smith',
        cOwnerMobileNumber: '9876543210',
        cOwnerAlternateNumber: '9876543211',
        cPurchaseManagerName: 'Sarah Johnson',
        cPurchaseManagerNumber: '9876543212',
        cPurchaseManagerAlternateNumber: '9876543213',
      ),
      ClientRecord(
        sNo: 2,
        cCode: 'CC002',
        cConsigneeName: 'Jane Smith',
        cMobileNumber: '9876543214',
        cGSTIN: '27AAPCI5678R0Z2',
        cOwnerName: 'Mr. Wilson',
        cOwnerMobileNumber: '9876543215',
        cOwnerAlternateNumber: '9876543216',
        cPurchaseManagerName: 'Mike Brown',
        cPurchaseManagerNumber: '9876543217',
        cPurchaseManagerAlternateNumber: '9876543218',
      ),
      ClientRecord(
        sNo: 3,
        cCode: 'CC003',
        cConsigneeName: 'Robert Miller',
        cMobileNumber: '9876543219',
        cGSTIN: '27AAPCI9101R0Z3',
        cOwnerName: 'Ms. Davis',
        cOwnerMobileNumber: '9876543220',
        cOwnerAlternateNumber: '9876543221',
        cPurchaseManagerName: 'Emma Taylor',
        cPurchaseManagerNumber: '9876543222',
        cPurchaseManagerAlternateNumber: '9876543223',
      ),
      ClientRecord(
        sNo: 4,
        cCode: 'CC004',
        cConsigneeName: 'Lisa Anderson',
        cMobileNumber: '9876543224',
        cGSTIN: '27AAPCI1112R0Z4',
        cOwnerName: 'Mr. Thompson',
        cOwnerMobileNumber: '9876543225',
        cOwnerAlternateNumber: '9876543226',
        cPurchaseManagerName: 'James Martinez',
        cPurchaseManagerNumber: '9876543227',
        cPurchaseManagerAlternateNumber: '9876543228',
      ),
      ClientRecord(
        sNo: 5,
        cCode: 'CC005',
        cConsigneeName: 'Michael Garcia',
        cMobileNumber: '9876543229',
        cGSTIN: '27AAPCI3141R0Z5',
        cOwnerName: 'Ms. Rodriguez',
        cOwnerMobileNumber: '9876543230',
        cOwnerAlternateNumber: '9876543231',
        cPurchaseManagerName: 'Jennifer Lee',
        cPurchaseManagerNumber: '9876543232',
        cPurchaseManagerAlternateNumber: '9876543233',
      ),
    ];
  }

  Widget get buildTableRecordWidget => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: SfDataGrid(
        showHorizontalScrollbar: true,
        key: _key,
        rowsPerPage: 4,
        allowPullToRefresh: true,
        allowColumnsResizing: true,
        columnResizeMode: ColumnResizeMode.onResizeEnd,
        isScrollbarAlwaysShown: true,
        showVerticalScrollbar: true,

        onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
          setState(() {
            columnWidths[details.column.columnName] = details.width;
          });
          return true;
        },
        source: _dataSource!,

        columns: buildGridColumns(),
      ),
    ),
  );

  List<GridColumn> buildGridColumns() {
    return [
      GridColumn(
        columnName: 'Sr No',
        columnWidthMode: ColumnWidthMode.fitByCellValue,
        width: 70,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Sr No')),
        ),
      ),
      GridColumn(
        columnName: 'Client Code',
        // columnWidthMode: ColumnWidthMode.fill,
        width: 180,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Client Code')),
        ),
      ),
      GridColumn(
        columnName: 'Consignee Name',
        width: 300,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Consignee Name')),
        ),
      ),

      GridColumn(
        columnName: 'Mobile Number',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Mobile Number')),
        ),
      ),
      GridColumn(
        columnName: 'GSTIN',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('GSTIN')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Name',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Owner Name')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Owner Mobile')),
        ),
      ),
      GridColumn(
        columnName: 'Owner Alternate Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(
            child: TextFieldlabelText('Owner Alternate Mobile'),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Purchase Manager',
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Purchase Manager')),
        ),
      ),
      GridColumn(
        columnName: 'Manager Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Manager Mobile')),
        ),
      ),
      GridColumn(
        columnName: 'Manager Alternate Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(
            child: TextFieldlabelText('Manager Alternate Mobile'),
          ),
        ),
      ),
     
    ];
  }
}
