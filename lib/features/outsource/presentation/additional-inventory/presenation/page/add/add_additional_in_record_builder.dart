import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/custom_date_picker.dart';
import 'package:indogrip/core/utils/widgets/custom_textfield.dart';
import 'package:indogrip/features/global/presentation/widget/vendor_list_widget.dart';
import 'package:indogrip/features/outsource/presentation/additional-inventory/presenation/page/add/add_additional_inv.dart';

/// Data model for API submission
class SilicaRecordData {
  final String serialNumber;
  final String gross;
  final String cost;
  final String transportPrice;
  final String margin;
  final String totalPrice;
  final String remark;

  SilicaRecordData({
    required this.serialNumber,
    required this.gross,
    required this.cost,
    required this.transportPrice,
    required this.margin,
    required this.totalPrice,
    required this.remark,
  });

  /// Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'serial_number': serialNumber,
      'gross': gross,
      'cost': cost,
      'transport_price': transportPrice,
      'margin': margin,
      'total_price': totalPrice,
      'remark': remark,
    };
  }

  @override
  String toString() {
    return 'SilicaRecordData(serialNumber: $serialNumber, cost: $cost, margin: $margin, totalPrice: $totalPrice)';
  }
}

/// Main API request model
class AddSilicaRequestData {
  final String billDate;
  final String billNumber;
  final String vendor;
  final List<SilicaRecordData> silicaRecords;

  AddSilicaRequestData({
    required this.billDate,
    required this.billNumber,
    required this.vendor,
    required this.silicaRecords,
  });

