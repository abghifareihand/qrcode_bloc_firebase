part of 'auth_bloc.dart';

abstract class AuthEvent {}

// EVENT -> aksi / tindakan
// 1. AuthEventLogin -> melakukan tindakan login
// 3. AuthEventLogout -> melakukan tindakan logout

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;

  AuthEventLogin(
    this.email,
    this.password,
  );
}

class AuthEventLogout extends AuthEvent {}
