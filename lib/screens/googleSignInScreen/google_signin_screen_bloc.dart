import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninScreenBloc {
  Future<UserCredential?> signInWithGoolgle() async {
    try {
      final GoogleSignInAccount? googleUsers = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUsers?.authentication;
      final cred = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      return FirebaseAuth.instance.signInWithCredential(cred);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
