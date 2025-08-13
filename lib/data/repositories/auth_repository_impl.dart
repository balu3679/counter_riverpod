import 'package:messenger/domain/repositories/auth_resp.dart';

import '../../domain/entities/user_entity.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<UserEntity?> signUp(String email, String password) async {
    final user = await dataSource.signUp(email, password);
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserEntity?> login(String email, String password) async {
    final user = await dataSource.login(email, password);
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<void> logout() async {
    return dataSource.logout();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return dataSource.authStateChanges().map(
      (firebaseUser) => firebaseUser == null ? null : UserModel.fromFirebaseUser(firebaseUser),
    );
  }
}
