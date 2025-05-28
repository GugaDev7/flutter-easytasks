import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easytasks/components/textformfield_decoration.dart';
import 'package:flutter_easytasks/screens/home/home_screen.dart';
import 'package:flutter_easytasks/services/auth_service.dart';
import 'package:flutter_easytasks/utils/apptheme.dart';
import 'package:flutter_easytasks/utils/snackbar_utils.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();

  /// Controlador de texto para o campo de nome completo.
  final TextEditingController _nameController = TextEditingController();

  /// Instância do serviço de autenticação.
  final AuthService _authService = AuthService();

  /// Método que é chamado quando o botão de autenticação é pressionado.
  void authButton() {
    String name = _nameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;

    if (_formkey.currentState!.validate()) {
      if (entry) {
        _authService.loginUser(email: email, password: password).then((String? erro) {
          if (erro != null) {
            SnackbarUtils.showError(context, erro);
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(context)));
          }
        });
      } else {
        _authService.registerUser(name: name, password: password, email: email).then((String? erro) {
          if (erro != null) {
            SnackbarUtils.showError(context, erro);
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(context)));
          }
        });
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
                child: Padding(padding: EdgeInsets.only(top: 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      Image.asset("assets/icons/icon_nobg2.png", height: 200),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: !entry,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: getTextfieldDecoration("Nome Completo"),
                          validator: (String? value) {
                            if (value == null) {
                              return "O nome não pode ser vazio";
                            }
                            if (value.length < 5) {
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
                          if (!value.contains("@")) {
                            return "O e-mail não é valido";
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
                          decoration: getTextfieldDecoration("Confirme a Senha"),
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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
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
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
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
