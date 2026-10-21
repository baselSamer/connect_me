import 'package:firebase_auth/firebase_auth.dart';

String friendlyError(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'The email or password is incorrect.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
    }
  }
  if (error is FirebaseException) {
    if (error.code == 'permission-denied') {
      return 'You do not have permission to do that.';
    }
    if (error.code == 'unavailable') {
      return 'The service is temporarily unavailable. Please try again.';
    }
  }
  return 'Something went wrong. Please try again.';
}
