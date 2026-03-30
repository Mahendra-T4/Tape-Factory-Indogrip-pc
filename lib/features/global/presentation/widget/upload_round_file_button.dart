import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/service/file_picker.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/global/presentation/widget/vendor_list_widget.dart';
import 'package:indogrip/features/outsource/data/model/upload_file_param.dart';
import 'package:indogrip/features/round/presentation/pages/round-miss-record/round_miss_record_panel.dart';
import 'package:intl/intl.dart';

class UploadRoundFileButton extends StatefulWidget {
  const UploadRoundFileButton({super.key});

  @override
  State<UploadRoundFileButton> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<UploadRoundFileButton> {
  late final GlobalBloc _globalBloc;
  final TextEditingController controller = TextEditingController();
  final List<TextInputFormatter>? inputFormatters = null;
  final TextEditingController billNoController = TextEditingController();
  String? selectedVendor;
  File? csvFile;

  @override
  void initState() {
    super.initState();
    _globalBloc = GlobalBloc(globalRepository: GlobalManagerRepository());
  }

  Widget get vendorListWidget => VendorListWidget(
    value: selectedVendor,
    onChanged: (vendor) {
      setState(() {
        selectedVendor = vendor;
      });
    },
  );

  Widget _buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText('Bill Number'),
        const SizedBox(height: 8),
        TextFormField(
          controller: billNoController,
          maxLines: 1,
          // onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter Bill Number' : null,
        ),
      ],
    );
  }

  Widget _buildDateField(label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText('Bill Date'),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(date);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please select date' : null,
        ),
      ],
    );
  }

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
    content: SingleChildScrollView(
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sure you want to Upload this File?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          vendorListWidget,
          // const SizedBox(height: 16),
          _buildDateField('Bill Date'),
          _buildTextField(),
        ],
      ),
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
          uploadButton,
        ],
      ),
    ],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: Colors.white,
  );

  Widget get uploadButton => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: 15,
    ),
    child: BlocConsumer(
      bloc: _globalBloc,
      listener: (context, state) {
        if (state is GlobalRoundRecordUploadCsvFileSuccessStatus) {
          if (state.successResponse.status == 1) {
            if (!context.mounted) return;
            ToastService.instance.showSuccess(
              context,
              state.successResponse.message.toString(),
            );
            context.pop();
          } else {
            if (!context.mounted) return;
            ToastService.instance.showError(
              context,
              state.successResponse.message.toString(),
            );
          }
          if (state.successResponse.missRecord != null) {
            GoRouter.of(context).pushNamed(
              RoundMissRecordPanel.routeName,
              extra: state.successResponse,
            );
            context.pop();
          }
        } else if (state is GlobalRoundRecordUploadCsvFileErrorStatus) {
          if (!context.mounted) return;
          ToastService.instance.showError(context, state.message.toString());
        }
      },
      builder: (context, state) {
        if (state is GlobalLoadingStatus) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return TextButton(
          onPressed: () {
            if (csvFile != null) {
              _globalBloc.add(
                GlobalRoundRecordUploadCsvFileEvent(
                  param: UploadFileParam(
                    activity: '',
                    productType: '',
                    rType: '1',
                    billNumber: billNoController.text,
                    date: controller.text,
                    selectedVendor: selectedVendor ?? '',
                    csvFile: csvFile!,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: 15,
      ),
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
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (context) => customAlertBoxWidget(),
            );
          } else {
            ToastService.instance.showError(
              context,
              'Failed to pick or access the file.',
            );
          }
        },
      ),
    );
  }
}
