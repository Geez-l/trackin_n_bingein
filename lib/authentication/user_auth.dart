import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackin_n_bingein/global/common/toast.dart';

// Instance of FirebaseAuth to interact with Firebase Authentication
final FirebaseAuth _auth = FirebaseAuth.instance;

class FirebaseAuthentication {

  // Method to create a new user with email and password
  Future<User?> createUserwithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      // Creating a new user with the provided email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Handling specific FirebaseAuthException errors
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email is already in use.');
      }
    }
    return null;
  }

  // Method to sign in an existing user with email and password
  Future<User?> signInwithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      // Signing in the user with the provided email and password
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return credential.user;
    } on FirebaseException catch (e) {
      // Handling specific FirebaseAuthException errors
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } 
    }
    return null;
  }

  // Method to delete the currently signed-in user's account
  Future<void> deleteUserAccount() async {
    try {
      // Attempting to delete the user's account
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      // Handling specific FirebaseAuthException errors
      if (e.code == "requires-recent-login") { 
        await _reauthenticateAndDelete();
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    } catch (e) {
      showToast(message: 'Account deleted successfully.');
    }
  }

  // Method to reauthenticate the user and then delete the account
  Future<void> _reauthenticateAndDelete() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        showToast(message: 'No user is currently signed in.');
        return;
      }

      final providerData = user.providerData.first;

      // Reauthenticating the user based on their authentication provider
      if (providerData.providerId == 'apple.com') {
        await user.reauthenticateWithProvider(AppleAuthProvider());
      } else if (providerData.providerId == 'google.com') {
        await user.reauthenticateWithProvider(GoogleAuthProvider());
      } else {
        showToast(message: 'Re-authentication method not supported.');
        return;
      }

      // Deleting the user's account after reauthentication
      await user.delete();
      showToast(message: 'Account deleted successfully.');
    } catch (e) {
      showToast(message: 'Re-authentication failed: ${e.toString()}');
    }
  }
}