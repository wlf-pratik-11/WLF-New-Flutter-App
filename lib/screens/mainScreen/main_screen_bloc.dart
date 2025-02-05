import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/googleSignInScreen/google_signin_screen.dart';

import '../../commons/common_functions.dart';
import '../../commons/my_colors.dart';

class MainScreenBloc {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
          backgroundColor: MyColors.mainColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.025),
                child: Text(
                  StringValues.areYouWantToLogout,
                  style: TextStyle(color: Colors.white, fontSize: diologeFontSize, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.02, horizontal: screenSizeRatio * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          StringValues.cancel,
                          style: TextStyle(color: Colors.white, fontSize: diologeButtonFontSize),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
                            backgroundColor: MyColors.buttonFontColor),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            await GoogleSignIn().signOut().then(
                              (value) {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GoogleSigninScreen(),
                                    ));
                              },
                            );
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        child: Text(
                          StringValues.signOut,
                          style: TextStyle(color: MyColors.mainColor, fontSize: diologeButtonFontSize),
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
