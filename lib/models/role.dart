abstract class Role {
  String get name;
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
