import 'package:equatable/equatable.dart';
import 'role.dart';

class User extends Equatable {
  final String userId;
  final String userName;
  final Role role;
  final String phoneNumber;

  User({
    this.userId,
    this.userName,
    this.role,
    this.phoneNumber,
  });

  @override
  List<Object> get props => [userId, userName, role, phoneNumber];
}
