import 'package:firebase_auth/firebase_auth.dart';

// Classe que cuida de toda a autenticação com Firebase
class AuthService {
  // Instância do Firebase Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Registra um novo usuário com email e senha
  Future<String?> registerUser({
    required String name,
    required String password,
    required String email,
  }) async {
    try {
      // Cria o usuário no Firebase
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Atualiza o nome de exibição do usuário
      await userCredential.user!.updateDisplayName(name);
      return null; // Retorna null se deu tudo certo
    } on FirebaseAuthException catch (e) {
      // Trata os erros específicos do Firebase
      if (e.code == "email-already-in-use") {
        return "Usuário já cadastrado!";
      }

      return "Erro desconhecido";
    }
  }

  // Faz login com email e senha
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Tenta fazer login no Firebase
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Retorna null se deu tudo certo
    } on FirebaseAuthException catch (e) {
      // Trata os diferentes tipos de erro que podem acontecer
      switch (e.code) {
        case 'invalid-credential':
          return 'Credenciais inválidas. Verifique o e-mail e a senha.';
        case 'user-not-found':
          return 'Usuário não encontrado. Verifique o e-mail.';
        case 'wrong-password':
          return 'Senha incorreta. Tente novamente.';
        case 'invalid-email':
          return 'E-mail inválido.';
        case 'user-disabled':
          return 'Usuário desativado.';
        default:
          return 'Erro ao fazer login. Tente novamente.';
      }
    } catch (e) {
      return 'Erro inesperado. Tente novamente.';
    }
  }

  // Envia email para resetar a senha
  Future<String?> resetPassword({required String email}) async {
    try {
      // Pede pro Firebase enviar o email
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return null; // Retorna null se deu tudo certo
    } on FirebaseAuthException catch (e) {
      // Trata os erros específicos
      switch (e.code) {
        case 'user-not-found':
          return 'E-mail não cadastrado.';
        case 'invalid-email':
          return 'E-mail inválido.';
        default:
          return 'Erro ao enviar e-mail de redefinição.';
      }
    } catch (e) {
      return 'Erro inesperado. Tente novamente.';
    }
  }

  // Faz logout do usuário atual
  Future<void> logout() {
    return _firebaseAuth.signOut();
  }
}
