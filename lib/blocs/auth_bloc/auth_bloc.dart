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
  bool isCodeSent = false;
  bool timedOut = false;
  bool waitingForVerification = false;
  String verificationId;
  String resendToken;

  void addVerificationCompleteEvent(User user) {
    this.add(VerificationComplete(user));
  }

  void onFail(String code) {
    if (code == 'invalid-verification-code') {
      //? Use callback from otp_input_screen
      print("Wrong code");
    }
  }

  AuthBloc() : super(AuthInitial()) {
    _authRepo = FirebaseAuthRepo();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is FirebaseInitialized) {
      if (_authRepo.isAuthenticated()) {
        final user = await _authRepo.getUser();
        yield UserAuthorized(user);
      } else {
        yield UserUnauthorized();
      }
    } else if (event is AuthSendOTP) {
      yield AuthCodeSent(event.number);

      _authRepo.verifyPhoneNumber(
        phoneNumber: event.number,
        verificationCompleted: (credential) {
          _authRepo
              .signInWithCredential(credential, onFail)
              .then((UserCredential userCredential) =>
                  _authRepo.userFromFirebaseUser(userCredential.user))
              .then((user) => addVerificationCompleteEvent(user));
        },
        verificationFailed: (FirebaseAuthException exception) {
          print("Auth failed");
          print(exception.code);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Timed out waiting for SMS");
          timedOut = true;
        },
        codeSent: (String verificationId, int resendToken) {
          print("Code has been sent.");
          isCodeSent = true;
          verificationId = verificationId;
          resendToken = resendToken;
        },
      );
    } else if (event is EnterVerificationCode) {
      // Use this to show spinner within otp_input_screen
      waitingForVerification = true;

      _authRepo.signInWithSmsCode(event.smsCode, verificationId, onFail);
    }
  }
}
