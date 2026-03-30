import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';

import 'package:indogrip/core/service/file_picker.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/gen_validation_field.dart';
import 'package:indogrip/core/utils/widgets/heading_text.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/presentation/widget/vendor_list_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/base_dropdown_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/micron_dropdown_widget.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/width_dropdown_widget.dart';
import 'package:indogrip/features/outsource/data/model/inventory_in_param.dart';
import 'package:indogrip/features/outsource/data/model/upload_file_param.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/strach%20film/pages/stratch_film.dart';
import 'package:indogrip/features/outsource/presentation/outsource-out/panels/tap/page/tap_panel.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.in/inventory_bloc.dart';
import 'package:indogrip/features/outsource/presentation/outside-in/pages/outsource_in.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.master/master_in_bloc.dart';
import 'package:indogrip/features/outsource/presentation/widget/master_product_type_model.dart';
import 'package:indogrip/features/outsource/presentation/widget/master_stretch_film_widget.dart';
import 'package:indogrip/features/round/presentation/widgets/core_dropdown.dart';
import 'package:indogrip/features/round/presentation/widgets/master_roll_size_widget.dart';
import 'package:indogrip/features/stretch-film-miss-record/presentation/stretch_film_miss_record_panel.dart';
import 'package:indogrip/features/tape/presentation/pages/tape-miss-record/tape_miss_record_panel.dart';
import 'package:intl/intl.dart';

abstract class OutsourceInBuilder extends State<OutSourceIN> {
  late final InventoryBloc inventoryBloc;
  late final MasterInBloc masterInBloc;
  File? csvFile;

  @override
  void initState() {
    super.initState();
    inventoryBloc = InventoryBloc();
  }

  final GlobalKey<ScaffoldState> stateKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey();
  String? selectedMic;

  // Date Controllers
  final dateController = TextEditingController();
  final billDateController = TextEditingController();
  final importFileDateController = TextEditingController();

  // Basic Information Controllers
  final billNoController = TextEditingController();
  final quantityController = TextEditingController();
  final remarkController = TextEditingController();
  final grosWeightController = TextEditingController();
  final marginController = TextEditingController();
  final rateController = TextEditingController();
  final lessKGController = TextEditingController();

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
  final weightController = TextEditingController();
  final srNoController = TextEditingController();

