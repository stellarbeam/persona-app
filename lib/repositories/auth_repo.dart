import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/role.dart';
import '../models/user.dart' as models;

class FirebaseAuthRepo {
  /// The argument functions must be provided by calling bloc,
  /// since bloc is responsible for logic and providing states.
  ///
  /// [NOTE]: These functions must be strictly `void` or `Future<void>`.
  /// Functions that are `Stream<void>`  have no effect.
  /// If a non-async* functions contains function calls to async*
  /// functions, the async* functions seem to have no effect.
  ///
  /// `forceResendingToken` should be passed when requesting to
  /// resend verification SMS.
  Future<void> verifyPhoneNumber({
    @required String phoneNumber,
    @required Function verificationCompleted,
    @required Function verificationFailed,
    @required Function codeAutoRetrievalTimeout,
    @required Function codeSent,
    int forceResendingToken,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      codeSent: codeSent,
      forceResendingToken: forceResendingToken,
    );
    print("DEBUG: Called verifyPhoneNumber.");
  }

  Future<void> setCurrentUserRole(Role role) async {
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.doc(user.uid).set({
      'role': role.name,
    });
  }

  Future<Role> getCurrentUserRole() async {
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Role role;

    var documentSnapshot = await users.doc(user.uid).get();

    var document;

    if (documentSnapshot != null) {
      document = documentSnapshot.data();
      if (document == null) return null;
      switch (document['role']) {
        case 'Admin':
          role = Admin();
          break;
        case 'Boss':
          role = Boss();
          break;
        case 'Employee':
          role = Employee();
          break;
        default:
          role = null;
      }
      return role;
    } else {
      print("DEBUG: No such document");
    }
    return null;
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
    Function onFail,
  ) async {
    final authCredential = PhoneAuthProvider.credential(
      smsCode: smsCode,
      verificationId: verificationId,
    );

    final userCredential = await signInWithCredential(authCredential, onFail);

    return userCredential != null
        ? userFromFirebaseUser(userCredential.user)
        : null;
  }

  Future<UserCredential> signInWithCredential(
    AuthCredential authCredential,
    Function(String) onFail,
  ) async {
    try {
      print("DEBUG: Invoking signInWithCredential now.");
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(
        "DEBUG: signInWithCredential: auth failed, exception is of type FirebaseAuthException.",
      );
      onFail(e.code);
    } catch (e) {
      onFail(
        "DEBUG: signInWithCredential: auth failed, exception is NOT of type FirebaseAuthException. Error is:",
      );
      print(e);
    }
    return null;
  }

  Future<models.User> userFromFirebaseUser(User user) async {
    Role role;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var documentSnapshot = await users.doc(user.uid).get();

    if (documentSnapshot.exists) {
      var document = documentSnapshot.data();
      switch (document['role']) {
        case 'Admin':
          role = Admin();
          break;
        case 'Boss':
          role = Boss();
          break;
        case 'Employee':
          role = Employee();
          break;
        default:
          role = null;
      }
    } else {
      print("No such document");
    }

    return models.User(
      userId: user.uid,
      userName: user.displayName,
      role: role,
      phoneNumber: user.phoneNumber,
    );
  }

  void storeUserProfile(Map<String, String> details) async {
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.doc(user.uid).set(details);
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    var documentSnapshot = await users.doc(user.uid).get();

    if (documentSnapshot != null) {
      return documentSnapshot.data();
    } else {
      return null;
    }
  }
}
