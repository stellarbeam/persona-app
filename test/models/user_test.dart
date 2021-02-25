import 'package:flutter_test/flutter_test.dart';
import 'package:persona/models/user.dart';
import 'package:persona/models/role.dart';

void main() {
  test('User objects with all details same, must be equal', () {
    User user1 = User(
      userId: '123',
      userName: 'xyz',
      role: Admin(),
      phoneNumber: '+911234567890',
    );
    User user2 = User(
      userId: '123',
      userName: 'xyz',
      role: Admin(),
      phoneNumber: '+911234567890',
    );
    expect(user1, user2);
  });

  test('User objects with different userId must not be equal', () {
    User user1 = User(
      userId: '123',
      userName: 'xyz',
      role: Admin(),
      phoneNumber: '+911234567890',
    );
    User user2 = User(
      userId: '456',
      userName: 'xyz',
      role: Admin(),
      phoneNumber: '+911234567890',
    );
    expect(user1, isNot(user2));
  });

  test('User objects with different userName must not be equal', () {
    User user1 = User(
      userId: '123',
      userName: 'xyz',
      role: Admin(),
      phoneNumber: '+911234567890',
    );
    User user2 = User(
      userId: '123',
      userName: 'abc',
      role: Admin(),
      phoneNumber: '+911234567890',
    );
    expect(user1, isNot(user2));
  });

  test('User objects with different role must not be equal', () {
    User user1 = User(
      userId: '123',
      userName: 'xyz',
      role: Admin(),
      phoneNumber: '+911234567890',
    );
    User user2 = User(
      userId: '456',
      userName: 'xyz',
      role: Boss(),
      phoneNumber: '+911234567890',
    );
    expect(user1, isNot(user2));
  });

  test('User objects with different phoneNumber must not be equal', () {
    User user1 = User(
      userId: '123',
      userName: 'xyz',
      role: Admin(),
      phoneNumber: '+911234567890',
    );
    User user2 = User(
      userId: '456',
      userName: 'xyz',
      role: Admin(),
      phoneNumber: '+911234567891',
    );
    expect(user1, isNot(user2));
  });
}
