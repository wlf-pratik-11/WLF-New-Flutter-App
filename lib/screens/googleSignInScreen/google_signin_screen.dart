import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  late final GoogleSignInScreenBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = GoogleSignInScreenBloc(context);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: screenSizeRatio * 0.2),

        //Title of Screen
        _titleOfScreen(),

        //Screen Image
        _screenImage(),

        //Sign In With Google Button
        SizedBox(
          height: screenSizeRatio * 0.1,
        ),
        signInWithGoogleButtonContainer()
      ],
    );
  }

  Widget _titleOfScreen() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text: "${StringValues.welcomeToOur}\n",
              style: GoogleFonts.nunito(fontSize: screenSizeRatio * 0.035, color: MyColors.mainColor)),
          TextSpan(
              text: StringValues.wlfNewFlutterApp,
              style:
                  GoogleFonts.nunito(fontSize: screenSizeRatio * 0.045, color: MyColors.mainColor, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _screenImage() {
    return Padding(
      padding: paddingSymmetric(vertical: 0.05),
      child: Image(image: AssetImage("assets/images/loginScreenVector.png")),
    );
  }

  Widget signInWithGoogleButtonContainer() {
    return Container(
      height: buttonHeight,
      width: double.maxFinite,
      padding: paddingSymmetric(horizontal: 0.02),
      child: signInButton(),
    );
  }

  Widget signInButton() {
      return StreamBuilder<bool>(
        stream: _bloc.isSignInProcessing,
        builder: (context, snapshot) {
          bool isProcessing = snapshot.data ?? false;

          return ElevatedButton.icon(
            label: isProcessing
                ? LoadingAnimationWidget.discreteCircle(
              color: MyColors.buttonFontColor,
              size: screenSizeRatio * 0.05,
            )
                : Text(
              StringValues.signInWithGoogle,
              style: TextStyle(
                color: MyColors.buttonFontColor,
                fontWeight: FontWeight.bold,
                fontSize: screenSizeRatio * 0.035,
              ),
            ),
            icon: isProcessing
                ? const SizedBox()
                : Image.asset(
              "assets/images/googleIcon.png",
              height: screenSizeRatio * 0.06,
            ),
            onPressed: isProcessing
                ? null
                : () async {
              await _bloc.signInWithGoogle();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isProcessing
                  ? MyColors.mainColor.withOpacity(
                  0.7)
                  : MyColors.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(
                    screenSizeRatio * 0.01),
              ),
            ),
          );
        },
      );
  }
}
