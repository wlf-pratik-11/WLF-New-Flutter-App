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

AppBar commonAppbar(String title, {bool? centerTitle, List<Widget>? actions}) {
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
  );
}

Widget commonElevatedButton(
    {required String title, required Function? onPressed()}) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.mainColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(5))),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MyColors.buttonFontColor,
            fontSize: elevatedButtonFontSize),
      ));
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
            borderRadius: BorderRadiusDirectional.circular(5),
            color: Colors.white10),
        width: screenSizeRatio * 0.25,
        height: screenSizeRatio * 0.02,
      ));
}

Widget commonElevatedIconButton(
    {required String title,
    required Function? onPressed(),
    required Widget leading}) {
  return SizedBox(
    width: double.maxFinite,
    child: ElevatedButton.icon(
        icon: leading,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.lightBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(5))),
        label: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.darkBlue,
              fontSize: screenSizeRatio * 0.03),
        )),
  );
}

Widget inputField(String fieldName, TextEditingController controller,
    {Function(String value)? validator,
    bool showEyeIcon = false,
    bool? isPassword,
    Function()? onPressed,
    bool? isNumber,
    bool? readOnly,
    Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 15),
    child: TextFormField(
      onTap: () {
        return onTap?.call();
      },
      readOnly: readOnly ?? false,
      obscureText: isPassword ?? false,
      controller: controller,
      keyboardType:
          isNumber ?? false ? TextInputType.number : TextInputType.text,
      maxLength: isNumber ?? false ? 10 : null,
      decoration: InputDecoration(
        label: Text(
          fieldName,
          style:
              TextStyle(color: Colors.black, fontSize: screenSizeRatio * 0.03),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.black26, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
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
