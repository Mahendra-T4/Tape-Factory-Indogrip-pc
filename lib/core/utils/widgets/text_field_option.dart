import 'package:flutter/material.dart';

Widget formTextFieldOptional(
  TextEditingController controller,
  String reg, String regReturn,
    TextInputType keyboardType, String labelText) {
  double marginTop = 10.0;
  return Container(
    margin: EdgeInsets.only(top: marginTop),
    child: TextFormField(
      controller: controller,
      // validator: (value) {
      //   if(reg=='null') {
      //     if (value?.trim() == '') {
      //       return "Please enter Staff's $labelText.";
      //     }
      //   }else{
      //     if(regReturn.isEmpty) {
      //       return null;
      //     }else{
      //       if(value!.isEmpty) {
      //         return "Please enter Staff's $labelText.";
      //       }else if(!RegExp(reg).hasMatch(value)) {
      //         return regReturn;
      //       }else{
      //         return null;
      //       }
      //     }
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF9499A1)),
            borderRadius: BorderRadius.circular(5)),
        isDense: true,
      ),
    ),
  );
}
