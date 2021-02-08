part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSendOTP extends AuthEvent {
  final String number;
  AuthSendOTP(this.number);
}

class FirebaseInitialized extends AuthEvent {}

class AuthLogin extends AuthEvent {}

class EnterVerificationCode extends AuthEvent {
  final String smsCode;
  EnterVerificationCode(this.smsCode);
}

class AuthChangeNumber extends AuthEvent {}

class VerificationComplete extends AuthEvent {
  final User user;
  VerificationComplete(this.user);
}

class RequestResendOtp extends AuthEvent {}
