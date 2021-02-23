import 'package:flutter_test/flutter_test.dart';
import '../lib/models/role.dart';

void main() {
  test('Role child objects of same class must be equal', () {
    expect(Admin(), Admin());
    expect(Boss(), Boss());
    expect(Employee(), Employee());
  });

  test('Role child objects of different class must not be equal', () {
    expect(Admin(), isNot(Boss()));
    expect(Boss(), isNot(Employee()));
    expect(Admin(), isNot(Employee()));
  });
}
