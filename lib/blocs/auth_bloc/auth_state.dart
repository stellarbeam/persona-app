part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AppLoading extends AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthCodeSent extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {}

class UserUnauthorized extends AuthState {}

class UserAuthorized extends AuthState {
  final User user;
  UserAuthorized(this.user);
}
