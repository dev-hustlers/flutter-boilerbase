import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive', // Full drive access scope
    ],
  );

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  Future<GoogleSignInAccount?> getGoogleUser() async {
    if (_googleSignIn.currentUser != null) {
      return _googleSignIn.currentUser;
    }
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      print("Error during signInSilently: $e");
      return null;
    }
  }

  // Google sign in
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Begin interactive sign in process
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      // User cancels google sign in pop up screen
      if (gUser == null) return null;

      // Obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Finally, sign in!
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }
}
