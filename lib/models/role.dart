import 'package:equatable/equatable.dart';

abstract class Role extends Equatable {
  String get name;

  @override
  List<Object> get props => [name];
}

class Admin extends Role {
  @override
  String get name => "Admin";
}

class Boss extends Role {
  @override
  String get name => "Boss";
}

class Employee extends Role {
  @override
  String get name => "Employee";
}