  // Dropdown Values
  String? selectedProduct;
  String? selectedVendor;
  String? fileVendor;
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
            micron: selectedMic.toString(),
            tapeWeight: weightController.text,
            stretchFilmSize: selectedFilmSize.toString(),
            core: selectedCore.toString(),
            netWeight: netWeightController.text,
            inventoryCode: srNoController.text,
            margin: marginController.text,
            rate: rateController.text,
            lessKGPrice: lessKGController.text,
            remarks: remarkController.text,
          ),
        ),
      );
    }
  }

  Widget get vendorListWidget => Expanded(
    child: VendorListWidget(
      isFilter: false,
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
    srNoController.clear();
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
    super.dispose();
  }

  Widget get micronWidget => Expanded(
    child: MicronDropdownWidget(
      value: selectedMic.toString(),
      onChanged: (val) => setState(() => selectedMic = val),
    ),
  );

  Widget get buttonUi => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: 15,
    ),
    child: SizedBox(
      width: MediaQuery.sizeOf(context).width * .18,
      child: CustomButton(
        color: csvFile != null ? Colors.blue : null,

        label: csvFile != null ? 'Uploaded' : 'Upload File',
        onPressed: () async {
          if (!mounted) return;
          final File? pickedFile = await FilePickerService.pickFileFromDevice(
            csvFile,
          );
          if (pickedFile != null) {
            setState(() {
              csvFile = pickedFile;
            });
          }
          if (csvFile != null) {
            showDialog(
              context: context,
              builder: (context) => customAlertBoxWidget(),
            );
          }
        },
      ),
    ),
  );

  Widget get uploadCSVButton => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: 15,
    ),
    child: BlocConsumer(
      bloc: inventoryBloc,
      listener: (context, state) {
        if (state is InventoryInUploadCSVFileSuccessStatus) {
          if (state.response.status == 1) {
            if (!context.mounted) return;
            ToastService.instance.showSuccess(
              context,
              state.response.message.toString(),
            );
          } else {
            if (!context.mounted) return;
            ToastService.instance.showError(
              context,
              state.response.message.toString(),
            );
          }
          if (state.response.missRecord != null) {
            GoRouter.of(
              context,
            ).pushNamed(TapeMissRecordPanel.routeName, extra: state.response);
            context.pop();
          }
        } else if (state is InventoryInUploadCSVFileFailedErrorStatus) {
          if (!context.mounted) return;
          ToastService.instance.showError(context, state.message.toString());
        } else if (state is InventoryInStretchUploadCSVFileSuccessStatus) {
          if (state.response.status == 1) {
            if (!context.mounted) return;
            ToastService.instance.showSuccess(
              context,
              state.response.message.toString(),
            );
          } else {
            if (!context.mounted) return;
            ToastService.instance.showError(
              context,
              state.response.message.toString(),
            );
          }
          if (state.response.missRecord != null) {
            GoRouter.of(context).pushNamed(
              StretchFilmMissRecordPanel.routeName,
              extra: state.response,
            );
            context.pop();
          }
        }
      },
      builder: (context, state) {
        if (state is InventoryLoadingStatus) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return TextButton(
          onPressed: () {
            if (csvFile != null) {
              // if()
              inventoryBloc.add(
                AddInventoryUploadCSVFileEvent(
                  param: UploadFileParam(
                    activity: '',
                    productType: selectedProduct.toString(),
                    csvFile: csvFile!,
                    billNumber: billNoController.text,
                    date: importFileDateController.text,
                    selectedVendor: fileVendor ?? '',
                  ),
                ),
              );
            } else {
              ToastService.instance.showError(
                context,
                'Please select a CSV file to upload.',
              );
            }
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Upload'),
        );
      },
    ),
  );

  Widget customAlertBoxWidget() => AlertDialog(
    titlePadding: EdgeInsets.zero,
    title: Container(
      width: 550,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.sticky_note_2, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          const Text(
            'Sticker Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    ),
    content: StatefulBuilder(
      builder: (context, dialogSetState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            selectedProduct != null
                ? const Text(
                    'Please Select Procuct Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )
                : const Text(
                    'Sure you want to Upload this File?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
            MasterProductTypeWidget(
              value: selectedProduct.toString(),
              onChanged: (val) {
                dialogSetState(() {
                  selectedProduct = val ?? '';
                });
                // notify parent if callback provided
              },
            ),
            VendorListWidget(
              isFilter: false,
              value: fileVendor,
              onChanged: (vendor) {
                setState(() {
                  fileVendor = vendor;
                });
              },
            ),
            buildDateField('Bill Date', importFileDateController),
            GeneralOptionalField(
              labelText: 'Bill Number',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(10),
              ],
              controller: billNoController,
            ),
          ],
        );
      },
    ),
    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
    actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
    actions: [
      Row(
        children: [
          TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Close'),
          ),
          uploadCSVButton,
        ],
      ),
    ],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: Colors.white,
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
          ),
          child: Row(
            spacing: 16,
            // crossAxisAlignment: CrossAxisAlignment.start,
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
                  // FilteringTextInputFormatter.digitsOnly,
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
                  // FilteringTextInputFormatter.digitsOnly,
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
              // FilteringTextInputFormatter.digitsOnly,
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
              child: GeneralOptionalField(
                labelText: 'Tape Length',
                inputFormatters: [],
                controller: roundSizeController,
              ),
            ),
            Expanded(
              child: GeneralOptionalField(
                labelText: 'Weight',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                controller: weightController,
              ),
            ),

            Expanded(
              // flex: 2,
              child: GeneralOptionalField(
                controller: totalAmountController,

                inputFormatters: [
                  // FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                labelText: 'Remark',
              ),
            ),
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
                labelText: 'Net Weight',
                inputFormatters: [
                  // FilteringTextInputFormatter.d,
                  // LengthLimitingTextInputFormatter(10),
                ],

                controller: netWeightController,
              ),
            ),
            Expanded(
              child: GeneralOptionalField(
                labelText: 'Gross Weight',
                inputFormatters: [
                  // FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                controller: grosWeightController,
              ),
            ),
            // Expanded(child: emptyBox('Price Per Carton')),

            // Expanded(child: SizedBox()),
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
                  // FilteringTextInputFormatter.digitsOnly,
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
                  // FilteringTextInputFormatter.digitsOnly,
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
                  // FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                labelText: 'Less KG',
              ),
            ),
            // Expanded(child: emptyBox('Price Per Carton')),

            // Expanded(child: SizedBox()),
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
                  // FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(10),
                ],
                labelText: 'Remark',
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
            // Expanded(child: emptyBox('Price Per Carton')),

            // Expanded(child: SizedBox()),
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
            controller: remarkController,

            inputFormatters: [
              // FilteringTextInputFormatter.digitsOnly,
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
          if (selectedProduct == '1') {
            context.pushNamed(TapPanel.routeName);
          } else if (selectedProduct == '2') {
            context.pushNamed(StretchFilmPanel.routeName);
          }
          ToastService.instance.showSuccess(
            context,
            state.response.message.toString(),
          );
        } else {
          ToastService.instance.showSuccess(
            context,
            state.response.message.toString(),
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