  /// Convert to JSON for API submission
  Map<String, dynamic> toJson() {
    return {
      'bill_date': billDate,
      'bill_number': billNumber,
      'vendor_id': vendor,
      'silica_records': silicaRecords.map((record) => record.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'AddSilicaRequestData(billDate: $billDate, billNumber: $billNumber, vendor: $vendor, records: ${silicaRecords.length})';
  }
}

// Model to hold silica record data
class SilicaRecord {
  final TextEditingController serialNumberController;
  final TextEditingController grossController;
  final TextEditingController costController;
  final TextEditingController transportPriceController;
  final TextEditingController subTotalController;
  final TextEditingController marginController;
  final TextEditingController totalPriceController;
  final TextEditingController remarkController;

  SilicaRecord()
    : serialNumberController = TextEditingController(),
      grossController = TextEditingController(),
      costController = TextEditingController(),
      transportPriceController = TextEditingController(),
      subTotalController = TextEditingController(),
      marginController = TextEditingController(),
      totalPriceController = TextEditingController(),
      remarkController = TextEditingController();

  void dispose() {
    serialNumberController.dispose();
    grossController.dispose();
    costController.dispose();
    transportPriceController.dispose();
    subTotalController.dispose();
    marginController.dispose();
    totalPriceController.dispose();
    remarkController.dispose();
  }
}

abstract class AdditionalInventoryRecordBuilder
    extends State<AdditionalInventoryRecordPanel> {
  final TextEditingController billDateController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  String? selectedVendor;

  // List to hold multiple silica records
  late List<SilicaRecord> silicaRecords;

  @override
  void initState() {
    super.initState();
    // Initialize with one empty record
    silicaRecords = [SilicaRecord()];
  }

  @override
  void dispose() {
    billDateController.dispose();
    billNumberController.dispose();
    for (var record in silicaRecords) {
      record.dispose();
    }
    super.dispose();
  }

  /// Add a new silica record
  void addSilicaRecord() {
    setState(() {
      silicaRecords.add(SilicaRecord());
    });
  }

  /// Remove a silica record by index
  void removeSilicaRecord(int index) {
    if (silicaRecords.length > 1) {
      setState(() {
        silicaRecords[index].dispose();
        silicaRecords.removeAt(index);
      });
    }
  }

  /// Validate all records
  bool validateAllRecords() {
    for (int i = 0; i < silicaRecords.length; i++) {
      final record = silicaRecords[i];

      if (record.serialNumberController.text.isEmpty) {
        _showError('Record ${i + 1}: Serial number is required');
        return false;
      }
      if (record.grossController.text.isEmpty) {
        _showError('Record ${i + 1}: Gross amount is required');
        return false;
      }
      if (record.costController.text.isEmpty) {
        _showError('Record ${i + 1}: Cost is required');
        return false;
      }
      if (record.marginController.text.isEmpty) {
        _showError('Record ${i + 1}: Margin is required');
        return false;
      }

      // Validate margin <= 100
      final margin = double.tryParse(record.marginController.text) ?? 0.0;
      if (margin > 100) {
        _showError('Record ${i + 1}: Margin must be <= 100');
        return false;
      }
    }

    if (billDateController.text.isEmpty) {
      _showError('Bill date is required');
      return false;
    }
    if (billNumberController.text.isEmpty) {
      _showError('Bill number is required');
      return false;
    }
    if (selectedVendor == null || selectedVendor!.isEmpty) {
      _showError('Vendor is required');
      return false;
    }

    return true;
  }

  /// Collect all records data into a single request object
  AddSilicaRequestData collectAllRecordsData() {
    final records = silicaRecords.map((record) {
      return SilicaRecordData(
        serialNumber: record.serialNumberController.text.trim(),
        gross: record.grossController.text.trim(),
        cost: record.costController.text.trim(),
        transportPrice: record.transportPriceController.text.trim(),
        margin: record.marginController.text.trim(),
        totalPrice: record.totalPriceController.text.trim(),
        remark: record.remarkController.text.trim(),
      );
    }).toList();

    return AddSilicaRequestData(
      billDate: billDateController.text.trim(),
      billNumber: billNumberController.text.trim(),
      vendor: selectedVendor ?? '',
      silicaRecords: records,
    );
  }

  /// Log collected data (for debugging)
  void logCollectedData() {
    final data = collectAllRecordsData();
    developer.log('Silica Records Data:', name: 'SilicaForm');
    developer.log('Bill Date: ${data.billDate}', name: 'SilicaForm');
    developer.log('Bill Number: ${data.billNumber}', name: 'SilicaForm');
    developer.log('Vendor: ${data.vendor}', name: 'SilicaForm');
    developer.log(
      'Total Records: ${data.silicaRecords.length}',
      name: 'SilicaForm',
    );

    for (int i = 0; i < data.silicaRecords.length; i++) {
      final record = data.silicaRecords[i];
      developer.log(
        'Record ${i + 1}: ${record.toString()}',
        name: 'SilicaForm',
      );
    }

    developer.log('JSON: ${data.toJson()}', name: 'SilicaForm');
  }

  /// Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show success message
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Example API submission method
  /// Replace this with your actual API call
  Future<void> submitSilicaRecords() async {
    try {
      // Validate all records
      if (!validateAllRecords()) {
        return;
      }

      // Collect data
      final requestData = collectAllRecordsData();

      // Log data for debugging
      logCollectedData();

      // Convert to JSON
      final jsonData = requestData.toJson();
      developer.log('Sending to API: $jsonData', name: 'SilicaAPI');

      // TODO: Replace with your actual API call
      // Example:
      // final response = await _silicaRepository.addSilicaRecords(jsonData);
      //
      // if (response.status == 1) {
      //   _showSuccess('Silica records added successfully!');
      //   // Navigate or clear form
      // } else {
      //   _showError(response.message ?? 'Failed to add records');
      // }

      _showSuccess(
        '${requestData.silicaRecords.length} records ready for submission',
      );
    } catch (e) {
      developer.log('Error: $e', name: 'SilicaForm', error: e);
      _showError('Error: $e');
    }
  }

  /// Calculate total price for a specific silica record
  void calculateTotalPriceForRecord(SilicaRecord record) {
    final gross = double.tryParse(record.grossController.text) ?? 0.0;
    final cost = double.tryParse(record.costController.text) ?? 0.0;
    final margin = double.tryParse(record.marginController.text) ?? 0.0;
    final transportPrice =
        double.tryParse(record.transportPriceController.text) ?? 0.0;

    // Total Price = (Cost + Transport) + (Margin amount)
    // Margin is treated as a percentage of (Cost + Transport)
    final basePrice = cost + transportPrice;
    record.subTotalController.text = basePrice.toStringAsFixed(2);
    final marginAmount = margin > 0 ? (basePrice * margin / 100) : 0.0;
    final totalPrice = basePrice + marginAmount;

    record.totalPriceController.text = totalPrice.toStringAsFixed(2);
  }

  Widget get vendorListWidget => VendorListWidget(
    isFilter: false,
    value: selectedVendor,
    onChanged: (vendor) {
      setState(() {
        selectedVendor = vendor;
      });
    },
  );

  Widget get buildBillDateField => CustomDatePicker(
    controller: billDateController,
    labelText: 'Bill Date',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please select the bill date';
      }
      return null;
    },
  );

