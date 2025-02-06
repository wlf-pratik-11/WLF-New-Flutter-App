import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../googleSignInScreen/google_signin_screen.dart';
import '../mainScreen/main_screen.dart';

class SplashScreenBloc {
  SplashScreenBloc(BuildContext context) {
    navigateToHome(context);
  }

  final _user = FirebaseAuth.instance.currentUser;

  Future<void> navigateToHome(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return _user == null ? GoogleSignInScreen() : MainScreen();
        },
      ));
    }
  }
}
