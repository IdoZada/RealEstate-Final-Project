import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_estate/Business_Logic/investor/investor.dart';
import 'package:real_estate/Data_Access/database.dart';
import 'package:real_estate/Utils/exceptions/auth_exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  final StreamController<Investor> myUserStreamController =
      StreamController<Investor>();
  var authErrorMessage;

  AuthService() {
    listenToFirebaseAuthChanges();
  }

  listenToFirebaseAuthChanges() {
    _auth.authStateChanges().listen((firebaseUserEvent) {
      if (firebaseUserEvent == null) {
        myUserStreamController.add(null); // logout
      } else {
        _databaseService
            .getUserByEmail(firebaseUserEvent.email)
            .then((myUser) => myUserStreamController.add(myUser)); // login
      }
    });
  }

  // auth change user stream
  Stream<Investor> get user {
    return myUserStreamController.stream;
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      return await _databaseService.getUserByEmail(firebaseUser.email);
    } catch (e) {
      authErrorMessage = AuthExceptionHandler.handleException(e);
      return null;
    }
  }

  // register with email & password
  Future<Investor> registerWithEmailAndPassword(
      String email, String password, String firstname, String lastname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      await _databaseService.createNewUser(
          firebaseUser.email, firstname, lastname);
      return _databaseService.getUserByEmail(firebaseUser.email);
    } catch (e) {
      authErrorMessage = AuthExceptionHandler.handleException(e);
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
