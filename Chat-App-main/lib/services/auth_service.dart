import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return UserModel(
        uid: result.user!.uid,
        email: result.user!.email!,
        displayName: result.user!.displayName,
        photoUrl: result.user!.photoURL,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signUpWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return UserModel(
        uid: result.user!.uid,
        email: result.user!.email!,
        displayName: result.user!.displayName,
        photoUrl: result.user!.photoURL,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
