import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/my_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthMode { Signup, Login, reset, phone }

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  String? getUserName() {
    return _auth.currentUser!.displayName;
  }

  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        //.map((User? user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser); // exactly same as above
  }

  String userId() {
    try {
      final response = _auth.currentUser!.uid;
      return response;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future signIn({
    required String email,
    required String password,
  }) async {
    print("entered into signIn");
    try {
      final response = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = response.user!;
      print(user);
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future signUp(
      {required String email,
      required String password,
      required String userName}) async {
    try {
      User user;
      final response = await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => value.user!.updateDisplayName(userName))
          .then(
            (value) =>
                firestore.collection('users').doc(_auth.currentUser!.uid).set(
              {
                "username": _auth.currentUser!.displayName,
                "easyScore": 0,
                "mediumScore": 0,
                "hardScore": 0,
              },
            ),
          );
      user = _auth.currentUser!;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<bool> forgetPass(String email) async {
    bool flg = false;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      flg = true;
      return flg;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }
}
