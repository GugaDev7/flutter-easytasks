import 'package:flutter/material.dart';

/// Diálogo de confirmação genérico para ações críticas
class ConfirmationDialog {
  /// Exibe um diálogo com título, mensagem e botões personalizáveis
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
              // Botão de cancelamento
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text(cancelText)),
              // Botão de confirmação
              TextButton(onPressed: () => Navigator.pop(context, true), child: Text(confirmText)),
            ],
          ),
    );
  }
}
