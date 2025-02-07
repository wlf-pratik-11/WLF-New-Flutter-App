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
    _bloc = GoogleSignInScreenBloc();
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
      padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.05),
      child: Image(image: AssetImage("assets/images/loginScreenVector.png")),
    );
  }

  Widget signInWithGoogleButtonContainer() {
    return Container(
      height: buttonHeight,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.02),
      child: StreamBuilder<bool>(
          stream: _bloc.isSignInProcessing,
          builder: (context, isSignInProcessingSnapshot) {
            return isSignInProcessingSnapshot.data == false ? enableButton() : disableButton();
          }),
    );
  }

  Widget enableButton() {
    return ElevatedButton.icon(
      label: Text(
        StringValues.signInWithGoogle,
        style: TextStyle(color: MyColors.buttonFontColor, fontWeight: FontWeight.bold, fontSize: screenSizeRatio * 0.035),
      ),
      icon: Image(
        image: AssetImage("assets/images/googleIcon.png"),
        height: screenSizeRatio * 0.06,
      ),
      onPressed: () async {
        await _bloc.signInWithGoogle(context);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.mainColor, shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(7))),
    );
  }

  Widget disableButton() {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
          disabledBackgroundColor: MyColors.mainColor.withOpacity(0.6),
          backgroundColor: MyColors.mainColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(7))),
      child: LoadingAnimationWidget.discreteCircle(color: MyColors.mainColor, size: screenSizeRatio * 0.05),
    );
  }
}
