import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';

import 'google_signin_screen_bloc.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  final GoogleSigninScreenBloc _bloc = GoogleSigninScreenBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: screenSizeRatio * 0.2),

          //Title of Screen
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                    text: "${StringValues.welcomeToOur}\n",
                    style: GoogleFonts.nunito(fontSize: screenSizeRatio * 0.035, color: MyColors.mainColor)),
                TextSpan(
                    text: StringValues.wlfNewFlutterApp,
                    style: GoogleFonts.nunito(
                        fontSize: screenSizeRatio * 0.045, color: MyColors.mainColor, fontWeight: FontWeight.bold))
              ],
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
                StringValues.signInWithGoogle,
                style: TextStyle(color: MyColors.buttonFontColor, fontWeight: FontWeight.bold, fontSize: screenSizeRatio * 0.035),
              ),
              icon: Image(
                image: AssetImage("assets/images/googleIcon.png"),
                height: screenSizeRatio * 0.06,
              ),
              onPressed: () async {
                await _bloc.signInWithGoolgle(context);
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
