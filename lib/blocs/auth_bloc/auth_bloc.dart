import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import '../../repositories/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Must depend on auth repo and [TODO:]flutterfire bloc.
  FirebaseAuthRepo authRepo;

  AuthBloc() : super(AuthInitial()) {
    authRepo = FirebaseAuthRepo();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthUninitialized) {
      yield AuthInitial();
    } else if (event is AuthInitialized) {
      if (authRepo.isAuthenticated()) {
        final user = await authRepo.getUser();
        yield AuthAuthorized(user);
      } else {
        yield AuthUnauthorized();
      }
    } else if (event is AuthSendOTP) {
      yield AuthLoading();
      authRepo.verifyPhoneNumber(
        phoneNumber: event.number,
        verificationCompleted: null,
        verificationFailed: null,
        codeAutoRetrievalTimeout: null,
        codeSent: null,
      );
    }
  }
}
