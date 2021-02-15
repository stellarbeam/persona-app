import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'role.dart';

class User extends Equatable {
  final String userId;
  final String userName;
  final Role role;
  final String phoneNumber;

  // TODO: profile details must be bound to User model
  User({
    @required this.userId,
    @required this.userName,
    @required this.role,
    @required this.phoneNumber,
  });

  @override
  List<Object> get props => [userId, userName, role, phoneNumber];
}
