import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:indogrip/core/service/barcode_isolate_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/custom_textfield.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/carton/presentation/widgets/master_carton_type.dart';
import 'package:indogrip/features/global/domain/repositories/global_repo.dart';
import 'package:indogrip/features/global/presentation/widget/uploadFile_button.dart';
import 'package:indogrip/features/round/data/models/add_round_param_model.dart';
import 'package:indogrip/features/round/data/models/master_jumboRoll_model.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';
import 'package:indogrip/features/round/presentation/bloc/round_bloc.dart';
import 'package:indogrip/features/round/presentation/pages/add/add_round.dart';
import 'package:indogrip/features/round/presentation/pages/view/view_round.dart';
import 'package:indogrip/features/round/presentation/widgets/core_dropdown.dart';
import 'package:indogrip/features/round/presentation/widgets/master_jumbo_roll_drowdown.dart';
import 'package:indogrip/features/round/presentation/widgets/master_roll_size_widget.dart';
import 'package:intl/intl.dart';

abstract class AddRoundBuilder extends State<AddRoundPanel> {
  late RoundBloc _roundBloc;
  File? csvFile;
  String? selectedCartonType;
  final TextEditingController addScannedBarcodeController =
      TextEditingController();
  final FocusNode _barcodeFocusNode = FocusNode();

