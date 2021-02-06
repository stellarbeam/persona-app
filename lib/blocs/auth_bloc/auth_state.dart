part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {} // => Loading Screen

// class AuthLoading extends AuthState {} // => Sending OTP

class AuthCodeSent extends AuthState {
  final String phoneNumber;
  AuthCodeSent(this.phoneNumber);
} // => OTP input screen

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {}

class UserUnauthorized extends AuthState {} // => Phone Input Screen

class UserAuthorized extends AuthState {
  final User user;
  UserAuthorized(this.user);
} // => HomeScreen
