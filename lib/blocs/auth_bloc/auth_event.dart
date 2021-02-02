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

class AuthUninitialized extends AuthEvent {}

class AuthInitialized extends AuthEvent {}

class AuthLogin extends AuthEvent {}

class AuthVerifyCode extends AuthEvent {}

class AuthChangeNumber extends AuthEvent {}
