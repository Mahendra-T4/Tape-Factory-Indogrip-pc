import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/domain/repositories/global_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';

class UpdateDefaultSettingButton extends StatefulWidget {
  const UpdateDefaultSettingButton({
    super.key,
    required this.conversionRateController,
    required this.wastagePercentageController,
    required this.amountPerKGController,
  });
  final TextEditingController conversionRateController;
  final TextEditingController wastagePercentageController;
  final TextEditingController amountPerKGController;

  @override
  State<UpdateDefaultSettingButton> createState() =>
      _UpdateDefaultSettingButtonState();
}

class _UpdateDefaultSettingButtonState
    extends State<UpdateDefaultSettingButton> {
  late final GlobalBloc _globalBloc;

  @override
  void initState() {
    super.initState();
    _globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _globalBloc,
      listener: (context, state) {
        if (state is UpdateDefaultSettingSuccessStatus) {
          if (state.model.status == 1) {
            ToastService.instance.showSuccess(
              context,
              state.model.message ?? 'retry',
            );
          } else {
            ToastService.instance.showError(
              context,
              state.model.message ?? 'retry',
            );
          }
        } else if (state is UpdateDefaultSettingErrorStatus) {
          ToastService.instance.showError(context, state.message.toString());
        }
      },
      builder: (context, state) {
        if (state is GlobalLoadingStatus) {
          return Center(child: const CircularProgressIndicator());
        }
        return CustomButton(
          label: 'Submit',
          onPressed: () {
            _globalBloc.add(
              UpdateDefaultSettingEvent(
                conversionRate: widget.conversionRateController.text,
                wastagePercentage: widget.wastagePercentageController.text,
                amountPerKG: widget.amountPerKGController.text,
              ),
            );
          },
        );
      },
    );
  }
}
