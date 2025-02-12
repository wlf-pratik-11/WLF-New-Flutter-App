import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';

import '../mainScreen/main_screen.dart';

class GoogleSignInScreenBloc {
  final BuildContext context;
  GoogleSignInScreenBloc(this.context);

  final isSignInProcessing = BehaviorSubject<bool>.seeded(false);

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUsers = await GoogleSignIn().signIn();
      isSignInProcessing.sink.add(true);
      // await Future.delayed(Duration(seconds: 2));
      final GoogleSignInAuthentication? googleAuth = await googleUsers?.authentication;
      final OAuthCredential cred = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(cred);
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              isSignInProcessing.sink.add(false);
              return MainScreen();
            },
          ),
        );
      }
      return userCredential;
    } catch (e) {
      if (context.mounted) {
        isSignInProcessing.sink.add(false);
        final snackBar = SnackBar(
          content: Text(
            StringValues.failedToSignInWithGoogle,
            style: TextStyle(color: MyColors.buttonFontColor, fontSize: snakBarFontSize, fontWeight: FontWeight.bold),
          ),
          backgroundColor: MyColors.mainColor,
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      debugPrint(e.toString());
    }
    return null;
  }
}
