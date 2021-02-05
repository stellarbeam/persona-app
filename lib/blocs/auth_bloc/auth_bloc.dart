import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show UserCredential, FirebaseAuthException;

import '../../models/user.dart';
import '../../repositories/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuthRepo _authRepo;
  bool _firebaseInitialized;

  AuthBloc() : super(AuthInitial()) {
    _authRepo = FirebaseAuthRepo();
    _firebaseInitialized = false;
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthStarted) {
      yield AuthInitial();
    } else if (event is AuthFirebaseInitialized) {
      _firebaseInitialized = true;
      if (_authRepo.isAuthenticated()) {
        print("Authenticated. Trying to fetch user.");
        final user = await _authRepo.getUser();
        yield AuthAuthorized(user);
      } else {
        yield AuthUnauthorized();
      }
    } else if (event is AuthSendOTP) {
      yield AuthLoading();

      _authRepo.verifyPhoneNumber(
        phoneNumber: event.number,
        verificationCompleted: (credential) {
          _authRepo.signInWithCredential(credential).then(
            (UserCredential userCredential) async* {
              final user = _authRepo.userFromFirebaseUser(userCredential.user);
              yield AuthAuthorized(user);
            },
          );
        },
        verificationFailed: (FirebaseAuthException exception) async* {
          yield AuthFailure();
          print(exception.code);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        codeSent: (String verificationId, int resendToken) async* {
          yield AuthCodeSent();
        },
      );
    }
  }
}
