import 'package:flutter/material.dart';

class ConfirmationDialog {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) async {
    return await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text(cancelText)),
              TextButton(onPressed: () => Navigator.pop(context, true), child: Text(confirmText)),
            ],
          ),
    );
  }
}
