import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';

import '../mainScreen/main_screen.dart';
import 'google_signin_screen_bloc.dart';

class GoogleSigninScreen extends StatefulWidget {
  const GoogleSigninScreen({super.key});

  @override
  State<GoogleSigninScreen> createState() => _GoogleSigninScreenState();
}

class _GoogleSigninScreenState extends State<GoogleSigninScreen> {
  GoogleSigninScreenBloc _bloc = GoogleSigninScreenBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: screenSizeRatio * 0.2),

          //Title of Screen
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Welcome to our\n",
                      style: GoogleFonts.nunito(fontSize: screenSizeRatio * 0.035, color: MyColors.mainColor)),
                  TextSpan(
                      text: "WLF New Flutter App",
                      style: GoogleFonts.nunito(
                          fontSize: screenSizeRatio * 0.045, color: MyColors.mainColor, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),

          //Screen Image

          Padding(
            padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.05),
            child: Image(image: AssetImage("assets/images/loginScreenVector.png")),
          ),

          //Sign In With Google Button
          SizedBox(
            height: screenSizeRatio * 0.1,
          ),
          Container(
            height: buttonHeight,
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.02),
            child: ElevatedButton.icon(
              label: Text(
                "Sign in with Google",
                style: TextStyle(color: MyColors.buttonFontColor, fontWeight: FontWeight.bold, fontSize: screenSizeRatio * 0.035),
              ),
              icon: Image(
                image: AssetImage("assets/images/googleIcon.png"),
                height: screenSizeRatio * 0.06,
              ),
              onPressed: () async {
                UserCredential? cred = await _bloc.signInWithGoolgle();
                if (cred != null) {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return MainScreen();
                    },
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.mainColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(7))),
            ),
          )
        ],
      ),
    );
  }
}
