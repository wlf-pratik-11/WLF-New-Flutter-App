import 'package:flutter/material.dart';

import 'my_colors.dart';

Size? screenSize;

initializeScreenSize(BuildContext context) {
  screenSize = MediaQuery.sizeOf(context);
}

var screenSizeRatio = (screenSize!.width + screenSize!.height) / 2;

var googleSignInScreenTitleFontSize = (screenSizeRatio * 0.035);
var buttonHeight = screenSizeRatio * 0.08;

AppBar commonAppbar(String title, {bool? centerTitle}) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: MyColors.mainColor,
    centerTitle: centerTitle ?? false,
    title: Text(
      title,
      style: TextStyle(fontSize: screenSizeRatio * 0.036, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}
