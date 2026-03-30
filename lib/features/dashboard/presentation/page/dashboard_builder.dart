import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/custom_textfield.dart';
import 'package:indogrip/core/utils/widgets/cutom_tf_extra.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/dashboard/data/model/predict_cal_param.dart';
import 'package:indogrip/features/dashboard/data/model/show_static_model.dart';
import 'package:indogrip/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:indogrip/features/dashboard/presentation/page/deshboard.dart';
import 'package:indogrip/features/dashboard/presentation/widget/base_dasboard_widget.dart';
import 'package:indogrip/features/dashboard/presentation/widget/dashboard_kpi_card.dart';
import 'package:indogrip/features/dashboard/presentation/widget/dashboard_section_header.dart';
import 'package:indogrip/features/dashboard/presentation/widget/filmsize_dashboard_widget.dart';
import 'package:indogrip/features/dashboard/presentation/widget/master_carton_type_db.dart';
import 'package:indogrip/features/dashboard/presentation/widget/master_core_db_widget.dart';
import 'package:indogrip/features/dashboard/presentation/widget/master_cuttmmmeter_db_widget.dart';
import 'package:indogrip/features/dashboard/presentation/widget/micron_dashboard.dart';
import 'package:indogrip/features/dashboard/presentation/widget/width_db_widget.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/refresh_button.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/pages/widgets/micron_dropdown_widget.dart';
import 'package:indogrip/features/outsource/presentation/widget/master_product_type_model.dart';
import 'package:indogrip/features/round/domain/repositories/add_round_repo.dart';
import 'package:indogrip/features/round/presentation/bloc/round_bloc.dart';
import 'package:indogrip/features/round/presentation/widgets/master_roll_size_widget.dart';

enum whatToShow { micron, ratePerSqrtMeter }

abstract class DashboardBuilder extends State<IndoGripDashboard> {
  late final HomeBloc homeBloc;
  late final GlobalBloc _globalBloc;
  whatToShow showWhat = whatToShow.ratePerSqrtMeter;
  String? selectedProduct;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController amountPerKg = TextEditingController();
  final TextEditingController wastagePercentage = TextEditingController();
  final TextEditingController conversionRate = TextEditingController();
  final TextEditingController wastagePercentage2 = TextEditingController();
  final TextEditingController amountPerKg2 = TextEditingController();
  final TextEditingController conversionRate2 = TextEditingController();
  TextEditingController tapeLengthController = TextEditingController();
  TextEditingController ratePerSquareMeterController = TextEditingController();
  // TextEditingController  wastagePercentage = TextEditingController();
  // TextEditingController  conversionRate = TextEditingController();
  TextEditingController marginController = TextEditingController();
  String? selectedRoundSize;
  ShowStaticModel? dashboardData;
  String? selectedMic;
  String? micLabel;
  String? roundSizeLabel;
  String? cutMMMeterLabel;
  late final RoundBloc _roundBloc;
  late final JumboRollBloc _jumboRollBloc;
  dynamic ratePerSqrtMeter;
  dynamic wastagePrt;
  dynamic conversionRt;

  bool isMic = false;

  @override
  void initState() {
    homeBloc = HomeBloc();
    _globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    homeBloc.add(FetchDashboardStaticsEvent());
    _roundBloc = RoundBloc(addRoundRepository: AddRoundRepository());
    _jumboRollBloc = JumboRollBloc();

    // Fetch default settings to populate form fields
    _globalBloc.add(FetchUserSettingsEvent());
    buildDefaultSettingInit();
    super.initState();
  }

  void clearControllers() {
    _roundBloc.add(FetchMasterRollSizeEvent());
    _jumboRollBloc.add(LoadMasterJumboMicronEvent());
    amountPerKg.clear();

    amountPerKg2.clear();

    tapeLengthController.clear();
    ratePerSquareMeterController.clear();
    marginController.clear();
  }

