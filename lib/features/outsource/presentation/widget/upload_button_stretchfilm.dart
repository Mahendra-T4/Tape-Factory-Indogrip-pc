import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/file_picker.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/outsource/data/model/upload_file_param.dart';
import 'package:indogrip/features/outsource/presentation/state/bloc.in/inventory_bloc.dart';
import 'package:indogrip/features/outsource/presentation/widget/master_product_type_model.dart';

class UploadFileButtonIn extends StatefulWidget {
  UploadFileButtonIn({
    super.key,
    this.csvFile,
    required this.productType,
    this.onChanged,
  });
  File? csvFile;
  final String productType;
  final void Function(String?)? onChanged;

  @override
  State<UploadFileButtonIn> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<UploadFileButtonIn> {
  late final InventoryBloc inventoryBloc;
  // track selected product type locally so dialog can update immediately
  late String selectedProductType;

  @override
  void initState() {
    super.initState();
    inventoryBloc = InventoryBloc();
    selectedProductType = widget.productType;
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
    content: StatefulBuilder(
      builder: (context, dialogSetState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            selectedProductType.trim().isEmpty
                ? const Text('Please Select Procuct Type')
                : const Text('Sure you want to Upload this File?'),
            MasterProductTypeWidget(
              value: selectedProductType.toString(),
              onChanged: (val) {
                dialogSetState(() {
                  selectedProductType = val ?? '';
                });
                // notify parent if callback provided
                if (widget.onChanged != null) widget.onChanged!(val);
              },
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
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Close'),
          ),
          selectedProductType.trim().isEmpty ? SizedBox.shrink() : uploadButton,
        ],
      ),
    ],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: Colors.white,
  );

  Widget customAlertButtonBoxWidget() => AlertDialog(
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
    content: Column(children: [Text('Sure you want to Upload this File?')]),
    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
    actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
    actions: [
      Row(
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Close'),
          ),
          // widget.productType == '' ? SizedBox.shrink() : uploadButton,
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
      bloc: inventoryBloc,
      listener: (context, state) {
        if (state is InventoryInUploadCSVFileSuccessStatus) {
          // if (state.response.missRecord != null &&
          //     state.response.missRecord!.isNotEmpty) {

          // }
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
              state.response.message ?? 'try again later',
            );
          }
        } else if (state is InventoryInUploadCSVFileFailedErrorStatus) {
          if (!context.mounted) return;
          ToastService.instance.showError(context, state.message.toString());
        } else if (state is InventoryInStretchUploadCSVFileSuccessStatus) {
          if (state.response.status == 1) {
            //    if (state.response.missRecord != null &&
            //     state.response.missRecord!.isNotEmpty) {

            // }
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
        } else if (state is InventoryInStretchUploadCSVFileFailedErrorStatus) {
          if (!context.mounted) return;
          ToastService.instance.showError(context, state.message.toString());
        }
      },
      builder: (context, state) {
        if (state is InventoryLoadingStatus) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return TextButton(
          onPressed: () {
            if (widget.csvFile != null) {
              widget.productType == '1'
                  ? inventoryBloc.add(
                      AddInventoryUploadCSVFileEvent(
                        param: UploadFileParam(
                          activity: '',
                          productType: selectedProductType.toString(),
                          csvFile: widget.csvFile!,
                        ),
                      ),
                    )
                  : inventoryBloc.add(
                      AddInventoryStretchUploadCSVFileEvent(
                        param: UploadFileParam(
                          activity: '',
                          productType: selectedProductType.toString(),
                          csvFile: widget.csvFile!,
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
      child: Row(
        children: [
          if (Responsive.isDesktop(context)) Expanded(child: SizedBox()),
          Expanded(child: SizedBox()),
          Expanded(child: SizedBox()),
          Expanded(
            child: CustomButton(
              color: widget.csvFile != null ? Colors.blue : null,

              label: widget.csvFile != null ? 'Uploaded' : 'Upload File',
              onPressed: () async {
                if (!mounted) return;
                final File? pickedFile =
                    await FilePickerService.pickFileFromDevice(widget.csvFile);
                if (pickedFile != null) {
                  setState(() {
                    widget.csvFile = pickedFile;
                  });
                }
                if (widget.csvFile != null) {
                  showDialog(
                    context: context,
                    builder: (context) => customAlertBoxWidget(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
