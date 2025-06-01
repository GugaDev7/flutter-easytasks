import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easytasks/components/textformfield_decoration.dart';
import 'package:flutter_easytasks/screens/home/home_screen.dart';
import 'package:flutter_easytasks/screens/load_screen.dart';
import 'package:flutter_easytasks/services/auth_service.dart';
import 'package:flutter_easytasks/utils/apptheme.dart';
import 'package:flutter_easytasks/utils/snackbar_utils.dart';
import 'package:flutter_easytasks/widgets/app_dialog.dart';
import 'package:flutter/foundation.dart';

/// Tela de autenticação do usuário, que permite login e cadastro.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  /// Variável que controla se o usuário está entrando ou se cadastrando.
  bool entry = true;

  /// Chave do formulário para validação.
  final _formkey = GlobalKey<FormState>();

  /// Controladores de texto para os campos do formulário.
  final TextEditingController _emailController = TextEditingController();

  /// Controlador de texto para o campo de senha.
  final TextEditingController _passwordController = TextEditingController();

  /// Controlador de texto para o campo de confirmação de senha.
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  /// Controlador de texto para o campo de nome completo.
  final TextEditingController _nameController = TextEditingController();

  /// Instância do serviço de autenticação.
  final AuthService _authService = AuthService();

  /// Método que é chamado quando o botão de autenticação é pressionado.
  void authButton() async {
    String name = _nameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;

    if (_formkey.currentState!.validate()) {
      // Exibe o loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LoadScreen(),
      );

      String? erro;
      if (entry) {
        erro = await _authService.loginUser(email: email, password: password);
      } else {
        erro = await _authService.registerUser(
          name: name,
          password: password,
          email: email,
        );
      }

      // Fecha o loading
      Navigator.of(context, rootNavigator: true).pop();

      if (erro != null) {
        SnackbarUtils.showError(context, erro);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(context)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppTheme.secondaryColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: AppTheme.secondaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: null,
      backgroundColor: AppTheme.secondaryColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(
                    child: Container(
                      constraints:
                          kIsWeb
                              ? const BoxConstraints(maxWidth: 400)
                              : const BoxConstraints(), // Limita largura só na web
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 60),
                          Image.asset(
                            "assets/icons/icon_nobg2.png",
                            height: 200,
                          ),
                          const SizedBox(height: 20),
                          Visibility(
                            visible: !entry,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: getTextfieldDecoration(
                                "Nome de Exibição",
                              ),
                              validator: (String? value) {
                                if (value == null) {
                                  return "O nome não pode ser vazio";
                                }
                                if (value.length < 4) {
                                  return "O nome é muito curto";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            decoration: getTextfieldDecoration("E-mail"),
                            validator: (String? value) {
                              if (value == null) {
                                return "O e-mail não pode ser vazio";
                              }
                              if (value.length < 5) {
                                return "O e-mail é muito curto";
                              }

                              /// Validação simples de e-mail usando regex.
                              final emailRegex = RegExp(
                                r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return "O e-mail não é válido";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            decoration: getTextfieldDecoration("Senha"),
                            validator: (String? value) {
                              if (value == null) {
                                return "A senha não pode ser vazia";
                              }
                              if (value.length < 5) {
                                return "A senha é muito curta";
                              }
                              return null;
                            },
                            obscureText: true,
                          ),
                          const SizedBox(height: 8),
                          Visibility(
                            visible: !entry,
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              decoration: getTextfieldDecoration(
                                "Confirme a Senha",
                              ),
                              validator: (String? value) {
                                if (value == null) {
                                  return "A confirmação da senha não pode ser vazia";
                                }
                                if (value != _passwordController.text) {
                                  return "As senhas não coincidem";
                                }
                                return null;
                              },
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              authButton();
                            },
                            child: Text((entry) ? "Entrar" : "Cadastrar"),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                entry = !entry;
                              });
                              if (entry) {
                                _nameController.clear();
                                _passwordController.clear();
                                _confirmPasswordController.clear();
                                _emailController.clear();
                              } else {
                                _passwordController.clear();
                              }
                            },
                            child: Text(
                              (entry) ? "Cadastre-se" : "Fazer Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          /// Se o usuário estiver na tela de login, exibe o botão para redefinir a senha.
                          if (entry)
                            /// Exibe o botão de redefinição de senha.
                            TextButton(
                              onPressed: () async {
                                final email =
                                    await AppDialog.showResetPasswordDialog(
                                      context: context,
                                    );

                                /// Se o usuário forneceu um e-mail, tenta redefinir a senha.
                                if (email != null && email.isNotEmpty) {
                                  final result = await _authService
                                      .resetPassword(email: email);

                                  /// Se o resultado for nulo, significa que o e-mail foi enviado com sucesso.
                                  /// Caso contrário, exibe uma mensagem de erro.
                                  if (result == null) {
                                    SnackbarUtils.showSuccess(
                                      context,
                                      'E-mail de redefinição enviado!',
                                    );
                                  } else {
                                    SnackbarUtils.showError(context, result);
                                  }
                                }
                              },
                              child: const Text(
                                "Esqueci minha senha",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
