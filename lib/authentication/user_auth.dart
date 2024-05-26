import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackin_n_bingein/global/common/toast.dart';

class FirebaseAuthentication {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createUserwithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password);
        return credential.user;
    } on FirebaseAuthException catch(e){
      if (e.code == 'email-already-in-use'){
        showToast(message: 'The email is already in use.');
      } else {
        // showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInwithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password);
        return credential.user;
    } on FirebaseException catch(e){
      if (e.code == 'user-not-found' || e.code == 'wrong-password'){
        showToast(message: 'Invalid email or password.');
      } else {
        // showToast(message: 'An error occured: ${e.code}');
      }
    }
    return null;
  }
}