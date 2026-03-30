import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/service/file_picker.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/client/presentation/bloc/client_bloc.dart';
import 'package:indogrip/features/client/presentation/pages/client-miss-record/client_miss_record_panel.dart';
// removed unused imports

class UploadClientFileButton extends StatefulWidget {
  UploadClientFileButton({super.key, this.csvFile, this.activity});
  final File? csvFile;
  final String? activity;

  @override
  State<UploadClientFileButton> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<UploadClientFileButton> {
  late final ClientBloc _clientBloc;
  File? _csvFile;
  @override
  void initState() {
    super.initState();
    _clientBloc = ClientBloc();
    _csvFile = widget.csvFile;
  }

  Widget customAlertBoxWidget() => AlertDialog(
    titlePadding: EdgeInsets.zero,
    title: Container(
      width: 550,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ],
      ),
    ),
    content: Text('Sure you want to Upload this File?'),
    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
    actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
    actions: [
      Row(
        children: [
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
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
      bloc: _clientBloc,
      listener: (context, state) {
        if (state is UploadClientCSVFileSuccessStatus) {
          if (state.successResponse.status == 1) {
            if (!context.mounted) return;
            ToastService.instance.showSuccess(
              context,
              state.successResponse.message.toString(),
            );
          } else {
            if (!context.mounted) return;
            ToastService.instance.showError(
              context,
              state.successResponse.message.toString(),
            );

            if (state.successResponse.missRecord != null) {
              context.pushNamed(
                ClientMissRecordPanel.routeName,
                extra: state.successResponse,
              );
              context.pop();
            }
          }
        } else if (state is UploadClientCSVFileFailureStatus) {
          if (!context.mounted) return;
          ToastService.instance.showError(
            context,
            state.errorMessage.toString(),
          );
        }
      },
      builder: (context, state) {
        if (state is ClientLoadingStatus) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return TextButton(
          onPressed: () {
            if (_csvFile != null) {
              _clientBloc.add(
                UploadClientCSVFileEvent(
                  activity: widget.activity.toString(),
                  csvFile: _csvFile!,
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
        color: _csvFile != null ? Colors.blue : null,
        label: _csvFile != null ? 'Uploaded' : 'Upload File',
        onPressed: () async {
          if (!mounted) return;
          final File? pickedFile = await FilePickerService.pickFileFromDevice(
            _csvFile,
          );
          if (pickedFile != null) {
            setState(() {
              _csvFile = pickedFile;
            });
          }
          if (_csvFile != null) {
            showDialog(
              context: context,
              builder: (context) => customAlertBoxWidget(),
            );
          }
        },
      ),
    );
  }
}
