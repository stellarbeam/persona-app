import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart' as models;

class FirebaseAuthRepo {
  // The argument functions must be provided by calling bloc,
  // since bloc is responsible for logic and providing states.
  Future<void> verifyPhoneNumber({
    @required String phoneNumber,
    @required Function verificationCompleted,
    @required Function verificationFailed,
    @required Function codeAutoRetrievalTimeout,
    @required Function codeSent,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      codeSent: codeSent,
    );
    print("Called verify");
  }

  Future<void> setCurrentUserRole(models.Role role) async {
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // TODO: Come up with better way to set role value
    await users.doc(user.uid).set({
      'role': role.toString().split('.').last,
    });
  }

  Future<models.Role> getCurrentUserRole() async {
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    models.Role role;

    final document = await users
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data())
        .catchError((e) {
      print("No such document");
    });

    if (role != null) return role;

    print(document);
    return models.Role.Admin;

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
    User firebaseUser = FirebaseAuth.instance.currentUser;
    var role = await getCurrentUserRole();

    return models.User(
      userId: firebaseUser.uid,
      userName: firebaseUser.displayName,
      role: role,
      phoneNumber: firebaseUser.phoneNumber,
    );
  }

  bool isAuthenticated() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<models.User> signInWithSmsCode(
    String smsCode,
    String verificationId,
  ) async {
    final authCredential = PhoneAuthProvider.credential(
      smsCode: smsCode,
      verificationId: verificationId,
    );

    final userCredential = await signInWithCredential(authCredential);

    return userFromFirebaseUser(userCredential.user);
  }

  Future<UserCredential> signInWithCredential(AuthCredential authCredential) {
    return FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  models.User userFromFirebaseUser(User user) {
    return models.User(
      userId: user.uid,
      phoneNumber: user.phoneNumber,
      userName: user.displayName,
    );
  }
}
