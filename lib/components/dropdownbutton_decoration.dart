import 'package:flutter/material.dart';
import 'package:flutter_easytasks/utils/apptheme.dart';

/// Decoração do DropdownButtonFormField.
InputDecoration getDropdownDecoration(String label) {
  return InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppTheme.primaryColor, width: 4),
    ),
  );
}
