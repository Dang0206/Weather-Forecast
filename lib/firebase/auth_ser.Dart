import 'package:flutter/material.dart';
import 'auth_ser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.sendEmailVerification();
      return null; 
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') return 'weak password';
      
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  
  User? get currentUser => _auth.currentUser;

  Future<String?> deleteUser() async {
    final user = _auth.currentUser;
    if (user == null) return 'There are no accounts to cancel.';
    try {
      await user.delete();
      return null;
    } catch (e) {
      return 'Unable to unsubscribe: $e';
    }
  }
}
