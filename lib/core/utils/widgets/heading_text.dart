import 'dart:ui';

import 'package:flutter/material.dart';

Widget buildSectionTitle(String title) {
  return Container(
    padding: const EdgeInsets.only(top: 20, left: 20),

    child: Text(
      title,
      style: const TextStyle(
        fontFamily: "Inter",
        color: Color(0xFF3D475C),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
