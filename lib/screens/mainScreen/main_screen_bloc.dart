import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/googleSignInScreen/google_signin_screen.dart';

import '../../commons/drawer_dl.dart';
import '../../commons/common_functions.dart';
import '../../commons/my_colors.dart';
import '../firebaseCrudScreen/firebase_crud_screen.dart';
import '../googleMapScreen/location_detail_screen.dart';
import '../paginationScreen/pagination_screen.dart';
import '../selectImageFronCameraAndGallery/pick_image_camera_gallery.dart';
import '../tabBarScreen/tabbar_screen.dart';

class MainScreenBloc {
  final BuildContext context;
  MainScreenBloc(this.context){

  }
  final user = FirebaseAuth.instance.currentUser;

  List<DrawerDl> lst = [
    DrawerDl(TabBarScreen(), StringValues.tabBarDemo),
    DrawerDl(PickImageCameraGallery(), StringValues.pickImageFromCameraAndGalleryDemo),
    DrawerDl(PaginationScreen(), StringValues.paginationDemo),
    DrawerDl(FirebaseCrudScreen(), StringValues.firebaseCrudDemo),
    DrawerDl(LocationDetailScreen(), StringValues.googleMap),
  ];

  Future<void> signOut() async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(screenSizeRatio*0.01)),
          backgroundColor: MyColors.mainColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: paddingSymmetric(vertical: 0.025),
                child: Text(
                  StringValues.areYouWantToLogout,
                  style: TextStyle(color: Colors.white, fontSize: diologeFontSize, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: paddingSymmetric(vertical: 0.02, horizontal: 0.04),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(screenSizeRatio*0.01)),
                            backgroundColor: MyColors.buttonFontColor),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            await GoogleSignIn().signOut().then(
                              (value) {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GoogleSignInScreen(),
                                      ));
                                }
                              },
                            );
                          } catch (e) {
                            debugPrint(e.toString());
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
