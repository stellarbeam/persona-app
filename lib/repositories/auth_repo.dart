import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart' as models;

class FirebaseAuthRepo {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  FirebaseAuthRepo({
    FirebaseAuth firebaseAuth,
    FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  // The argument functions must be provided by calling bloc,
  // since bloc is responsible for logic and providing states.
  Future<void> verifyPhoneNumber({
    @required String phoneNumber,
    @required Function verificationCompleted,
    @required Function verificationFailed,
    @required Function codeAutoRetrievalTimeout,
    @required Function codeSent,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      codeSent: codeSent,
    );
  }

  Future<void> setCurrentUserRole(models.Role role) async {
    User user = _firebaseAuth.currentUser;
    CollectionReference users = _firebaseFirestore.collection('users');

    // TODO: Come up with better way to set role value
    await users.doc(user.uid).set({
      'role': role.toString().split('.').last,
    });
  }

  Future<models.Role> getCurrentUserRole() async {
    User user = _firebaseAuth.currentUser;
    CollectionReference users = _firebaseFirestore.collection('users');
    models.Role role;

    final document = await users
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());

    // TODO: Handle possible error from doc.get()
    switch (document['role']) {
      case 'Admin':
        role = models.Role.Admin;
        break;
      case 'Boss':
        role = models.Role.Boss;
        break;
      case 'Employee':
        role = models.Role.Employee;
        break;
    }

    return role;
  }

  Future<models.User> getUser() async {
    User firebaseUser = _firebaseAuth.currentUser;
    var role = await getCurrentUserRole();

    return models.User(
      userId: firebaseUser.uid,
      userName: firebaseUser.displayName,
      role: role,
      phoneNumber: firebaseUser.phoneNumber,
    );
  }

  bool isAuthenticated() {
    return _firebaseAuth.currentUser != null;
  }

  Future<models.User> signInWithSmsCode(
    String smsCode,
    String verificationId,
  ) async {
    final authCredential = PhoneAuthProvider.credential(
      smsCode: smsCode,
      verificationId: verificationId,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);

    return models.User(
      userId: userCredential.user.uid,
      phoneNumber: userCredential.user.phoneNumber,
      userName: userCredential.user.displayName,
    );
  }
}
