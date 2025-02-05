import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';

import '../mainScreen/main_screen.dart';

class GoogleSigninScreenBloc {
  Future<UserCredential?> signInWithGoolgle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUsers = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUsers?.authentication;
      final cred = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      // if (cred != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return MainScreen();
        },
      ));
      // }
      return FirebaseAuth.instance.signInWithCredential(cred);
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(
          StringValues.failedToSignInWithGoogle,
          style: TextStyle(color: MyColors.buttonFontColor, fontSize: snakBarFontSize, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors.mainColor,
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e.toString());
    }
    return null;
  }
}