  Widget buildDefaultSettingInit() => BlocBuilder(
    bloc: _globalBloc,
    builder: (context, state) {
      if (state is GlobalLoadingStatus) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is FetchUserSettingsSuccessStatus) {
        final data = state.model;
        // amountPerKg.text = data.toString();
        wastagePercentage2.text = data.record!.first.wastagePercentage
            .toString();
        conversionRate2.text = data.record!.first.conversionRate.toString();
        // marginController.text = data.margin.toString();
        return SizedBox();
      }

      if (state is FetchUserSettingsErrorStatus) {
        return Center(child: Text(state.message.toString()));
      }

      // Keep the form visible during update success/error states so the
      // whole widget doesn't disappear while the bloc emits update states.
      if (state is UpdateDefaultSettingSuccessStatus ||
          state is UpdateDefaultSettingErrorStatus) {
        return SizedBox();
      }

      return const SizedBox.shrink();
    },
  );

  double? widgetHeight;

  Widget buildJumboRollStatics({
    required int? totalRolls,
    required int? thisMonth,
    required int? inStock,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF3498DB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.assignment_rounded,
                  color: Color(0xFF3498DB),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Jumbo Roll',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          buildStatRow('Total Rolls', totalRolls?.toString() ?? '0'),
          SizedBox(height: 12),
          buildStatRow('This Month', thisMonth?.toString() ?? '0'),
          SizedBox(height: 12),
          buildStatRow('In Stock', inStock?.toString() ?? '0'),
        ],
      ),
    );
  }

  Widget buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF7F8C8D),
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF3498DB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBatchInfoStatics({
    required int? totalBatch,
    required int? thisMonth,
    required int? inStock,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF27AE60).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.batch_prediction_rounded,
                  color: Color(0xFF27AE60),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Batch Info',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          buildStatRow('Total Batch', totalBatch?.toString() ?? '0'),
          SizedBox(height: 12),
          buildStatRow('This Month', thisMonth?.toString() ?? '0'),
          SizedBox(height: 12),
          buildStatRow('In Stock', inStock?.toString() ?? '0'),
        ],
      ),
    );
  }

  Widget buildCartonStatics({
    required int? small,
    required int? medium,
    required int? large,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFE74C3C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  color: Color(0xFFE74C3C),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Carton Stock',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          buildCoreTypeRow(
            'Small',
            small?.toString() ?? '0',
            Color(0xFFF1C40F),
          ),
          SizedBox(height: 12),
          buildCoreTypeRow(
            'Medium',
            medium?.toString() ?? '0',
            Color(0xFFE67E22),
          ),
          SizedBox(height: 12),
          buildCoreTypeRow(
            'Large',
            large?.toString() ?? '0',
            Color(0xFFE74C3C),
          ),
        ],
      ),
    );
  }

  Widget
  get buildPredictCalculationFormWidget => BlocListener<GlobalBloc, GlobalState>(
    bloc: _globalBloc,
    listener: (context, state) {
      if (state is FetchUserSettingsSuccessStatus) {
        // Auto-populate form fields with default settings
        final data = state.model;
        if (data.record != null && data.record!.isNotEmpty) {
          wastagePercentage2.text = data.record!.first.wastagePercentage
              .toString();
          conversionRate2.text = data.record!.first.conversionRate.toString();
        }
      }
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              'Predict Calculation using Rate Per Square Meter',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                letterSpacing: -0.5,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.kHZRowPadding,
              ),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: MasterRoleSizeSelector(
                      selectedRole: selectedRoundSize,
                      onLabelChanged: (label) =>
                          setState(() => cutMMMeterLabel = label),
                      onChanged: (String? value) {
                        setState(() {
                          selectedRoundSize = value;
                        });
                      },
                      isValidate: false,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        CustomTextFieldExtra(
                          controller: tapeLengthController,
                          labelText: 'Tape Length',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter tape length';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        CustomTextFieldExtra(
                          controller: ratePerSquareMeterController,
                          labelText: 'Rate Per Square Meter',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter rate per square meter';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.kHZRowPadding,
              ),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: CustomTextFieldExtra(
                      controller: wastagePercentage2,
                      labelText: 'Wastage Percentage',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter wastage percentage';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) < 0 ||
                            double.parse(value) > 100) {
                          return 'Wastage percentage must be between 0 and 100';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextFieldExtra(
                      controller: conversionRate2,
                      labelText: 'Conversion Rate',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter conversion rate';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        // if (double.parse(value) < 0 ||
                        //     double.parse(value) > 100) {
                        //   return 'Conversion rate must be between 0 and 100';
                        // }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextFieldExtra(
                      controller: marginController,
                      labelText: 'Margin',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter margin';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) < 0 ||
                            double.parse(value) > 100) {
                          return 'Margin must be between 0 and 100';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.kHZRowPadding,
              ),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(child: SizedBox()),
                  Expanded(child: SizedBox()),
                  Expanded(child: SizedBox()),
                  Expanded(child: predictCalculationButton),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget
  get buildPredictCalculation2FormWidget => BlocListener<GlobalBloc, GlobalState>(
    bloc: _globalBloc,
    listener: (context, state) {
      if (state is FetchUserSettingsSuccessStatus) {
        // Auto-populate form fields with default settings
        final data = state.model;
        if (data.record != null && data.record!.isNotEmpty) {
          amountPerKg2.text = data.record!.first.amountPerKG.toString();
          wastagePercentage2.text = data.record!.first.wastagePercentage
              .toString();
          conversionRate2.text = data.record!.first.conversionRate.toString();
          // selectedMic = data.record!.first.micID;
          // selectedRoundSize = data.record!.first.;
          conversionRt = data.record!.first.conversionRate;
          wastagePrt = data.record!.first.wastagePercentage;
        }
      }
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              'Predict Calculation using Micron',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                letterSpacing: -0.5,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.kHZRowPadding,
              ),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: MicronDropdownWidget(
                      value: selectedMic,

                      onChanged: (val) => setState(() => selectedMic = val),
                      onLabelChanged: (label) =>
                          setState(() => micLabel = label),
                    ),
                  ),
                  Expanded(
                    child: MasterRoleSizeSelector(
                      selectedRole: selectedRoundSize,
                      onLabelChanged: (label) =>
                          setState(() => cutMMMeterLabel = label),
                      onChanged: (String? value) {
                        setState(() {
                          selectedRoundSize = value;
                        });
                      },
                      isValidate: false,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        CustomTextFieldExtra(
                          controller: tapeLengthController,
                          labelText: 'Tape Length',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter tape length';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.kHZRowPadding,
              ),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        CustomTextFieldExtra(
                          controller: amountPerKg2,
                          labelText: 'Amount Per KG',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount per kg';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CustomTextFieldExtra(
                      controller: wastagePercentage2,
                      labelText: 'Wastage Percentage',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter wastage percentage';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) < 0 ||
                            double.parse(value) > 100) {
                          return 'Wastage percentage must be between 0 and 100';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextFieldExtra(
                      controller: conversionRate2,
                      labelText: 'Conversion Rate',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter conversion rate';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        // if (double.parse(value) < 0 ||
                        //     double.parse(value) > 100) {
                        //   return 'Conversion rate must be between 0 and 100';
                        // }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.kHZRowPadding,
              ),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: CustomTextFieldExtra(
                      controller: marginController,
                      labelText: 'Margin',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter margin';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) < 0 ||
                            double.parse(value) > 100) {
                          return 'Margin must be between 0 and 100';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.kHZRowPadding,
              ),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(child: SizedBox()),
                  Expanded(child: SizedBox()),
                  Expanded(child: SizedBox()),
                  Expanded(child: predictCalculationByMicButton),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget get predictCalculationButton => BlocConsumer(
    bloc: homeBloc,
    listener: (context, state) {
      if (state is PredictCalculationSuccessStatus) {
        if (state.predictCalculationModel.status == 1) {
          ToastService.instance.showSuccess(
            context,
            state.predictCalculationModel.message.toString(),
          );
          setState(() {
            showWhat = whatToShow.ratePerSqrtMeter;
          });

          // open a dialog to display returned values
          showPredictResultDialog(
            context: context,
            cartonRate: state.predictCalculationModel.cartonRate,
            cartonWithMargin: state.predictCalculationModel.cartonWithMargin,
            piecesPerCarton: state.predictCalculationModel.perPieceRate,
          );
        } else {
          ToastService.instance.showError(
            context,
            state.predictCalculationModel.message.toString(),
          );
        }
      }
      if (state is PredictCalculationErrorStatus) {
        ToastService.instance.showError(context, state.message.toString());
      }
    },
    builder: (context, state) {
      if (state is HomeLoadingStatus) {
        return const Center(child: CircularProgressIndicator());
      }
      return CustomButton(
        label: 'Submit',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            homeBloc.add(
              PredictCalculationEvent(
                param: PredictCalParam(
                  rollSize: selectedRoundSize,
                  tapeLength: tapeLengthController.text,
                  ratePerSquareMeter: ratePerSquareMeterController.text,
                  wastagePercentage: wastagePercentage2.text,
                  conversionRate: conversionRate2.text,
                  margin: marginController.text,
                ),
              ),
            );
          }
        },
      );
    },
  );

  Widget get predictCalculationByMicButton => BlocConsumer(
    bloc: homeBloc,
    listener: (context, state) {
      if (state is PredictCalculationByMicSuccessStatus) {
        if (state.predictCalculationModel.status == 1) {
          ToastService.instance.showSuccess(
            context,
            state.predictCalculationModel.message.toString(),
          );

          setState(() {
            showWhat = whatToShow.micron;
          });

          // clearControllers();
          // open a dialog to display returned values
          showPredictResultDialog(
            context: context,
            cartonRate: state.predictCalculationModel.cartonRate,
            cartonWithMargin: state.predictCalculationModel.cartonWithMargin,
            piecesPerCarton: state.predictCalculationModel.perPieceRate,
          );
        } else {
          ToastService.instance.showError(
            context,
            state.predictCalculationModel.message.toString(),
          );
        }
      }
      if (state is PredictCalculationByMicErrorStatus) {
        ToastService.instance.showError(context, state.message.toString());
      }
    },
    builder: (context, state) {
      if (state is HomeLoadingStatus2) {
        return const Center(child: CircularProgressIndicator());
      }
      return CustomButton(
        label: 'Submit',
        onPressed: () {
          if (_formKey2.currentState!.validate()) {
            homeBloc.add(
              PredictCalculationByMicEvent(
                param: PredictCalParam(
                  micID: selectedMic,
                  tapeLength: tapeLengthController.text,
                  amountPerKG: amountPerKg2.text,
                  wastagePercentage: wastagePercentage2.text,
                  conversionRate: conversionRate2.text,
                  margin: marginController.text,
                  rollSize: selectedRoundSize,
                ),
              ),
            );
          }
        },
      );
    },
  );

  void showPredictResultDialog({
    required BuildContext context,
    required dynamic cartonRate,
    required dynamic cartonWithMargin,
    required dynamic piecesPerCarton,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 520,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Prediction Result',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.pop(context);
                        clearControllers();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.close, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CutMMMeter',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cutMMMeterLabel.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    showWhat == whatToShow.micron
                        ? Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Micron',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  micLabel.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rate Per Square Meter',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ratePerSquareMeterController.text.isEmpty
                                      ? '0'
                                      : ratePerSquareMeterController.text,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tape Length',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tapeLengthController.text,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wastage Percentage',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            wastagePrt?.toString() ?? wastagePercentage.text,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conversion Rate',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            conversionRt?.toString() ?? conversionRate.text,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Margin',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            marginController.text,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Carton Rate',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cartonRate?.toString() ?? '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Carton With Margin',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cartonWithMargin?.toString() ?? '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pieces Per Carton',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            piecesPerCarton?.toString() ?? '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pop(context);
                        clearControllers();
                      },
                      child: Text('Close'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.pop(context);
                        clearControllers();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFF3498DB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: Color(0xFF3498DB)),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomTextField(controller: controller),
      ],
    );
  }

  Widget stockManagementWidget(
    CartonStockInformation data,
    CoreStockInformation core,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Master',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C3E50),
        ),
      ),
      SizedBox(height: 20),
      Row(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: buildCartonStatics(
              small: data.small,
              medium: data.medium,
              large: data.large,
            ),
          ),
          Expanded(
            child: buildCoreStatics(
              regular: core.regular,
              heavy: core.heavy,
              extraHeavy: core.extraHeavy,
            ),
          ),
        ],
      ),
    ],
  );

  Widget buildSizeRow(String size, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 8),
            Text(
              size,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7F8C8D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCoreStatics({
    required int? regular,
    required int? heavy,
    required int? extraHeavy,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF16A085).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.donut_large_rounded,
                  color: Color(0xFF16A085),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Core Stock',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          buildCoreTypeRow(
            'Regular',
            regular?.toString() ?? '0',
            Color(0xFF1ABC9C),
          ),
          SizedBox(height: 12),
          buildCoreTypeRow(
            'Heavy',
            heavy?.toString() ?? '0',
            Color(0xFF16A085),
          ),
          SizedBox(height: 12),
          buildCoreTypeRow(
            'Extra Heavy',
            extraHeavy?.toString() ?? '0',
            Color(0xFF0E6655),
          ),
        ],
      ),
    );
  }

  Widget buildCoreTypeRow(String type, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF2C3E50),
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get productWidget => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      spacing: 35,
      children: [
        Expanded(
          child: MasterProductTypeWidget(
            value: selectedProduct,
            onChanged: (val) => setState(() => selectedProduct = val),
          ),
        ),
        // Expanded(child: SizedBox()),
        SizedBox(width: 210),
        Expanded(child: SizedBox()),
      ],
    ),
  );

  // Widget get refreshButton =>

  Widget get desktopWidgetWrapper => BlocBuilder(
    bloc: homeBloc,
    builder: (context, state) {
      if (state is HomeLoadingStatus) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is HomeDashboardStaticsSuccessStatus) {
        dashboardData = state.showStaticModel;
        final data = dashboardData!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // KPI Metrics Section
              // if (Responsive.isDesktop(context)) _buildKPIMetrics(data),
              // SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Configuration Section
              // defaultSettings,
              SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Stock Overview Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DashboardSectionHeader(
                  title: 'Stock Management',
                  subtitle: 'Real-time stock status across categories',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildInventoryOverview(data),
              ),
              SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Master Data Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DashboardSectionHeader(
                  title: 'Master Data Management',
                  subtitle: 'Manage and monitor all product configurations',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildMasterDataGrid(data),
              ),
              SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Analytics Section
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: DashboardSectionHeader(
              //     title: 'Detailed Analytics',
              //     subtitle: 'In-depth analysis of batch and micron information',
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: _buildAnalyticsSection(data),
              // ),
            ],
          ),
        );
      } else if (state is HomeDashboardStaticsErrorStatus) {
        return Center(
          child: RefreshButton(
            onPressed: () {
              homeBloc.add(FetchDashboardStaticsEvent());
            },
          ),
        );
      } else if (dashboardData != null) {
        final data = dashboardData!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // KPI Metrics Section
              // if (Responsive.isDesktop(context)) _buildKPIMetrics(data),
              // SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Configuration Section
              // defaultSettings,
              SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Stock Overview Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DashboardSectionHeader(
                  title: 'Stock Management',
                  subtitle: 'Real-time stock status across categories',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildInventoryOverview(data),
              ),
              SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Master Data Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DashboardSectionHeader(
                  title: 'Master Data Management',
                  subtitle: 'Manage and monitor all product configurations',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildMasterDataGrid(data),
              ),
              SizedBox(height: Responsive.isDesktop(context) ? 32 : 20),

              // Analytics Section
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: DashboardSectionHeader(
              //     title: 'Detailed Analytics',
              //     subtitle: 'In-depth analysis of batch and micron information',
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: _buildAnalyticsSection(data),
              // ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    },
  );

  Widget _buildKPIMetrics(ShowStaticModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardSectionHeader(
            title: 'Key Performance Indicators',
            subtitle: 'Monitor your business metrics at a glance',
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              DashboardKPICard(
                title: 'Total Jumbo Rolls',
                value: data.jumboInformation?.totalJumboRoll.toString() ?? '0',
                subtitle: 'In all categories',
                icon: Icons.assignment_rounded,
                accentColor: const Color(0xFF3498DB),
                trend: '+12%',
              ),
              DashboardKPICard(
                title: 'Total Batches',
                value: data.batchInformation?.totalBatch.toString() ?? '0',
                subtitle: 'This month',
                icon: Icons.batch_prediction_rounded,
                accentColor: const Color(0xFF27AE60),
                trend: '+8%',
              ),
              DashboardKPICard(
                title: 'In Stock Items',
                value:
                    ((data.cartonStockInformation?.small ?? 0) +
                            (data.cartonStockInformation?.medium ?? 0) +
                            (data.cartonStockInformation?.large ?? 0))
                        .toString(),
                subtitle: 'Carton stock',
                icon: Icons.inventory_2_rounded,
                accentColor: const Color(0xFFE67E22),
                trend: '-3%',
              ),
              DashboardKPICard(
                title: 'Core Stock',
                value:
                    ((data.coreStockInformation?.regular ?? 0) +
                            (data.coreStockInformation?.heavy ?? 0) +
                            (data.coreStockInformation?.extraHeavy ?? 0))
                        .toString(),
                subtitle: 'All types',
                icon: Icons.donut_large_rounded,
                accentColor: const Color(0xFF16A085),
                trend: '+5%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryOverview(ShowStaticModel data) {
    return Row(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildMasterDataCard(
            480,
            title: 'Carton Stock',
            icon: Icons.category,
            color: const Color(0xFF27AE60),
            child: MasterCartonTypeDropDownDB(),
          ),
        ),
        Expanded(
          child: _buildMasterDataCard(
            480,
            title: 'Core Stock',
            icon: Icons.center_focus_strong,
            color: const Color(0xFF27AE60),
            child: CoreDropdownDB(),
          ),
        ),
        Expanded(
          child: _buildMasterDataCard(
            480,
            title: 'Jumbo Width',
            icon: Icons.width_full,
            color: const Color(0xFF27AE60),
            child: WidthDropdownDBWidget(),
          ),
        ),

        // Flexible(child: CoreDropdownDB()),
      ],
    );
  }

  Widget _buildStockSummaryItem(String label, int value, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterDataGrid(ShowStaticModel data) {
    return Row(
      spacing: 20,
      children: [
        Expanded(
          child: _buildMasterDataCard(
            480,
            title: 'Roll Sizes',
            icon: Icons.aspect_ratio,
            color: const Color(0xFF3498DB),
            child: MasterRoleSizeDBSelector(),
          ),
        ),
        Expanded(
          child: _buildMasterDataCard(
            480,
            title: 'Micron Details',
            icon: Icons.category,
            color: const Color(0xFF27AE60),
            child: MicronDashboard(),
          ),
        ),
        Expanded(
          child: _buildMasterDataCard(
            480,
            title: 'Base Type',
            icon: Icons.donut_large_rounded,
            color: const Color(0xFF16A085),
            child: BaseDashboardWidget(),
          ),
        ),
        Expanded(
          child: _buildMasterDataCard(
            480,
            title: 'Film Sizes',
            icon: Icons.aspect_ratio,
            color: const Color(0xFFE67E22),
            child: MasterStretchFilmDashboardWidget(),
          ),
        ),
      ],
    );
  }

  Widget _buildMasterDataCard(
    double height, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 15),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(padding: const EdgeInsets.all(12), child: child),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(ShowStaticModel data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B59B6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Color(0xFF9B59B6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Micron Batch Analytics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: 450, child: MicronDashboard()),
        ],
      ),
    );
  }

  // Widget _buildMicronDetailsTable(ShowStaticModel data) {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(12),
  //         decoration: BoxDecoration(
  //           color: const Color(0xFF9B59B6).withOpacity(0.05),
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: Text(
  //                 'Micron',
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w600,
  //                   color: const Color(0xFF9B59B6),
  //                   letterSpacing: 0.5,
  //                 ),
  //               ),
  //             ),
  //             Expanded(
  //               child: Text(
  //                 'Tape',
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w600,
  //                   color: const Color(0xFF9B59B6),
  //                   letterSpacing: 0.5,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //             Expanded(
  //               child: Text(
  //                 'Stretch',
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w600,
  //                   color: const Color(0xFF9B59B6),
  //                   letterSpacing: 0.5,
  //                 ),
  //                 textAlign: TextAlign.end,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       ListView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemCount: data.micBatchInformation?.length ?? 0,
  //         itemBuilder: (context, index) {
  //           final item = data.micBatchInformation![index];
  //           return Container(
  //             margin: const EdgeInsets.only(bottom: 8),
  //             padding: const EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               color: index.isEven
  //                   ? const Color(0xFF9B59B6).withOpacity(0.03)
  //                   : Colors.transparent,
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(color: Colors.grey[200]!, width: 0.5),
  //             ),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: Text(
  //                     item.mic.toString(),
  //                     style: const TextStyle(
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w500,
  //                       color: Color(0xFF2C3E50),
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Text(
  //                     item.batch.toString(),
  //                     style: const TextStyle(
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w500,
  //                       color: Color(0xFF2C3E50),
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Text(
  //                     item.piece.toString(),
  //                     style: const TextStyle(
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w500,
  //                       color: Color(0xFF2C3E50),
  //                     ),
  //                     textAlign: TextAlign.end,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }
}
