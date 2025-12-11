import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  GoogleSignInAccount? _currentUser;

  // Get current user
  GoogleSignInAccount? get currentUser => _currentUser;

  // Sign in dengan Google (tanpa Firebase)
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User membatalkan sign in
        return null;
      }

      _currentUser = googleUser;
      return googleUser;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  // Check if user is signed in
  bool isSignedIn() {
    return _currentUser != null;
  }

  // Get user info
  Map<String, String>? getUserInfo() {
    if (_currentUser != null) {
      return {
        'displayName': _currentUser!.displayName ?? 'User Name',
        'email': _currentUser!.email,
        'id': _currentUser!.id,
        'photoUrl': _currentUser!.photoUrl ?? '', // NEW: Tambah photo URL
      };
    }
    return null;
  }

  // Silent sign in (otomatis jika sudah pernah login)
  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      
      if (googleUser != null) {
        _currentUser = googleUser;
      }
      
      return googleUser;
    } catch (e) {
      print('Error silent sign in: $e');
      return null;
    }
  }
}
