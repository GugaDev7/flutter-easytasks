import 'package:flutter/material.dart';

class SnackbarUtils {
  /// Exibe uma mensagem de erro ou sucesso usando um SnackBar.
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }

  /// Exibe uma mensagem de sucesso usando um SnackBar.
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text(message)));
  }
}
