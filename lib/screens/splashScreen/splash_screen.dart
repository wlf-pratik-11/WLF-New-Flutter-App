import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/splashScreen/splash_screen_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late SplashScreenBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = SplashScreenBloc(context);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/wlf_logo.png",
          height: screenSizeRatio * 0.27,
          width: double.maxFinite,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: "${StringValues.WLF}\n",
                  style: GoogleFonts.nunito(
                      fontSize: screenSizeRatio * 0.03,
                      color: MyColors.mainColor.withOpacity(0.5),
                      fontWeight: FontWeight.bold)),
              TextSpan(
                text: StringValues.flutterNewApp,
                style: GoogleFonts.nunito(
                    fontSize: screenSizeRatio * 0.04, color: MyColors.mainColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
