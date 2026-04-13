import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/core/constants/sizes.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/wastage/data/model/add_wastage_param.dart';
import 'package:indogrip/features/wastage/domain/repositories/add_wastage_main_repo.dart';
import 'package:indogrip/features/wastage/presentation/bloc/wastage_bloc.dart';

import 'package:indogrip/features/wastage/presentation/pages/add/add_wastage.dart';
import 'package:indogrip/features/wastage/presentation/pages/view/view_wastage.dart';
import 'package:indogrip/features/wastage/presentation/widgets/client_list_dropdown.dart';
import 'package:indogrip/features/wastage/presentation/widgets/wastage_fields.dart';
import 'package:intl/intl.dart';

abstract class AddWastageBuilder extends State<AddWastagePanel> {
  late WastageBloc wastageBloc;

  final TextEditingController billNoController = TextEditingController();
  final TextEditingController weigtController = TextEditingController();
  final TextEditingController priceKGController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TextEditingController totalPriceController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  String? totalPrice;

  @override
  void initState() {
    super.initState();
    wastageBloc = WastageBloc(addWastageRepository: AddWastageRepository());
    totalPriceCal();
  }

  formSubmit() {
    if (formKey.currentState!.validate()) {
      wastageBloc.add(
        AddWastageONRecordEvent(
          addWastageParam: AddWastageParam(
            billNumber: billNoController.text,
            price_kg: priceKGController.text,
            remark: remarkController.text,
            wastageClient: clientName.toString(),
            wastageDate: dateController.text,
            width: weigtController.text,
          ),
        ),
      );
    }
  }

  totalPriceCal() {
    setState(() {
      totalPrice =
          weigtController.text.isNotEmpty && priceKGController.text.isNotEmpty
          ? (double.parse(weigtController.text) *
                    double.parse(priceKGController.text))
                .toStringAsFixed(2)
          : '0.00';
    });
  }

  final GlobalKey<ScaffoldState> stateKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers for form fields

  String? clientName;
  String? selectedKG;
  String? clientKey;

  List<String> clientList = [
    'Client A',
    'Client B',
    'Client C',
    'Client D',
    'Client E',
  ];

  // Helper method for form fields
  Widget formTextField(
    String pattern,
    String errorText,
    String? Function(String?)? validator,
    TextInputType keyboardType, {
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          // hintText: hintText,
        ),
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }

  @override
  void dispose() {
    billNoController.dispose();
    weigtController.dispose();
    priceKGController.dispose();
    totalPriceController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  Widget get wastageHeaderDesktop => Column(
    spacing: 20,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextFieldlabelText(
                  //     "Company Name*"),
                  ClientsListDropdown(
                    label: 'Select Client',

                    value: clientKey,
                    onChanged: (val) {
                      setState(() {
                        clientName = val;
                        clientKey = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextFieldlabelText("Remar"),
                  buildDateField('Date', dateController),
                ],
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldlabelText("Bill No."),
                  formTextFieldDigit(
                    isReadOnly: false,
                    '[a-zA-Z ]+',
                    "Enter Bill No.",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill bill number fields';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(10),
                    ],

                    TextInputType.number,
                    controller: billNoController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldlabelText("Weight"),
                  formTextFieldDigit2(
                    isReadOnly: false,

                    '[0-9]{10}',
                    "Enter Weight",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill weight fields';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(10),
                    ],

                    (value) {
                      if (value.isNotEmpty) {
                        totalPriceCal();
                      }
                    },
                    TextInputType.number,

                    controller: weigtController,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldlabelText("Price / KG"),
                  formTextFieldDigit2(
                    isReadOnly: false,
                    '[0-9]{10}',
                    "Enter Price Per KG",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter price per kg';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    (value) {
                      if (value.isNotEmpty) {
                        totalPriceCal();
                      }
                    },

                    TextInputType.number,

                    controller: priceKGController,
                  ),
                ],
              ),
            ),
            Expanded(
              // flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldlabelText("Remark"),
                  formTextField(
                    '[0-9]{10}',
                    "Enter Remark",
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a remark';
                      }
                      return null;
                    },
                    TextInputType.number,

                    controller: remarkController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );

  //! tablet

  Widget get wastageHeaderTablet => Column(
    spacing: 15,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextFieldlabelText("Remar"),
                  buildDateField('Date', dateController),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextFieldlabelText(
                  //     "Company Name*"),
                  ClientsListDropdown(
                    label: 'Select Client',

                    value: clientKey,
                    onChanged: (val) {
                      clientKey = val;
                      setState(() => clientName = val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldlabelText("Bill No."),
                  formTextFieldDigit(
                    isReadOnly: false,
                    '[a-zA-Z ]+',
                    "Enter Bill No.",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill bill number fields';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(10),
                    ],

                    TextInputType.name,
                    controller: billNoController,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldlabelText("Weight"),
                  formTextFieldDigit(
                    isReadOnly: false,
                    '[0-9]{10}',
                    "Enter Weight",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill weight fields';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(10),
                    ],
                    TextInputType.number,

                    controller: weigtController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: 10,
        ),
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldlabelText("Price / KG"),
                  formTextFieldDigit2(
                    isReadOnly: false,
                    '[0-9]{10}',
                    "Enter Price Per KG",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter price per kg';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    (value) {
                      if (value.isNotEmpty) {
                        totalPriceCal();
                      }
                    },

                    TextInputType.number,

                    controller: priceKGController,
                  ),
                ],
              ),
            ),
            Expanded(
              // flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldlabelText("Remark"),
                  formTextField(
                    '[0-9]{10}',
                    "Enter Remark",
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a remark';
                      }
                      return null;
                    },
                    TextInputType.number,

                    controller: remarkController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget get submitButton => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: 30,
    ),
    child: Row(
      children: [
        if (Responsive.isDesktop(context)) Expanded(child: SizedBox()),
        Expanded(child: SizedBox()),
        Expanded(child: SizedBox()),
        BlocConsumer(
          bloc: wastageBloc,
          listener: (context, state) {
            if (state is AddWastageONRecordsSuccessStatus) {
              if (state.successResponse.status == 1) {
                context.pushNamed(ViewWastagePanel.routeName);
                ToastService.instance.showSuccess(
                  context,
                  state.successResponse.message.toString(),
                );
              } else {
                ToastService.instance.showError(
                  context,
                  state.successResponse.message ?? 'try again later',
                );
              }
            } else if (state is AddWastageONRecordsFailureStatus) {
              ToastService.instance.showError(
                context,
                state.message.toString(),
              );
            }
          },
          builder: (context, state) {
            if (state is WastageLoadingStatus) {
              return Center(child: CircularProgressIndicator());
            }
            return Expanded(
              child: SizedBox(
                child: CustomButton(label: 'Submit', onPressed: formSubmit),
              ),
            );
          },
        ),
      ],
    ),
  );

  Widget emptyBox(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldlabelText(label),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF9499A1)),
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[50],
          ),
          child: Text(
            '0.00',
            style: TextStyle(color: Color(0xFF9499A1), fontSize: 12),
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
            hint: Text(label),
            style: const TextStyle(color: Colors.black, fontSize: 15),
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
}
