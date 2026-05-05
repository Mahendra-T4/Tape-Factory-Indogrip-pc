import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/custom_date_picker.dart';
import 'package:indogrip/core/utils/widgets/custom_textfield.dart';
import 'package:indogrip/features/global/presentation/widget/vendor_list_widget.dart';
import 'package:indogrip/features/outsource/presentation/packing-strip/presentation/page/add/add_packing_strip.dart';

abstract class AddPackingStripRecordBuilder
    extends State<AddPackingStripRecordPanel> {
  final TextEditingController billDateController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController marginController = TextEditingController();
  final TextEditingController grossController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController transportPriceController =
      TextEditingController();

  final TextEditingController remarkController = TextEditingController();

  final TextEditingController subTotalController = TextEditingController();
  String? selectedVendor;

  // Multi-record support
  late List<Map<String, dynamic>> packingStripRecords;

  @override
  void initState() {
    super.initState();
    packingStripRecords = [{}]; // Initialize with one empty record
  }

  void addPackingStripRecord() {
    setState(() {
      packingStripRecords.add({});
    });
  }

  void deletePackingStripRecord(int index) {
    if (packingStripRecords.length > 1) {
      setState(() {
        packingStripRecords.removeAt(index);
      });
    }
  }

  calculateTotalPrice() {
    final gross = double.tryParse(grossController.text) ?? 0.0;
    final cost = double.tryParse(costController.text) ?? 0.0;
    final margin = double.tryParse(marginController.text) ?? 0.0;
    final transportPrice =
        double.tryParse(transportPriceController.text) ?? 0.0;

    // Total Price = (Cost + Transport) + (Margin amount)
    // Margin is treated as a percentage of (Cost + Transport)
    final basePrice = cost + transportPrice;
    subTotalController.text = basePrice.toStringAsFixed(2);
    final marginAmount = margin > 0 ? (basePrice * margin / 100) : 0.0;
    final totalPrice = basePrice + marginAmount;

    totalPriceController.text = totalPrice.toStringAsFixed(2);
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
  Widget get subTotalField => CustomTextField(
    controller: subTotalController,
    labelText: 'Sub Total',
    readOnly: true,
    fillColor: Colors.tealAccent.withOpacity(0.3),
  );

  Widget get buildSerialNumberField => CustomTextField(
    controller: serialNumberController,
    labelText: 'Serial Number',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the serial number';
      }
      return null;
    },
  );

  Widget get buildMarginField => CustomTextField(
    controller: marginController,
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
      calculateTotalPrice();
    },
    inputFormatters: [
      // Allow only numbers and decimal point with max 3 integer digits (up to 100)
      FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}\.?\d{0,2}')),
      // Limit total length to 6 characters (3 digits + 1 decimal + 2 decimal places)
      LengthLimitingTextInputFormatter(6),
    ],
  );

  Widget get buildGrossField => CustomTextField(
    controller: grossController,
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

  Widget get buildCostField => CustomTextField(
    controller: costController,
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
      calculateTotalPrice();
    },
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
    ],
  );

  // Widget get buildPricingRowWidget => Row(
  //   spacing: Responsive.betweenSpace,
  //   children: [Expanded(child: buildTransportPriceField)],
  // );

  Widget buildMultiWidgetRowWidgetForRecord(
    Map<String, dynamic> record,
    int index,
  ) => Row(
    spacing: Responsive.betweenSpace,
    children: [
      Expanded(child: buildCostField),
      Expanded(child: buildTransportPriceField),
      Expanded(child: subTotalField),
      Expanded(child: buildMarginField),
    ],
  );

  Widget get buildTotalPriceField => CustomTextField(
    controller: totalPriceController,
    readOnly: true,
    labelText: 'Total Price',
    fillColor: Colors.tealAccent.withOpacity(0.3),
    // onChanged: (value) {
    //   calculateTotalPrice();
    // },

    // validator: (value) {
    //   if (value == null || value.isEmpty) {
    //     return 'Please enter the total price';
    //   }
    //   if (double.tryParse(value) == null) {
    //     return 'Please enter a valid number';
    //   }
    //   return null;
    // },
  );

  Widget get buildTransportPriceField => CustomTextField(
    controller: transportPriceController,
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
      calculateTotalPrice();
    },
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
    ],
  );

  Widget get buildRemarkField => CustomTextField(
    controller: remarkController,
    labelText: 'Remark',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a remark';
      }
      return null;
    },
  );

  Widget get buildPackingStripHeaderWidget => Row(
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

  Widget buildMiddleRowWidgetForRecord(
    Map<String, dynamic> record,
    int index,
  ) => Row(
    spacing: Responsive.betweenSpace,
    children: [
      Expanded(child: buildSerialNumberField),
      Expanded(child: buildGrossField),
      Expanded(child: buildTotalPriceField),
    ],
  );

  Widget get buildRemarkRowWidget => Row(
    spacing: Responsive.betweenSpace,
    children: [
      Expanded(child: buildRemarkField),
      Expanded(child: SizedBox()),
    ],
  );

  Widget buildRemarkRowWidgetForRecord(
    Map<String, dynamic> record,
    int index,
  ) => Row(
    spacing: Responsive.betweenSpace,
    children: [
      Expanded(child: buildRemarkField),
      Expanded(child: SizedBox()),
      Expanded(child: SizedBox()),
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
        child: CustomButton(label: 'Submit', onPressed: () {}),
      ),
    ],
  );
}
