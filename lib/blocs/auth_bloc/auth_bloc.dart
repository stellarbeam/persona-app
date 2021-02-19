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
  String _phoneNumber;
  int _resendToken;

  void _addVerificationCompleteEvent(User user) {
    this.add(VerificationComplete(user));
  }

  void _onFail(String code) {
    if (code == 'invalid-verification-code') {
      //? Use callback from otp_input_screen
      // Right now handled by null checking of `user` value
      print("Wrong code");
    } else {
      print(code);
    }
  }

  void _onVerificationComplete(credential) {
    _authRepo
        .signInWithCredential(credential, _onFail)
        .then((userCredential) =>
            _authRepo.userFromFirebaseUser(userCredential.user))
        .then((user) => _addVerificationCompleteEvent(user));
  }

  void _onVerificationFail(FirebaseAuthException exception) {
    print("Auth failed");
    print(exception.code);
  }

  void _onCodeSent(String verificationId, int resendToken) {
    print("Code has been sent.");
    isCodeSent = true;
    _verificationId = verificationId;
    _resendToken = resendToken;
  }

  void _onCodeAutoRetrievalTimeout(String verificationId) {
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
        // TODO: redirect to profile completion if profile incomplete
        yield UserAuthorized(user);
      } else {
        yield UserUnauthorized();
      }
    } else if (event is AuthSendOTP) {
      _phoneNumber = event.number;
      yield AuthCodeSent(_phoneNumber);

      _authRepo.verifyPhoneNumber(
        phoneNumber: event.number,
        verificationCompleted: _onVerificationComplete,
        verificationFailed: _onVerificationFail,
        codeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
        codeSent: _onCodeSent,
      );
    } else if (event is EnterVerificationCode) {
      // Use this to show spinner within otp_input_screen
      waitingForVerification = true;
      incorrectOtp = false;

      var user = await _authRepo.signInWithSmsCode(
        event.smsCode,
        _verificationId,
        _onFail,
      );

      waitingForVerification = false;

      if (user == null) {
        incorrectOtp = true;
        event.onIncorrectOtp();
        yield AuthCodeSent(_phoneNumber);
      } else {
        yield ProfileCompletion(user);
      }
    } else if (event is VerificationComplete) {
      yield ProfileCompletion(event.user);
    } else if (event is RequestResendOtp) {
      _authRepo.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: _onVerificationComplete,
        verificationFailed: _onVerificationFail,
        codeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
        codeSent: _onCodeSent,
        forceResendingToken: _resendToken,
      );
    } else if (event is SubmitProfileDetails) {
      _authRepo.storeUserProfile(event.details);
      yield (ProfileCompleted());
    }
  }
}
