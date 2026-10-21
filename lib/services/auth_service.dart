import 'package:firebase_auth/firebase_auth.dart';

import '../data/models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  AuthService(this._auth, this._firestore);
  final FirebaseAuth _auth;
  final FirestoreService _firestore;

  Stream<User?> get authChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String fullName, String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    try {
      final profile = UserBuilder(user.uid)
          .withFullName(fullName)
          .withEmail(email)
          .build();
      await _firestore.db
          .collection('users')
          .doc(user.uid)
          .set(profile.toJson());
      await user.updateDisplayName(fullName);
    } on FirebaseException {
      await user.delete();
      rethrow;
    }
  }

  Future<void> signOut() => _auth.signOut();
}
