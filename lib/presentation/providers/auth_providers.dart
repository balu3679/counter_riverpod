import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user_entity.dart';

final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthDataSource(firebaseAuth);
});

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final dataSource = ref.watch(firebaseAuthDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repo);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginUseCase(repo);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repo);
});

final authStateChangesUseCaseProvider = Provider<AuthStateChangesUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthStateChangesUseCase(repo);
});

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final stream = ref.watch(authStateChangesUseCaseProvider)();
  stream.listen((user) {
    print("Auth state changed: ${user?.email ?? "logged out"}");
  });
  return stream;
});

final counterProvider = StateProvider<int>((ref) => 0);
