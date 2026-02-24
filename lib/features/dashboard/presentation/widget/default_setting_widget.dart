import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/custom_textfield.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';

class DefaultSettingWidget extends StatefulWidget {
  DefaultSettingWidget({super.key});

  @override
  State<DefaultSettingWidget> createState() => _DefaultSettingWidgetState();
}

class _DefaultSettingWidgetState extends State<DefaultSettingWidget> {
  final _formKey = GlobalKey<FormState>();
  late final GlobalBloc _globalBloc;
  final TextEditingController conversionRateController =
      TextEditingController();
  final TextEditingController wastagePercentageController =
      TextEditingController();
  final TextEditingController amountPerKGController = TextEditingController();
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
    _globalBloc.add(FetchUserSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      listener: (context, state) {
        if (state is UpdateDefaultSettingSuccessStatus) {
          if (state.model.status == 1) {
            ToastService.instance.showSuccess(
              context,
              state.model.message.toString(),
            );
          } else {
            ToastService.instance.showError(
              context,
              state.model.message.toString(),
            );
          }
        } else if (state is UpdateDefaultSettingErrorStatus) {
          ToastService.instance.showError(context, state.message.toString());
        } else if (state is FetchUserSettingsErrorStatus) {
          ToastService.instance.showError(context, state.message.toString());
        }
        if (state is FetchUserSettingsErrorStatus) {
          ToastService.instance.showError(context, state.message.toString());
        }
      },
      bloc: _globalBloc,
      builder: (context, state) {
        if (state is GlobalLoadingStatus) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FetchUserSettingsSuccessStatus) {
          final data = state.model;
          if (data.status == 1 && !_isDataLoaded) {
            amountPerKGController.text = data.record!.first.amountPerKG
                .toString();
            conversionRateController.text = data.record!.first.conversionRate
                .toString();
            wastagePercentageController.text = data
                .record!
                .first
                .wastagePercentage
                .toString();
            _isDataLoaded = true;
          }

          return data.status != 1
              ? Center(child: Text(data.message.toString()))
              : _buildForm();
        }

        if (state is FetchUserSettingsErrorStatus) {
          return Center(child: Text(state.message.toString()));
        }

        // Keep the form visible during update success/error states so the
        // whole widget doesn't disappear while the bloc emits update states.
        if (state is UpdateDefaultSettingSuccessStatus ||
            state is UpdateDefaultSettingErrorStatus) {
          return _buildForm();
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildForm() {
    return Container(
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
          children: [
            Text(
              'Default Settings',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Configure default values for inventory calculations',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              spacing: 24,
              children: [
                Expanded(
                  child: _buildSettingField(
                    label: 'Amount Per KG',
                    controller: amountPerKGController,
                    icon: Icons.currency_rupee,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount Per KG is required';
                      }
                      final numValue = double.tryParse(value);
                      if (numValue == null || numValue <= 0) {
                        return 'Amount Per KG must be a positive number';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: _buildSettingField(
                    label: 'Wastage Percentage',
                    controller: wastagePercentageController,
                    icon: Icons.percent,
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Wastage Percentage is required';
                      }
                      final numValue = double.tryParse(p0);
                      if (numValue == null || numValue < 0 || numValue > 100) {
                        return 'Wastage Percentage must be between 0 and 100';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: _buildSettingField(
                    label: 'Conversion Rate',
                    controller: conversionRateController,
                    icon: Icons.trending_up,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Conversion Rate is required';
                      }
                      final numValue = double.tryParse(value);
                      if (numValue == null || numValue <= 0) {
                        return 'Conversion Rate must be a positive number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              spacing: 20,
              children: [
                Expanded(child: SizedBox()),
                Expanded(child: SizedBox()),
                Expanded(child: SizedBox()),
                Expanded(
                  child: BlocConsumer(
                    bloc: _globalBloc,
                    listener: (context, state) {
                      if (state is UpdateDefaultSettingSuccessStatus) {
                        if (state.model.status == 1) {
                          ToastService.instance.showSuccess(
                            context,
                            state.model.message ?? 'retry',
                          );
                          // Refresh the settings provider to reload updated values
                          _isDataLoaded = false;
                          _globalBloc.add(FetchUserSettingsEvent());
                        } else {
                          ToastService.instance.showError(
                            context,
                            state.model.message ?? 'retry',
                          );
                        }
                      } else if (state is UpdateDefaultSettingErrorStatus) {
                        ToastService.instance.showError(
                          context,
                          state.message.toString(),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is GlobalLoadingStatus) {
                        return Center(child: const CircularProgressIndicator());
                      }
                      return CustomButton(
                        label: 'Submit',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _globalBloc.add(
                              UpdateDefaultSettingEvent(
                                conversionRate: conversionRateController.text,
                                wastagePercentage:
                                    wastagePercentageController.text,
                                amountPerKG: amountPerKGController.text,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
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
        CustomTextField(controller: controller, validator: validator),
      ],
    );
  }
}
