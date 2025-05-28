import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> registerUser({required String name, required String password, required String email}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "Usuário já cadastrado!";
      }

      return "Erro desconhecido";
    }
  }

  Future<String?> loginUser({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
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

  /// Método para resetar a senha do usuário.
  Future<String?> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
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

  /// Método para fazer logout do usuário.
  Future<void> logout() {
    return _firebaseAuth.signOut();
  }
}
