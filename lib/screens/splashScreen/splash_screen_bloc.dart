import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../googleSignInScreen/google_signin_screen.dart';
import '../mainScreen/main_screen.dart';

class SplashScreenBloc {
  final BuildContext context;
  SplashScreenBloc(this.context){
    navigateToHome();
  }

  final _user = FirebaseAuth.instance.currentUser;

  Future<void> navigateToHome() async {
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
