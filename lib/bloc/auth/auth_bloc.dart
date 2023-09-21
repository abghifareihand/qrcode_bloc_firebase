import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateLogout()) {
    FirebaseAuth auth = FirebaseAuth.instance;
    on<AuthEventLogin>((event, emit) async {
      try {
        emit(AuthStateLoading());
        // fungsi untuk login
        await auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateLogin());
      } on FirebaseAuthException catch (e) {
        // error firebase auth
        emit(AuthStateError(e.toString()));
      } catch (e) {
        // error general
        emit(AuthStateError(e.toString()));
      }
    });
    on<AuthEventLogout>((event, emit) async {
      try {
        emit(AuthStateLoading());
        // fungsi untuk logout
        await auth.signOut();
        emit(AuthStateLogout());
      } on FirebaseAuthException catch (e) {
        // error firebase auth
        emit(AuthStateError(e.toString()));
      } catch (e) {
        // error general
        emit(AuthStateError(e.toString()));
      }
    });
  }
}
