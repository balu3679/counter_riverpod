import 'package:messenger/domain/repositories/auth_resp.dart';

import '../entities/user_entity.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<UserEntity?> call(String email, String password) async {
    return repository.signUp(email, password);
  }
}

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<UserEntity?> call(String email, String password) async {
    return repository.login(email, password);
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<void> call() async {
    return repository.logout();
  }
}

class AuthStateChangesUseCase {
  final AuthRepository repository;
  AuthStateChangesUseCase(this.repository);

  Stream<UserEntity?> call() {
    return repository.authStateChanges;
  }
}
