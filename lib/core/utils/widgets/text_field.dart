import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/dimens.dart';

Widget formTextField(
  TextEditingController? controller,
  String reg,
  String regReturn,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  String labelText, {
  TextInputAction? textInputAction,
  void Function(String)? onFieldSubmitted,
  String? Function(String?)? validator,
}) {
  double marginTop = 10.0;
  return Container(
    margin: EdgeInsets.only(top: marginTop),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: controller,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            validator:
                validator ??
                (value) {
                  if (reg == 'null') {
                    if (value?.trim() == '') {
                      return "Please enter $labelText.";
                    }
                  } else {
                    if (regReturn.isEmpty) {
                      return null;
                    } else {
                      if (value!.isEmpty) {
                        return "Please enter $labelText.";
                      } else if (!RegExp(reg).hasMatch(value)) {
                        return regReturn;
                      } else {
                        return null;
                      }
                    }
                  }
                  return null;
                },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9499A1)),
                borderRadius: BorderRadius.circular(5),
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget formTextFieldCP(
  TextEditingController? controller,
  String reg,

  String regReturn,
  String? message,

  TextInputType keyboardType,

  List<TextInputFormatter>? inputFormatters,

  String labelText,
) {
  double marginTop = 10.0;
  return Container(
    margin: EdgeInsets.only(top: marginTop),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: controller,
            inputFormatters: inputFormatters,
            validator: (value) {
              if (reg == 'null') {
                if (value?.trim() == '') {
                  return message;
                }
              } else {
                if (regReturn.isEmpty) {
                  return null;
                } else {
                  if (value!.isEmpty) {
                    return message;
                  } else if (!RegExp(reg).hasMatch(value)) {
                    return regReturn;
                  } else {
                    return null;
                  }
                }
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9499A1)),
                borderRadius: BorderRadius.circular(5),
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget formTextFieldMobile(
  TextEditingController? controller,
  String reg,
  String regReturn,
  TextInputType keyboardType,
  List<TextInputFormatter>? inputFormatters,
  String labelText, {
  TextInputAction? textInputAction,
  void Function(String)? onFieldSubmitted,
}) {
  double marginTop = 10.0;
  return Container(
    margin: EdgeInsets.only(top: marginTop),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: controller,
            inputFormatters: inputFormatters,
            validator: (value) {
              if (reg == 'null') {
                if (value?.trim() == '') {
                  return "Please enter $labelText.";
                }
              } else {
                if (regReturn.isEmpty) {
                  return null;
                } else {
                  if (value!.isEmpty) {
                    return "Please enter $labelText.";
                  } else if (!RegExp(reg).hasMatch(value)) {
                    return regReturn;
                  } else {
                    return null;
                  }
                }
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9499A1)),
                borderRadius: BorderRadius.circular(5),
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget formTextField2(
  TextEditingController? controller,
  List<TextInputFormatter>? inputFormatters,
  String reg,
  String regReturn,
  TextInputType keyboardType,
  FormFieldValidator? validator,
  String labelText,
) {
  double marginTop = 10.0;
  return Container(
    margin: EdgeInsets.only(top: marginTop),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9499A1)),
                borderRadius: BorderRadius.circular(5),
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget TextFieldlabelText(String label) {
  return Text(
    label,
    //semanticsLabel: "*",
    // textAlign: TextAlign.center,
    style: TextStyle(
      // fontFamily: AppFonts.textFieldLabelFont,
      color: ColourPalette.textFieldLabelColor,
      fontSize: Dimens.textFieldLabelFontSize,
    ),
  );
}

Widget TextFieldlabelText2(String label) {
  return Text(
    label,
    //semanticsLabel: "*",
    // textAlign: TextAlign.center,
    style: TextStyle(
      // fontFamily: AppFonts.textFieldLabelFont,
      color: Colors.white,
      fontSize: Dimens.textFieldLabelFontSize,
    ),
  );
}

/*Widget OptionalTextFieldlabelText(String label) {
  return Text(
    label,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: AppFonts.textFieldLabelFont,
      color: ColourPalette.textFieldLabelColor,
      fontSize: Dimens.textFieldLabelFontSize,
    ),
  );
}*/

Widget DetailInfoText(String label) {
  return Text(
    label,
    textAlign: TextAlign.center,
    style: TextStyle(
      // fontFamily: AppFonts.detailFont,
      color: ColourPalette.detailColor,
      fontSize: Dimens.detailSize,
    ),
  );
}

Widget DetailInfoText2(String label) {
  return Text(
    label,
    textAlign: TextAlign.center,
    style: TextStyle(
      // fontFamily: AppFonts.textFieldLabelFont,
      color: ColourPalette.detailinfoColor,
      fontSize: Dimens.detailinfoSize,
    ),
  );
}

Widget DetailInfoTable(String label) {
  return Text(
    label,
    textAlign: TextAlign.center,
    style: TextStyle(
      // fontFamily: AppFonts.textFieldLabelFont,
      color: ColourPalette.detailinfoColor,
      fontSize: Dimens.detailinfotableSize,
      height: 2,
    ),
  );
}

Widget DetailTableContent(String label) {
  return Text(
    label,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: "MontseeratRegular",
      color: Color(0xFF3D475C),
      fontSize: 12.0,
      height: 3,
    ),
  );
}
// Widget formTextField(String text, String name, TextInputType textInputType, String s) {
//   return TextFormField(
//     textAlign: TextAlign.start,
//     decoration: InputDecoration(
//       isDense: true,
//       contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//       //hintText: "Select Department",
//     ),
//   );
// }

Widget pageHeadingText(String text, {Color? color}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'Inter',
      color: ColourPalette.pageHandlingColor,
      fontSize: Dimens.pageHeadingSize,
    ),
  );
}

// Widget pageHeadingStyle(String text,{Color? color}) {
//   return Text(
//     text,
//     style: TextStyle(
//         fontFamily: 'Inter',
//         color: ColourPalette.pageHandlingColor,
//         fontSize: Dimens.pageHeadingSize
//     ),
//   );
// }

// Widget signUpheadingText(String text) {
//   return Text(
//     text,
//     style: SignInPagesHeading(),
//   );
// }
