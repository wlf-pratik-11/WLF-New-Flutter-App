import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'my_colors.dart';

Size? screenSize;

initializeScreenSize(BuildContext context) {
  screenSize = MediaQuery.sizeOf(context);
}

var screenSizeRatio = (screenSize!.width + screenSize!.height) / 2;

var googleSignInScreenTitleFontSize = (screenSizeRatio * 0.035);
var buttonHeight = screenSizeRatio * 0.08;
var diologeFontSize = screenSizeRatio * 0.03;
var diologeButtonFontSize = screenSizeRatio * 0.025;
var snakBarFontSize = screenSizeRatio * 0.025;
var elevatedButtonFontSize = screenSizeRatio * 0.037;

AppBar commonAppbar(String title,
    {bool? centerTitle, List<Widget>? actions, TabBar? bottom}) {
  return AppBar(
    actions: actions,
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: MyColors.mainColor,
    centerTitle: centerTitle ?? false,
    title: Text(
      title,
      style: TextStyle(
          fontSize: screenSizeRatio * 0.036,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    ),
    bottom: bottom,
  );
}

Widget commonElevatedButton(
    {required String title,
    required Function()? onPressed,
    Color? bagColor,
    Color? fontColors,
    double? borderRadius,
    Widget? leading}) {
  return leading == null
      ? ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: bagColor ?? MyColors.mainColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(
                      borderRadius ?? screenSizeRatio * 0.01))),
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: fontColors ?? MyColors.buttonFontColor,
                fontSize: elevatedButtonFontSize),
          ))
      : SizedBox(
          width: double.maxFinite,
          child: ElevatedButton.icon(
              icon: leading,
              onPressed: () {
                onPressed?.call();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.lightBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(
                          screenSizeRatio * 0.01))),
              label: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MyColors.darkBlue,
                    fontSize: screenSizeRatio * 0.03),
              )),
        );
  ;
}

TextStyle paginationListViewItemTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: screenSizeRatio * 0.025,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis);
}

Widget textPlaceHolderShimmerEffect() {
  return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.white10,
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadiusDirectional.circular(screenSizeRatio * 0.01),
            color: Colors.white10),
        width: screenSizeRatio * 0.25,
        height: screenSizeRatio * 0.02,
      ));
}

Widget inputField(String fieldName, TextEditingController controller,
    {Function(String value)? validator,
    bool showEyeIcon = false,
    Widget? prefix,
    bool? isPassword,
    Function()? onPressed,
    Function()? onChanged,
    int? maxLength,
    bool? isNumber,
    bool? readOnly,
    Function()? onTap}) {
  return Padding(
    padding: paddingSymmetric(horizontal: 0.04, vertical: 0.02),
    child: TextFormField(
      onChanged: (value) => onChanged?.call(),
      onTap: () => onTap?.call(),
      readOnly: readOnly ?? false,
      obscureText: isPassword ?? false,
      controller: controller,
      keyboardType:
          isNumber ?? false ? TextInputType.number : TextInputType.text,
      maxLength: isNumber ?? false ? maxLength : null,
      decoration: InputDecoration(
        prefixIcon: prefix,
        label: Text(
          fieldName,
          style:
              TextStyle(color: Colors.black, fontSize: screenSizeRatio * 0.03),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenSizeRatio * 0.01),
          borderSide: BorderSide(color: Colors.black26, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenSizeRatio * 0.01),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenSizeRatio * 0.01),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenSizeRatio * 0.01),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
        suffixIcon: showEyeIcon
            ? IconButton(
                color: Colors.black38,
                icon: Icon(Icons.remove_red_eye_outlined),
                onPressed: () {
                  onPressed?.call();
                },
                splashRadius: 5,
                highlightColor: Colors.deepPurpleAccent.withOpacity(0.3),
              )
            : null,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return validator?.call(value ?? "");
      },
    ),
  );
}

navigatorPush(BuildContext context, Widget screenName) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screenName,
      ));
}

navigatorPop(BuildContext context) {
  return Navigator.pop(context);
}

paddingSymmetric({double? vertical, double? horizontal}) {
  return EdgeInsetsDirectional.symmetric(
      vertical: screenSizeRatio * (vertical ?? 0),
      horizontal: screenSizeRatio * (horizontal ?? 0));
}
