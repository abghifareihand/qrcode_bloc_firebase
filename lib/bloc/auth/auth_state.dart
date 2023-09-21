part of 'auth_bloc.dart';

abstract class AuthState {}

// STATE -> Kondisi saat ini
// 1. AuthStateLogin -> terautentifikasi
// 2. AuthStateLoading -> loading....
// 3. AuthStateLogout -> tidak terautentifikasi
// 4. AuthStateError -> gagal login -> dapat error

final class AuthStateLogin extends AuthState {}

final class AuthStateLoading extends AuthState {}

final class AuthStateLogout extends AuthState {}

final class AuthStateError extends AuthState {
  final String message;
  AuthStateError(
    this.message,
  );
}
