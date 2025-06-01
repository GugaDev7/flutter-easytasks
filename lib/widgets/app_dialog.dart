import 'package:flutter/material.dart';
import 'package:flutter_easytasks/components/textformfield_decoration.dart';
import 'package:flutter_easytasks/components/dropdownbutton_decoration.dart';
import 'package:flutter_easytasks/utils/apptheme.dart';

/// Classe com os diálogos padrão do app
class AppDialog {
  /// Diálogo de confirmação simples (sim/não)
  static Future<bool?> showConfirmation({
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
            title: Text(title, style: TextStyle(color: AppTheme.primaryColor)),
            content: Text(content),
            actions: [
              // Botão de cancelar
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  cancelText,
                  style: TextStyle(color: AppTheme.dialogBtn),
                ),
              ),
              // Botão de confirmar
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  confirmText,
                  style: TextStyle(color: AppTheme.dialogBtn),
                ),
              ),
            ],
            backgroundColor: Colors.white,
          ),
    );
  }

  /// Diálogo com campo de texto para editar
  static Future<String?> showEditText({
    required BuildContext context,
    required String title,
    String initialValue = '',
    String labelText = 'Editar',
    String confirmText = 'Salvar',
    String cancelText = 'Cancelar',
    String? Function(String?)? validator,
  }) async {
    // Controla o texto digitado
    final controller = TextEditingController(text: initialValue);
    // Chave para validar o formulário
    final formKey = GlobalKey<FormState>();
    String value = initialValue;

    return await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title, style: TextStyle(color: AppTheme.primaryColor)),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                autofocus: true,
                decoration: getTextfieldDecoration(labelText),
                validator: validator,
                onChanged: (v) => value = v,
              ),
            ),
            actions: [
              // Botão de cancelar
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  cancelText,
                  style: TextStyle(color: AppTheme.dialogBtn),
                ),
              ),
              // Botão de salvar
              TextButton(
                onPressed: () {
                  // Só salva se passar na validação
                  if (formKey.currentState?.validate() ?? true) {
                    Navigator.pop(context, value.trim());
                  }
                },
                child: Text(
                  confirmText,
                  style: TextStyle(color: AppTheme.dialogBtn),
                ),
              ),
            ],
            backgroundColor: Colors.white,
          ),
    );
  }

  /// Diálogo para criar/editar tarefa
  static Future<Map<String, String>?> showTaskDialog({
    required BuildContext context,
    required String title,
    String initialTitle = '',
    String initialPriority = 'Sem Prioridade',
    String confirmText = 'Salvar',
    String cancelText = 'Cancelar',
  }) async {
    // Controla o título da tarefa
    final titleController = TextEditingController(text: initialTitle);
    // Guarda a prioridade selecionada
    String priority = initialPriority;
    // Chave para validar o formulário
    final formKey = GlobalKey<FormState>();

    return await showDialog<Map<String, String>>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title, style: TextStyle(color: AppTheme.primaryColor)),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo de título
                  TextFormField(
                    controller: titleController,
                    decoration: getTextfieldDecoration('Título da Tarefa'),
                    validator:
                        (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Campo obrigatório'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  // Dropdown de prioridade
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: priority,
                    items:
                        ['Sem Prioridade', 'Baixa', 'Média', 'Alta']
                            .map(
                              (p) => DropdownMenuItem(
                                value: p,
                                child: Text(
                                  p,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (v) => priority = v ?? 'Sem Prioridade',
                    decoration: getDropdownDecoration('Prioridade'),
                  ),
                ],
              ),
            ),
            actions: [
              // Botão de cancelar
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  cancelText,
                  style: TextStyle(color: AppTheme.dialogBtn),
                ),
              ),
              // Botão de salvar
              TextButton(
                onPressed: () {
                  // Só salva se passar na validação
                  if (formKey.currentState?.validate() ?? true) {
                    Navigator.pop(context, {
                      'title': titleController.text.trim(),
                      'priority': priority,
                    });
                  }
                },
                child: Text(
                  confirmText,
                  style: TextStyle(color: AppTheme.dialogBtn),
                ),
              ),
            ],
            backgroundColor: Colors.white,
          ),
    );
  }

  /// Diálogo para pedir email de redefinição de senha
  static Future<String?> showResetPasswordDialog({
    required BuildContext context,
    String title = 'Redefinir senha',
    String labelText = 'Digite seu e-mail',
    String confirmText = 'Enviar',
    String cancelText = 'Cancelar',
  }) async {
    // Controla o email digitado
    final controller = TextEditingController();
    // Chave para validar o formulário
    final formKey = GlobalKey<FormState>();

    return await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title, style: TextStyle(color: AppTheme.primaryColor)),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                decoration: getTextfieldDecoration(labelText),
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  // Valida o formato do email
                  final email = value?.trim() ?? '';
                  final emailRegex = RegExp(
                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                  );
                  if (email.isEmpty) {
                    return 'Digite um e-mail.';
                  }
                  if (!emailRegex.hasMatch(email)) {
                    return 'Digite um e-mail válido.';
                  }
                  return null;
                },
              ),
            ),
            actions: [
              // Botão de cancelar
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  cancelText,
                  style: TextStyle(color: AppTheme.dialogBtn),
                ),
              ),
              // Botão de enviar
              TextButton(
                onPressed: () {
                  // Só envia se passar na validação
                  if (formKey.currentState?.validate() ?? false) {
                    Navigator.pop(context, controller.text.trim());
                  }
                },
                child: Text(
                  confirmText,
                  style: TextStyle(color: AppTheme.dialogBtn),
                ),
              ),
            ],
            backgroundColor: Colors.white,
          ),
    );
  }
}
