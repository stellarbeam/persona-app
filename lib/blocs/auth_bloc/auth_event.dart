part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class FirebaseInitialized extends AuthEvent {}

class AuthSendOTP extends AuthEvent {
  final String number;
  AuthSendOTP(this.number);
}

class AuthLogin extends AuthEvent {}

class EnterVerificationCode extends AuthEvent {
  final String smsCode;
  final Function onIncorrectOtp;
  EnterVerificationCode(this.smsCode, this.onIncorrectOtp);
}

class RequestResendOtp extends AuthEvent {}

class VerificationComplete extends AuthEvent {
  final User user;
  VerificationComplete(this.user);
}

class SubmitProfileDetails extends AuthEvent {
  final Map<String, String> details;

  SubmitProfileDetails(this.details);
}
