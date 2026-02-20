import 'package:flutter/material.dart';
import 'package:indogrip/features/vendor/data/vendor_miss_record_datasource.dart';
import 'package:indogrip/features/vendor/presentation/pages/vendor-miss-record/vendor_miss_record_panel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../core/utils/widgets/textfield_label.dart';

abstract class VendorMissRecordPanelBuilder
    extends State<VendorMissRecordPanel> {
  late Map<String, double> columnWidths = {};
  bool isChecked = false;
  final GlobalKey _key = GlobalKey();
  late VendorMissRecordDataSource? _dataSource;
  List<DataGridRow> selectedRows = [];

  @override
  void initState() {
    super.initState();
    _dataSource = VendorMissRecordDataSource(
      context: context,
      vendorData: getDummyVendorData(),
    );
  }

  List<VendorRecord> getDummyVendorData() {
    return [
      VendorRecord(
        sNo: 1,
        vCode: 'VC001',
        vName: 'ABC Supplies',
        vMobileNumber: '9876543210',
        vGSTIN: '27AAPCI1234R0Z1',
        vContactPersonName: 'Rajesh Kumar',
        vContactPersonMobile: '9876543210',
        vContactPersonAlternate: '9876543211',
        vBankAccountName: 'ABC Supplies Pvt Ltd',
        vBankAccountNumber: '1234567890123456',
        vBankIFSC: 'SBIN0001234',
      ),
      VendorRecord(
        sNo: 2,
        vCode: 'VC002',
        vName: 'XYZ Trading',
        vMobileNumber: '9876543214',
        vGSTIN: '27AAPCI5678R0Z2',
        vContactPersonName: 'Priya Singh',
        vContactPersonMobile: '9876543215',
        vContactPersonAlternate: '9876543216',
        vBankAccountName: 'XYZ Trading Co',
        vBankAccountNumber: '9876543210123456',
        vBankIFSC: 'HDFC0005678',
      ),
      VendorRecord(
        sNo: 3,
        vCode: 'VC003',
        vName: 'Global Vendors',
        vMobileNumber: '9876543219',
        vGSTIN: '27AAPCI9101R0Z3',
        vContactPersonName: 'Amit Patel',
        vContactPersonMobile: '9876543220',
        vContactPersonAlternate: '9876543221',
        vBankAccountName: 'Global Vendors Inc',
        vBankAccountNumber: '5555666677778888',
        vBankIFSC: 'ICIC0009101',
      ),
      VendorRecord(
        sNo: 4,
        vCode: 'VC004',
        vName: 'Premium Distribution',
        vMobileNumber: '9876543224',
        vGSTIN: '27AAPCI1112R0Z4',
        vContactPersonName: 'Neha Gupta',
        vContactPersonMobile: '9876543225',
        vContactPersonAlternate: '9876543226',
        vBankAccountName: 'Premium Distribution Ltd',
        vBankAccountNumber: '1111222233334444',
        vBankIFSC: 'AXIS0001112',
      ),
      VendorRecord(
        sNo: 5,
        vCode: 'VC005',
        vName: 'Metro Supplies',
        vMobileNumber: '9876543229',
        vGSTIN: '27AAPCI3141R0Z5',
        vContactPersonName: 'Vikram Sharma',
        vContactPersonMobile: '9876543230',
        vContactPersonAlternate: '9876543231',
        vBankAccountName: 'Metro Supplies Co',
        vBankAccountNumber: '9999888877776666',
        vBankIFSC: 'BKID0003141',
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
        columnName: 'Vendor Code',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Vendor Code')),
        ),
      ),
      GridColumn(
        columnName: 'Vendor Name',
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Vendor Name')),
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
        columnName: 'Contact Person',
        width: 180,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Contact Person')),
        ),
      ),
      GridColumn(
        columnName: 'Contact Mobile',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Contact Mobile')),
        ),
      ),
      GridColumn(
        columnName: 'Alternate Mobile',
        width: 160,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Alternate Mobile')),
        ),
      ),
      GridColumn(
        columnName: 'Bank Account Name',
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Bank Account Name')),
        ),
      ),
      GridColumn(
        columnName: 'Bank Account Number',
        width: 200,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Bank Account Number')),
        ),
      ),
      GridColumn(
        columnName: 'Bank IFSC',
        width: 150,
        label: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          child: const Center(child: TextFieldlabelText('Bank IFSC')),
        ),
      ),
      // GridColumn(
      //   columnName: 'Status',
      //   width: 120,
      //   label: Container(
      //     color: Colors.grey[100],
      //     child: const Center(child: TextFieldlabelText('Status')),
      //   ),
      // ),
      // GridColumn(
      //   columnName: 'actions',
      //   width: 120,
      //   label: Container(
      //     color: Colors.grey[100],
      //     child: const Center(child: TextFieldlabelText('Actions')),
      //   ),
      // ),
    ];
  }
}
