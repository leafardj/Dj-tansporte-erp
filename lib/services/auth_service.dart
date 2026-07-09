import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Obter usuário atual
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream de autenticação
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Login com email e senha
  Future<UserCredential> login({
    required String email,
    required String senha,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Registrar novo usuário
  Future<UserCredential> register({
    required String email,
    required String senha,
    required String nome,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      // Atualizar nome do usuário
      await userCredential.user?.updateDisplayName(nome);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Fazer logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Resetar senha
  Future<void> resetarSenha(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Atualizar email
  Future<void> atualizarEmail(String novoEmail) async {
    try {
      await _firebaseAuth.currentUser?.updateEmail(novoEmail.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Atualizar senha
  Future<void> atualizarSenha(String novaSenha) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(novaSenha);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Verificar se email está verificado
  bool isEmailVerified() {
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  // Enviar email de verificação
  Future<void> enviarEmailVerificacao() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Tratar erros de autenticação
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado. Verifique o e-mail.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-disabled':
        return 'Usuário desativado.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      case 'weak-password':
        return 'Senha muito fraca. Use pelo menos 6 caracteres.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'invalid-credential':
        return 'Credenciais inválidas.';
      default:
        return 'Erro de autenticação: ${e.message}';
    }
  }
}