  Widget get buildBillNumberField => CustomTextField(
    controller: billNumberController,
    labelText: 'Bill Number',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the bill number';
      }
      return null;
    },
  );

  /// Build margin field for a specific record
  Widget buildMarginFieldForRecord(SilicaRecord record) => CustomTextField(
    controller: record.marginController,
    labelText: 'Margin',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the margin';
      }
      final numValue = double.tryParse(value);
      if (numValue == null) {
        return 'Please enter a valid number';
      }
      if (numValue > 100) {
        return 'Margin must be less than or equal to 100';
      }
      return null;
    },
    onChanged: (value) {
      calculateTotalPriceForRecord(record);
    },
    inputFormatters: [
      // Allow only numbers and decimal point with max 3 integer digits (up to 100)
      FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}\.?\d{0,2}')),
      // Limit total length to 6 characters (3 digits + 1 decimal + 2 decimal places)
      LengthLimitingTextInputFormatter(6),
    ],
  );

  /// Build gross field for a specific record
  Widget buildGrossFieldForRecord(SilicaRecord record) => CustomTextField(
    controller: record.grossController,
    labelText: 'Weight',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the gross amount';
      }
      if (double.tryParse(value) == null) {
        return 'Please enter a valid number';
      }
      return null;
    },
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
    ],
  );

  /// Build cost field for a specific record
  Widget buildCostFieldForRecord(SilicaRecord record) => CustomTextField(
    controller: record.costController,
    labelText: 'Carton Cost',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the cost';
      }
      if (double.tryParse(value) == null) {
        return 'Please enter a valid number';
      }
      return null;
    },
    onChanged: (value) {
      calculateTotalPriceForRecord(record);
    },
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
    ],
  );

  /// Build total price field for a specific record
  Widget buildTotalPriceFieldForRecord(SilicaRecord record) => CustomTextField(
    controller: record.totalPriceController,
    readOnly: true,
    labelText: 'Total Price',
    fillColor: Colors.tealAccent.withOpacity(0.3),
  );

  /// Build transport price field for a specific record
  Widget buildTransportPriceFieldForRecord(SilicaRecord record) =>
      CustomTextField(
        controller: record.transportPriceController,
        labelText: 'Transport Price',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the transport price';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
        onChanged: (value) {
          calculateTotalPriceForRecord(record);
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
      );

  /// Build serial number field for a specific record
  Widget buildSerialNumberFieldForRecord(SilicaRecord record) =>
      CustomTextField(
        controller: record.serialNumberController,
        labelText: 'Serial Number',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the serial number';
          }
          return null;
        },
      );

  /// Build sub total field for a specific record
  Widget buildSubTotalFieldForRecord(SilicaRecord record) => CustomTextField(
    controller: record.subTotalController,
    labelText: 'Sub Total',
    readOnly: true,
    fillColor: Colors.tealAccent.withOpacity(0.3),
  );

  /// Build remark field for a specific record
  Widget buildRemarkFieldForRecord(SilicaRecord record) => CustomTextField(
    controller: record.remarkController,
    labelText: 'Remark',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a remark';
      }
      return null;
    },
  );

  Widget buildMultiWidgetRowWidgetForRecord(SilicaRecord record, int index) =>
      Row(
        spacing: Responsive.betweenSpace,
        children: [
          Expanded(child: buildCostFieldForRecord(record)),
          Expanded(child: buildTransportPriceFieldForRecord(record)),
          Expanded(child: buildSubTotalFieldForRecord(record)),
          Expanded(child: buildMarginFieldForRecord(record)),
          Expanded(child: buildTotalPriceFieldForRecord(record)),
        ],
      );

  /// Build middle row for a specific record with delete button
  Widget buildMiddleRowWidgetForRecord(SilicaRecord record, int index) => Row(
    spacing: Responsive.betweenSpace,
    children: [
      Expanded(child: buildSerialNumberFieldForRecord(record)),
      Expanded(child: buildGrossFieldForRecord(record)),
      Expanded(child: buildRemarkFieldForRecord(record)),
      Expanded(child: SizedBox()),
      Expanded(child: SizedBox()),
    ],
  );

  // /// Build pricing row for a specific record
  // Widget buildPricingRowWidgetForRecord(SilicaRecord record) => Row(
  //   spacing: Responsive.betweenSpace,
  //   children: [
  //     Expanded(child: buildTransportPriceFieldForRecord(record)),
  //     Expanded(child: buildSubTotalFieldForRecord(record)),
  //     Expanded(child: buildMarginFieldForRecord(record)),
  //   ],
  // );

  /// Build remark row for a specific record with remove button
  Widget buildRemarkRowWidgetForRecord(SilicaRecord record, int index) => Row(
    spacing: Responsive.betweenSpace,
    children: [
      Expanded(child: SizedBox()),
      Expanded(child: SizedBox()),
    ],
  );

  Widget get buildSilicaHeaderWidget => Row(
    spacing: Responsive.betweenSpace,
    children: [
      Expanded(child: vendorListWidget),
      Expanded(child: buildBillDateField),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 18),
          child: buildBillNumberField,
        ),
      ),
    ],
  );

  Widget get buildSubmitButton => Row(
    spacing: Responsive.betweenSpace,
    children: [
      Expanded(child: SizedBox()),
      Expanded(child: SizedBox()),
      Expanded(child: SizedBox()),
      Expanded(child: SizedBox()),
      Expanded(
        child: CustomButton(label: 'Submit', onPressed: submitSilicaRecords),
      ),
    ],
  );
}
