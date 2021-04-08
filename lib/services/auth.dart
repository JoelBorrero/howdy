import 'database.dart';
import 'package:howdy/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create User object from FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid) //, displayName: user.displayName)
        : null;
  }

  //Auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future signInWithCredential(AuthCredential credential) async {
    try {
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  //Sign email
  Future signInEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  //Register email
  Future registerEmail(
      String email, String password, String name, String username) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateUserData(name, username);
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  //Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
