part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthCodeSent extends AuthState {
  final String phoneNumber;
  final int retries;
  AuthCodeSent(this.phoneNumber, {this.retries = 0});

  @override
  List<Object> get props => [phoneNumber, retries];
}

class UserUnauthorized extends AuthState {}

class UserAuthorized extends AuthState {
  final User user;
  UserAuthorized(this.user);
}

class ProfileCompletion extends AuthState {
  final User user;
  ProfileCompletion(this.user);
}

class ProfileCompleted extends AuthState {}

class NoConnectivity extends AuthState {}
