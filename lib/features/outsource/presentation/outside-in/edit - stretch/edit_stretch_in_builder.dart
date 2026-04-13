import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/service/api%20service/csv_urls.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/gen_validation_field.dart';
import 'package:indogrip/core/utils/widgets/heading_text.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/client/presentation/widgets/download_csv_button_client.dart';
import 'package:indogrip/features/client/presentation/widgets/upload_csv_button_client.dart';
import 'package:indogrip/features/global/presentation/widget/vendor_list_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/base_dropdown_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/micron_dropdown_widget.dart';
import 'package:indogrip/features/outsource/data/model/inventory_in_param.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/edit%20-%20stretch/edit_stretch_in.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/strach%20film/pages/stratch_film.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.in/inventory_bloc.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.master/master_in_bloc.dart';
import 'package:indogrip/features/outsource/presentation/widget/master_product_type_model.dart';
import 'package:indogrip/features/outsource/presentation/widget/master_stretch_film_widget.dart';
import 'package:indogrip/features/round/presentation/widgets/core_dropdown.dart';
import 'package:indogrip/features/round/presentation/widgets/master_roll_size_widget.dart';
import 'package:intl/intl.dart';

abstract class EditStretchOutsourceInBuilder
    extends State<EditStretchOutSourceIN> {
  late final InventoryBloc inventoryBloc;
  late final MasterInBloc masterInBloc;
  File? csvFile;

  Widget get headerButton => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      SizedBox(
        width: MediaQuery.sizeOf(context).width * .18,
        child: DownloadClientFileButton(
          csvURL: CSVUrls.clientCSVFilePath,
          defaultFileName: 'import-client-sample.csv',
        ),
      ),
      SizedBox(
        width: MediaQuery.sizeOf(context).width * .18,
        // flex: 4,
        child: UploadClientFileButton(activity: 'upload-csv', csvFile: csvFile),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    inventoryBloc = InventoryBloc();
    initData();
  }

  initData() {
    if (!mounted) return;
    setState(() {
      dateController.text = widget.record.billDate.toString();
      billNoController.text = widget.record.billNumber.toString();
      quantityController.text = widget.record.quantity.toString();
      remarkController.text = widget.record.remark.toString();
      netWeightController.text = widget.record.additionalInfo!.netWeight
          .toString();
      cartonPriceController.text = widget.record.cartonPrice.toString();
      transportPriceController.text = widget.record.transportPrice.toString();
      selectedProduct = widget.record.productTypeID.toString();
      selectedVendor = widget.record.vendorInfo!.vendorKey.toString();
      selectedCore = widget.record.additionalInfo!.coreID.toString();
      // selectedCore = widget.record
      grosWeightController.text = widget.record.additionalInfo!.grossWeight
          .toString();
      selectedFilmSize = widget.record.additionalInfo!.stretchFilmSizeID
          .toString();
      srNoController.text = widget.record.inventoryCode.toString();
      marginController.text = widget.record.additionalInfo!.margin.toString();
      rateController.text = widget.record.additionalInfo!.rate.toString();
      lessKGController.text = widget.record.additionalInfo!.lessWeight
          .toString();
      selectedBase = widget.record.additionalInfo!.baseID.toString();
      selectedMic = widget.record.additionalInfo!.micID.toString();
      // netWeightController.text = widget.record.additionalInfo!.netWeight
      //     .toString();
    });
  }

  final GlobalKey<ScaffoldState> stateKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey();
  String? selectedMic;

  // Date Controllers
  final dateController = TextEditingController();
  final billDateController = TextEditingController();

  // Basic Information Controllers
  final billNoController = TextEditingController();
  final quantityController = TextEditingController();
  final remarkController = TextEditingController();
  final grosWeightController = TextEditingController();
  final lessKGController = TextEditingController();
  final rateController = TextEditingController();
  final marginController = TextEditingController();

  // Tap Product Controllers
  final totalPiecesController = TextEditingController();

  final roundSizeController = TextEditingController();

  // Stretch Film Controllers
  final filmSizeController = TextEditingController();
  final netWeightController = TextEditingController();
  final perCartonPriceController = TextEditingController();

  // Bill Amount Controllers
  final cartonPriceController = TextEditingController();
  final transportPriceController = TextEditingController();
  final totalAmountController = TextEditingController();
  final srNoController = TextEditingController();

  // Dropdown Values
  String? selectedProduct;
  String? selectedVendor;
  String? selectedBase;
  String? selectedCore;
  String? selectedRoundSize;
  String? selectedFilmSize;
  String? selectedVariant;

  // Form Validation Status
  bool isSubmitPressed = false;

  submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      inventoryBloc.add(
        AddInventoryInRecordEvent(
          param: InventoryInParam(
            vendorKey: selectedVendor.toString(),
            date: dateController.text,
            billNumber: billNoController.text,
            cartonPrice: cartonPriceController.text,
            transportAmount: transportPriceController.text,
            productType: selectedProduct.toString(),
            cutMMMeter: selectedRoundSize.toString(),
            quantity: quantityController.text,
            base: selectedBase.toString(),
            grossWeight: grosWeightController.text,
            tapeLength: roundSizeController.text,
            tapeWeight: '------',
            micron: selectedMic.toString(),
            stretchFilmSize: selectedFilmSize.toString(),
            core: selectedCore.toString(),
            netWeight: netWeightController.text,
            remarks: remarkController.text,
            inventoryCode: srNoController.text,
            margin: marginController.text,
            rate: rateController.text,
            lessKGPrice: lessKGController.text,
            rKey: widget.record.rKey.toString(),
          ),
        ),
      );
    }
  }

  Widget get vendorListWidget => Expanded(
    child: VendorListWidget(
      value: selectedVendor,
      onChanged: (vendor) {
        setState(() {
          selectedVendor = vendor;
        });
      },
    ),
  );

  // Validation function
  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      return true;
    }
    return false;
  }

  // Reset form
  void resetForm() {
    formKey.currentState?.reset();
    dateController.clear();
    billDateController.clear();
    billNoController.clear();
    remarkController.clear();
    totalPiecesController.clear();
    roundSizeController.clear();
    filmSizeController.clear();
    netWeightController.clear();
    perCartonPriceController.clear();
    cartonPriceController.clear();
    transportPriceController.clear();
    totalAmountController.clear();
    setState(() {
      selectedProduct = null;
      selectedVendor = null;
      selectedBase = null;
      selectedCore = null;
      selectedRoundSize = null;
      selectedFilmSize = null;
      isSubmitPressed = false;
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    dateController.dispose();
    billDateController.dispose();
    billNoController.dispose();
    remarkController.dispose();
    totalPiecesController.dispose();
    roundSizeController.dispose();
    filmSizeController.dispose();
    netWeightController.dispose();
    perCartonPriceController.dispose();
    cartonPriceController.dispose();
    transportPriceController.dispose();
    totalAmountController.dispose();
    marginController.dispose();
    rateController.dispose();
    lessKGController.dispose();
    srNoController.dispose();
    super.dispose();
  }

  Widget get micronWidget => Expanded(
    child: MicronDropdownWidget(
      value: selectedMic.toString(),
      onChanged: (val) => setState(() => selectedMic = val),
    ),
  );

  //! Product Header Section

  Widget get buildProductHeaderDesktop => Padding(
    padding: const EdgeInsets.symmetric(
      // horizontal: kDefaultHorizontalPadding + 20,
      // vertical: kDefaultVerticalPadding,
      vertical: 20,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Outsource Information'),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding + 20,
            // vertical: kDefaultVerticalPadding,
            vertical: 20,
          ),
          child: Row(
            spacing: 16,
            children: [
              Expanded(child: buildDateField('Date', dateController)),
              Expanded(
                child: MasterProductTypeWidget(
                  value: selectedProduct,
                  onChanged: (val) => setState(() => selectedProduct = val),
                ),
              ),
              vendorListWidget,
            ],
          ),
        ),
      ],
    ),
  );

  //! billing section

  Widget get buildBillingSectionDesktop => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 30,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding + 20,
          // vertical: kDefaultVerticalPadding,
        ),
        child: Row(
          spacing: 16,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GeneralOptionalField(
                labelText: 'Serial Number',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                controller: srNoController,
              ),
            ),
            Expanded(
              child: GeneralOptionalField(
                labelText: 'Bill Number',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                controller: billNoController,
              ),
            ),
            Expanded(
              child: GeneralOptionalField(
                labelText: 'Quantity',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                controller: quantityController,
              ),
            ),
          ],
        ),
      ),
      // SizedBox(),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding + 20,
          // vertical: kDefaultVerticalPadding,
        ),
        child: Row(
          spacing: 16,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GeneralOptionalField(
                labelText: 'Carton Price',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                controller: cartonPriceController,
              ),
            ),
            Expanded(
              child: GeneralOptionalField(
                labelText: 'Transport Price',
                inputFormatters: [
                  // FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                controller: transportPriceController,
              ),
            ),

            // Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    ],
  );

  Widget get buildBillingSectionForStretchDesktop => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding + 20,
      // vertical: kDefaultVerticalPadding,
    ),
    child: Row(
      spacing: 16,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GeneralOptionalField(
            labelText: 'Serial Number',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              // LengthLimitingTextInputFormatter(10),
            ],
            controller: srNoController,
          ),
        ),
        Expanded(
          child: GeneralOptionalField(
            labelText: 'Bill Number',
            inputFormatters: [
              // FilteringTextInputFormatter.digitsOnly,
              // LengthLimitingTextInputFormatter(10),
            ],
            controller: billNoController,
          ),
        ),
        Expanded(
          child: GeneralOptionalField(
            labelText: 'Transport Price',
            inputFormatters: [
              // FilteringTextInputFormatter.digitsOnly,
              // LengthLimitingTextInputFormatter(10),
            ],
            controller: transportPriceController,
          ),
        ),
      ],
    ),
  );

  Widget get buildTapSectionDesktop => Column(
    // spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildSectionTitle('Select Tape'),
      SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding + 20,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: MasterRoleSizeSelector(
                selectedRole: selectedRoundSize,
                onChanged: (String? value) {
                  setState(() {
                    selectedRoundSize = value;
                  });
                },
              ),
            ),
            // Expanded(child: buildRoundSizeDropdown()),
            micronWidget,

            Expanded(
              child: BaseDropdownWidget(
                value: selectedBase.toString(),
                onChanged: (val) => setState(() => selectedBase = val),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 15),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding + 20,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: buildFormField('Tape Length', [], roundSizeController),
            ),
            Expanded(
              // flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GeneralOptionalField(
                  controller: remarkController,

                  inputFormatters: [
                    // FilteringTextInputFormatter.digitsOnly,
                    // LengthLimitingTextInputFormatter(10),
                  ],
                  labelText: 'Remark',
                ),
              ),
            ),
            // Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
            // Expanded(child: emptyBox('Pieces of Carton')),
            // Expanded(child: emptyBox('Price Per Carton')),
          ],
        ),
      ),
    ],
  );

  Widget get buildStretchSectionDesktop => Column(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildSectionTitle('Select Stretch Film'),
      // SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding + 20,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: MasterStretchFilmWidget(
                value: selectedFilmSize,
                onChanged: (val) => setState(() => selectedFilmSize = val),
              ),
            ),
            Expanded(
              child: CoreDropdown(
                selectedCore: selectedCore,
                onChanged: (value) {
                  setState(() {
                    selectedCore = value;
                  });
                },
              ),
            ),
            Expanded(
              child: BaseDropdownWidget(
                value: selectedBase.toString(),
                onChanged: (val) => setState(() => selectedBase = val),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding + 20,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: MicronDropdownWidget(
                value: selectedMic.toString(),
                onChanged: (val) => setState(() => selectedMic = val),
              ),
            ),
            Expanded(
              child: GeneralOptionalField(
                labelText: 'Gross Weight',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                controller: grosWeightController,
              ),
            ),
            // Expanded(child: emptyBox('Price Per Carton')),
            Expanded(
              child: GeneralOptionalField(
                labelText: 'Net Weight',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],

                controller: netWeightController,
              ),
            ),
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding + 20,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              // flex: 2,
              child: GeneralOptionalField(
                controller: marginController,

                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                labelText: 'Margin',
              ),
            ),
            Expanded(
              // flex: 2,
              child: GeneralOptionalField(
                controller: rateController,

                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                labelText: 'Rate',
              ),
            ),
            Expanded(
              // flex: 2,
              child: GeneralOptionalField(
                controller: lessKGController,

                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                labelText: 'Less KG',
              ),
            ),
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding + 20,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              // flex: 2,
              child: GeneralOptionalField(
                controller: remarkController,

                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                labelText: 'Remark',
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    ],
  );

  Widget get buildMainProductSectionDesktop => selectedProduct == '1'
      ? buildTapSectionDesktop
      : selectedProduct == '2'
      ? buildStretchSectionDesktop
      : SizedBox();

  Widget get buildRemarkDesktop => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding + 20,
      vertical: 10,
    ),
    child: Row(
      spacing: 16,
      children: [
        Expanded(
          // flex: 2,
          child: GeneralOptionalField(
            controller: totalAmountController,

            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              // LengthLimitingTextInputFormatter(10),
            ],
            labelText: 'Remark',
          ),
        ),
        Expanded(child: SizedBox()),
        Expanded(child: SizedBox()),
      ],
    ),
  );

  //! ------------------button---------------------

  Widget get submitButton => BlocConsumer(
    bloc: inventoryBloc,
    listener: (context, state) {
      if (state is InventoryInRecordAddedSuccessStatus) {
        if (state.response.status == 1) {
          context.pushNamed(StretchFilmPanel.routeName);

          ToastService.instance.showSuccess(
            context,
            state.response.message.toString(),
          );
        } else {
          ToastService.instance.showSuccess(
            context,
            state.response.message ?? 'try again later',
          );
        }
      } else if (state is InventoryInRecordAddErrorStatus) {
        ToastService.instance.showError(context, state.message);
      }
    },
    builder: (context, state) {
      if (state is InventoryLoadingStatus) {
        return Center(child: CircularProgressIndicator());
      }

      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
            Expanded(
              child: SizedBox(
                height: 48,
                child: CustomButton(label: 'Submit', onPressed: submitForm),
              ),
            ),
          ],
        ),
      );
    },
  );

  Widget buildFormField(
    String label,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController controller, {
    bool isEmail = false,
    bool isPhone = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText(label),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF9499A1)),
                borderRadius: BorderRadius.circular(5),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
            ),
            inputFormatters: inputFormatters,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              if (isEmail && !value.contains('@')) {
                return 'Please enter a valid email';
              }
              if (isPhone && value.length != 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText(label),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                setState(() {
                  controller.text = DateFormat(
                    'yyyy-MM-dd',
                  ).format(selectedDate);
                });
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF9499A1)),
                borderRadius: BorderRadius.circular(5),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              suffixIcon: const Icon(
                Icons.calendar_month,
                color: Color(0xFF2D8FCF),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
