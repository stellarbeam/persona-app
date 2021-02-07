import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

import '../../models/user.dart';
import '../../repositories/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuthRepo _authRepo;
  bool isCodeSent = false;
  bool timedOut = false;
  bool waitingForVerification = false;
  bool incorrectOtp = false;
  String _verificationId = "";
  String phoneNumber;
  int _resendToken;

  void addVerificationCompleteEvent(User user) {
    this.add(VerificationComplete(user));
  }

  void onFail(String code) {
    if (code == 'invalid-verification-code') {
      //? Use callback from otp_input_screen
      // Right now handled by null checking of `user` value
      print("Wrong code");
    } else {
      print(code);
    }
  }

  void onVerificationComplete(credential) {
    _authRepo
        .signInWithCredential(credential, onFail)
        .then((userCredential) =>
            _authRepo.userFromFirebaseUser(userCredential.user))
        .then((user) => addVerificationCompleteEvent(user));
  }

  void onVerificationFail(FirebaseAuthException exception) {
    print("Auth failed");
    print(exception.code);
  }

  void onCodeSent(String verificationId, int resendToken) {
    print("Code has been sent.");
    isCodeSent = true;
    _verificationId = verificationId;
    _resendToken = resendToken;
  }

  void onCodeAutoRetrievalTimeout(String verificationId) {
    print("Timed out waiting for SMS");
    timedOut = true;
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
        verificationCompleted: onVerificationComplete,
        verificationFailed: onVerificationComplete,
        codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
        codeSent: onCodeSent,
      );
    } else if (event is EnterVerificationCode) {
      // Use this to show spinner within otp_input_screen
      waitingForVerification = true;

      var user = await _authRepo.signInWithSmsCode(
        event.smsCode,
        _verificationId,
        onFail,
      );

      if (user == null) {
        print("Setting otp as incorrect");
        waitingForVerification = false;
        incorrectOtp = true;
        yield AuthCodeSent(phoneNumber);
      } else {
        yield UserAuthorized(user);
      }
    } else if (event is VerificationComplete) {
      yield (UserAuthorized(event.user));
    }
  }
}
