import 'package:flutter/material.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/firebaseCrudScreen/firebase_crud_screen.dart';
import 'package:wlf_new_flutter_app/screens/paginationScreen/pagination_screen.dart';
import 'package:wlf_new_flutter_app/screens/tabBarScreen/tabbar_screen.dart';

import '../../commons/DrawerDl.dart';
import '../googleMapScreen/location_detail_screen.dart';
import '../selectImageFronCameraAndGallery/pick_image_camera_gallery.dart';
import 'main_screen_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainScreenBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = MainScreenBloc();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  List<DrawerDl> lst = [
    DrawerDl(TabBarScreen(), StringValues.tabBarDemo),
    DrawerDl(PickImageCameraGallery(), StringValues.pickImageFromCameraAndGalleryDemo),
    DrawerDl(PaginationScreen(), StringValues.paginationDemo),
    DrawerDl(FirebaseCrudScreen(), StringValues.firebaseCrudDemo),
    DrawerDl(LocationDetailScreen(), StringValues.googleMap),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(StringValues.mainScreen, centerTitle: true, actions: [
        IconButton(
          onPressed: () {
            _bloc.signOut(context);
          },
          icon: Icon(Icons.logout),
          padding: EdgeInsets.all(screenSizeRatio * 0.02),
        )
      ]),
      drawer: _drawer(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Text(
        StringValues.welcomeToOurApp,
        style: TextStyle(fontSize: screenSizeRatio * 0.04, fontWeight: FontWeight.bold),
      ),
    );
  }

  Drawer _drawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // DrawerHeader with Image UserName and Email
          DrawerHeader(
            decoration: BoxDecoration(color: MyColors.mainColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.01, horizontal: screenSizeRatio * 0.01),
                  child: ClipRRect(
                    borderRadius: BorderRadiusDirectional.circular(100),
                    child: Image(
                        height: screenSizeRatio * 0.09,
                        image: NetworkImage(_bloc.user != null
                            ? _bloc.user!.photoURL.toString()
                            : "https://img.freepik.com/premium-photo/happy-man-ai-generated-portrait-user-profile_1119669-1.jpg")),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.01),
                  child: Text(
                    _bloc.user != null ? _bloc.user!.displayName.toString() : "Pratik Tank",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.01, horizontal: screenSizeRatio * 0.01),
                  child: Text(_bloc.user != null ? _bloc.user!.email.toString() : "tankpratik112@gmail.com",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsetsDirectional.only(top: 0),
              separatorBuilder: (context, index) => Divider(),
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: lst.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => lst[index].screenName,
                        ));
                  },
                  child: ListTile(
                    title: Text(
                      "${lst[index].screenTitle}",
                      style: TextStyle(color: MyColors.mainColor, fontWeight: FontWeight.bold, fontSize: screenSizeRatio * 0.025),
                    ),
                    tileColor: Colors.white,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