  @override
  void initState() {
    _roundBloc = RoundBloc(addRoundRepository: AddRoundRepository());
    super.initState();
    // Auto-focus the barcode field when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _barcodeFocusNode.requestFocus();
    });
  }

  formSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      _roundBloc.add(
        AddRoundONRecordEvent(
          addRoundParam: AddRoundParam(
            jumboRoll: selectedJumbo,
            rollSize: selectedSize.toString(),
            rollCore: selectedCore.toString(),
            round: roundController.text,
            meters: meterController.text,
            damagePieces: damagePiecesController.text,
            wastagePercentage: wastagePercentageController.text,
            cartonType: selectedCartonType.toString(),
            conversionRate: conversionRateController.text,
          ),
        ),
      );
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<ScaffoldState> stateKey = GlobalKey<ScaffoldState>();
  // Form Controllers
  TextEditingController roundController = TextEditingController();
  TextEditingController meterController = TextEditingController();
  TextEditingController damagePiecesController = TextEditingController();
  TextEditingController wastagePercentageController = TextEditingController();
  TextEditingController conversionRateController = TextEditingController();
  TextEditingController searchJumboController = TextEditingController();

  // Form Values
  String? gender;
  String? selectedCourse;
  String? selectedBatch;
  String? selectedSize;
  String? selectedCore;
  int _formClearCounter = 0; // Counter to force rebuild of MasterJumboRoll
  bool _isProcessingBarcode = false; // Track barcode processing state

  void clearForm() {
    roundController.clear();
    meterController.clear();
    damagePiecesController.clear();
    wastagePercentageController.clear();
    conversionRateController.clear();
    searchJumboController.clear();

    setState(() {
      selectedJumbo.clear();
      selectedJumboDetails.clear();
      selectedCartonType = null;
      selectedSize = null;
      selectedCore = null;
      selectedItems.clear();
      isSubmitPressed = false;
      _formClearCounter++; // Increment to force MasterJumboRoll rebuild
    });
    log('Form Cleared', name: 'Add Round');
  }

  // Form Validation Status
  bool isSubmitPressed = false;

  // Multi-select field variables
  List<String> selectedItems = [];

  Widget get wastagePercentageField => Consumer(
    builder: (context, ref, child) {
      final setting = ref.watch(settingProvider);

      return setting.when(
        data: (data) {
          if (data.status == 1) {
            // Use post-frame callback to avoid setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (wastagePercentageController.text.isEmpty) {
                wastagePercentageController.text = data
                    .record!
                    .first
                    .wastagePercentage
                    .toString();
              }
            });
          }
          return data.status != 1
              ? Center(child: Text(data.message.toString()))
              : buildFormField('Wastage Percentage', [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ], wastagePercentageController);
        },
        error: (error, stackTrace) => SizedBox.shrink(),
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
      );
    },
  );

  Widget get buildScannedBarcodeAddField => Container(
    margin: EdgeInsets.symmetric(
      vertical: Responsive.kVRTPadding,
      horizontal: Responsive.kHZPadding - 20,
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF2D8FCF).withOpacity(0.08),
          const Color(0xFF1A5A8E).withOpacity(0.08),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFF2D8FCF).withOpacity(0.15),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF2D8FCF).withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        // Header Section
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D8FCF).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.qr_code_2,
                  color: Color(0xFF2D8FCF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan Barcodes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A3A52),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add product barcodes to this round',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Scanned Barcodes Display
        if (scannedBarcodes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${scannedBarcodes.length} Barcode${scannedBarcodes.length > 1 ? 's' : ''} Added',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF2D8FCF),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                scannedBarcodeDisplayBox,
                const SizedBox(height: 20),
              ],
            ),
          ),

        // Input and Button Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Modern Input Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: addScannedBarcodeController.text.isNotEmpty
                        ? const Color(0xFF2D8FCF)
                        : const Color(0xFFE5E7EB),
                    width: 1.5,
                  ),
                  boxShadow: addScannedBarcodeController.text.isNotEmpty
                      ? [
                          BoxShadow(
                            color: const Color(0xFF2D8FCF).withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: TextFormField(
                  controller: addScannedBarcodeController,
                  focusNode: _barcodeFocusNode,
                  onChanged: (value) {
                    // Auto-submit when hardware scanner sends newline character
                    if (value.endsWith('\n')) {
                      addScannedBarcodeController.text = value
                          .replaceAll('\n', '')
                          .trim();
                      addScannedBarcodeController.selection =
                          TextSelection.fromPosition(
                            TextPosition(
                              offset: addScannedBarcodeController.text.length,
                            ),
                          );
                      _addBarcodeWithIsolate();
                    } else {
                      setState(() {}); // Rebuild for border/icon animation
                    }
                  },
                  onFieldSubmitted: (_) {
                    _addBarcodeWithIsolate();
                    // Re-request focus immediately since onFieldSubmitted removes it
                    _barcodeFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    hintText: 'Scan or enter barcode...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.barcode_reader,
                        color: addScannedBarcodeController.text.isNotEmpty
                            ? const Color(0xFF2D8FCF)
                            : const Color(0xFFD1D5DB),
                        size: 20,
                      ),
                    ),
                    suffixIcon: addScannedBarcodeController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                addScannedBarcodeController.clear();
                              });
                              _barcodeFocusNode.requestFocus();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.close_outlined,
                                color: const Color(0xFF2D8FCF).withOpacity(0.5),
                                size: 20,
                              ),
                            ),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2D8FCF),
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Modern Button with Animation
              Row(
                children: [
                  Expanded(child: SizedBox()),

                  // Expanded(child: SizedBox()),
                  Expanded(child: _buildModernAddButton()),
                  Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    ),
  );

  /// Build modern add button with loading animation
  Widget _buildModernAddButton() {
    return BlocListener(
      bloc: _roundBloc,
      listener: (context, state) {
        if (state is FetchJumboInformationsLoadedSuccessStatus) {
          final record = state.model.record;
          if (state.model.status != 1) {
            setState(() {
              _isProcessingBarcode = false;
              addScannedBarcodeController.clear();
              scannedBarcodes.removeLast();
            });
            ToastService.instance.showError(
              context,
              state.model.message.toString(),
            );
            return;
          } else {
            setState(() {
              selectedJumbo.add(record!.rKey.toString());
              selectedJumboDetails.add(record.rKey.toString());
              _isProcessingBarcode = false;
            });
            log(
              name: 'Scanned Barcode Added into List',
              selectedJumbo.map((rKeys) => rKeys).toList().toString(),
            );

            log(
              name: 'Scanned Barcodes List',
              scannedBarcodes.isEmpty
                  ? '(empty)'
                  : scannedBarcodes
                        .asMap()
                        .entries
                        .map((e) => '[${e.key}] ${e.value}')
                        .join('\n'),
            );
          }
        } else if (state is FetchJumboInformationsErrorFailedStatus) {
          setState(() {
            _isProcessingBarcode = false;
          });
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _isProcessingBarcode
              ? null
              : () => _addBarcodeWithIsolate(),
          style: ElevatedButton.styleFrom(
            backgroundColor: kButtonColor,
            disabledBackgroundColor: const Color(0xFFBFDBFE),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            elevation: _isProcessingBarcode ? 2 : 4,
            shadowColor: const Color(0xFF2D8FCF).withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isProcessingBarcode
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.9),
                        ),
                        strokeWidth: 2.5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Processing Barcode...',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle_outline, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Add Barcode',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _addBarcodeWithIsolate() async {
    // Prevent double-submission (onChanged + onFieldSubmitted both fire on Enter)
    if (_isProcessingBarcode) return;

    if (addScannedBarcodeController.text.trim().isEmpty) {
      _barcodeFocusNode.requestFocus();
      return;
    }

    try {
      setState(() => _isProcessingBarcode = true);

      // Use Isolate.run for one-time barcode processing
      final result = await SimpleBarcodeProcessor.processBarcode(
        BarcodeProcessingData(
          barcode: addScannedBarcodeController.text,
          existingBarcodes: scannedBarcodes,
        ),
      );

      if (!mounted) return;

      if (result.success) {
        setState(() {
          scannedBarcodes = result.updatedBarcodes;
          _isProcessingBarcode = false;
        });

        // Clear and re-focus after frame to prevent Flutter from restoring old value
        WidgetsBinding.instance.addPostFrameCallback((_) {
          addScannedBarcodeController.clear();
          _barcodeFocusNode.requestFocus();
        });

        _roundBloc.add(
          FetchJumboInformationsEvent(
            jumboID: addScannedBarcodeController.text.trim(),
          ),
        );

        // Show success message
        ToastService.instance.showSuccess(context, result.message);

        log(
          'Barcode added successfully: ${result.processedBarcode}',
          name: 'BarcodeIsolate',
        );
      } else {
        setState(() => _isProcessingBarcode = false);

        // Re-focus barcode field even on error
        _barcodeFocusNode.requestFocus();

        // Show error message
        ToastService.instance.showError(context, result.message);

        log(
          'Barcode processing failed: ${result.message}',
          name: 'BarcodeIsolate',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessingBarcode = false);
        _barcodeFocusNode.requestFocus();
        log('Error processing barcode: $e', name: 'BarcodeIsolate', error: e);
      }
    }
  }

  Widget get conversionRateField => Consumer(
    builder: (context, ref, child) {
      final setting = ref.watch(settingProvider);

      return setting.when(
        data: (data) {
          if (data.status == 1) {
            // Use post-frame callback to avoid setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (conversionRateController.text.isEmpty) {
                conversionRateController.text = data
                    .record!
                    .first
                    .conversionRate
                    .toString();
              }
            });
          }
          return data.status != 1
              ? Center(child: Text(data.message.toString()))
              : buildFormField('Conversion Rate', [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ], conversionRateController);
        },
        error: (error, stackTrace) => SizedBox.shrink(),
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
      );
    },
  );

  Widget get middleRowDesktopWidget => Row(
    spacing: 16,
    children: [
      Expanded(
        // flex: 2,
        child: MasterCartonTypeDropDown(
          selectCartonType: selectedCartonType,
          onChanged: (val) => setState(() => selectedCartonType = val),
        ),
      ),
      Expanded(
        child: buildFormField('Damage Pieces', [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ], damagePiecesController),
      ),
      Expanded(child: wastagePercentageField),
    ],
  );

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEF2F5), width: 1),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: "Inter",
                color: Color(0xFF3D475C),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Add these variables in the state class
  final Color tfColor = Colors.white;
  final primaryColor = const Color(0xFF2D8FCF);

  // Sample data for jumbo rolls

  List<MJumboRollRecord> selectedJumboRolls = [];

  List<String> selectedJumbo = []; // Keys for API submission
  List<String> selectedJumboDetails = []; // Display names/details
  List<String> scannedBarcodes = [];

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
    roundController.clear();
    meterController.clear();

    setState(() {
      gender = null;
      selectedCourse = null;
      selectedBatch = null;
      isSubmitPressed = false;
      selectedItems.clear();
      selectedJumbo.clear();
      selectedJumboDetails.clear();
      searchJumboController.clear();
    });
  }

  //! Display Box for Selected Jumbo Rolls
  Widget get selectedJumboDisplayBox => Container(
    padding: const EdgeInsets.all(12),
    decoration: selectedJumboDetails.isEmpty
        ? null
        : BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
    child: selectedJumboDetails.isEmpty
        ? SizedBox.shrink()
        : Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              selectedJumboDetails.length,
              (index) => Chip(
                label: Text(
                  selectedJumboDetails[index],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: const Color(0xFF2D8FCF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white,
                ),
                onDeleted: () {
                  setState(() {
                    selectedJumbo.removeAt(index);
                    selectedJumboDetails.removeAt(index);
                  });
                },
              ),
            ),
          ),
  );

  Widget get scannedBarcodeDisplayBox => scannedBarcodes.isEmpty
      ? SizedBox.shrink()
      : Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2D8FCF).withOpacity(0.06),
            border: Border.all(
              color: const Color(0xFF2D8FCF).withOpacity(0.2),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              scannedBarcodes.length,
              (index) => _buildModernBarcodeChip(scannedBarcodes[index], index),
            ),
          ),
        );

  /// Build modern barcode chip with better design
  Widget _buildModernBarcodeChip(String barcode, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D8FCF).withOpacity(0.9),
            const Color(0xFF1A5A8E).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D8FCF).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              barcode,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                scannedBarcodes.removeAt(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  //! Desktop View for Round Information

  Widget get roundInfoDesktop => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 1200),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
            vertical: kDefaultVerticalPadding,
          ),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Selected Jumbo Display Box
              selectedJumboDisplayBox,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // flex: 2,
                    child: MasterJumboRoll(
                      key: ValueKey(
                        _formClearCounter,
                      ), // Force rebuild on form clear
                      filter: '1',
                      selectedJumbo: selectedJumbo,
                      onChanged: (values) {
                        log(name: 'Roll Key', values.toString());
                        setState(() {
                          selectedJumbo = values;
                          // Extract display details from search controller text
                          final searchText = searchJumboController.text;
                          log(name: 'Controller Text', searchText);
                          if (searchText.isNotEmpty &&
                              searchText.contains('\n')) {
                            selectedJumboDetails = searchText.split('\n');
                          } else if (searchText.isNotEmpty) {
                            selectedJumboDetails = [searchText];
                          } else {
                            selectedJumboDetails = [];
                          }
                          log(name: 'Details', selectedJumboDetails.toString());
                        });
                      },
                      controller: searchJumboController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MasterRoleSizeSelector(
                      selectedRole: selectedSize,
                      onChanged: (String? value) {
                        setState(() {
                          selectedSize = value;
                        });
                      },
                      isFilter: false,
                    ),
                  ),
                  const SizedBox(width: 16),
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
                ],
              ),
              const SizedBox(height: 16),
              middleRowDesktopWidget,
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: conversionRateField),
                  const SizedBox(width: 16),
                  Expanded(child: buildFormField('Round', [], roundController)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildFormField('Tape Length', [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ], meterController),
                  ),
                  // Expanded(child: const SizedBox()),
                ],
              ),

              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [SizedBox(width: 200, child: addRoundButton())],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget addRoundButton() => BlocConsumer<RoundBloc, RoundState>(
    bloc: _roundBloc,
    listener: (context, state) {
      if (state is AddRoundLoadedSuccessStatus) {
        if (state.successResponse.status == 1) {
          // Clear form and rebuild UI
          clearForm();
          ToastService.instance.showSuccess(
            context,
            state.successResponse.message.toString(),
          );
          // Navigate after a brief delay to ensure UI rebuild
          Future.delayed(const Duration(milliseconds: 500), () {
            context.pushNamed(ViewRoundPanel.routeName);
          });
        } else {
          ToastService.instance.showError(
            context,
            state.successResponse.message ?? 'try again later',
          );
        }
      }
    },
    builder: (context, state) {
      if (state is RoundLoadingStatus) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      return CustomButton(label: 'Submit', onPressed: formSubmit);
    },
  );

  //! Tablet view for Round Information

  Widget get roundTabletView => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: kDefaultVerticalPadding,
    ),
    child: Column(
      spacing: 20,
      children: [
        // const SizedBox(height: 20),
        UploadFileButton(),
        Row(
          spacing: 16,
          children: [
            Expanded(
              // flex: 2,
              child: MasterJumboRoll(
                key: ValueKey(_formClearCounter), // Force rebuild on form clear
                selectedJumbo: selectedJumbo,
                onChanged: (values) {
                  log(name: 'Roll Key', values.toString());
                  setState(() {
                    selectedJumbo = values;
                    // Extract display details from search controller text
                    final searchText = searchJumboController.text;
                    log(name: 'Controller Text', searchText);
                    if (searchText.isNotEmpty && searchText.contains('\n')) {
                      selectedJumboDetails = searchText.split('\n');
                    } else if (searchText.isNotEmpty) {
                      selectedJumboDetails = [searchText];
                    } else {
                      selectedJumboDetails = [];
                    }
                    log(name: 'Details', selectedJumboDetails.toString());
                  });
                },
                controller: searchJumboController,
              ),
            ),

            Expanded(
              // flex: 1,
              child: MasterRoleSizeSelector(
                selectedRole: selectedSize,
                isFilter: false,
                onChanged: (val) => setState(() => selectedSize = val),
              ),
            ),
          ],
        ),

        Row(
          spacing: 16,
          children: [
            // const SizedBox(width: 16),
            Expanded(
              child: CoreDropdown(
                selectedCore: selectedCore,
                onChanged: (val) => setState(() => selectedCore = val),
              ),
            ),
            Expanded(
              child: buildFormField('Damage Pieces', [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ], damagePiecesController),
            ),
          ],
        ),

        Row(
          spacing: 16,
          children: [
            Expanded(child: wastagePercentageField),

            Expanded(child: conversionRateField),
          ],
        ),

        Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(width: 16),
            Expanded(child: buildFormField('Round', [], roundController)),
            Expanded(
              child: buildFormField('Tape Length', [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ], meterController),
            ),
            // Expanded(child: const SizedBox()),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [SizedBox(width: 200, child: addRoundButton())],
        ),
      ],
    ),
  );

  Widget buildFormSection(List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 1),
          ...fields
              .expand(
                (field) => [
                  Expanded(flex: 14, child: field),
                  const Spacer(flex: 1),
                ],
              )
              .toList(),
          // const Spacer(flex: 1),
        ],
      ),
    );
  }

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
      spacing: 10,
      children: [
        TextFieldlabelText(label),
        Container(
          // margin: const EdgeInsets.only(top: 10),
          height: 68,
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
                    'dd-MM-yyyy',
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

  Widget buildDropdownField(
    String label,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText(label),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            hint: Text('$label'),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF2D8FCF),
            ),
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
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

  @override
  void dispose() {
    _barcodeFocusNode.dispose();
    addScannedBarcodeController.dispose();
    super.dispose();
  }
}

// class MasterCartonType {}
