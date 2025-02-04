import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/screens/googleSignInScreen/google_signin_screen.dart';

import '../../commons/DrawerDl.dart';
import '../googleSignInScreen/google_signin_screen_bloc.dart';
import '../tabBarScreen/tabbar_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<DrawerDl> lst = [
    DrawerDl(MainScreen(), "Main Screen Demo"),
    DrawerDl(TabbarScreen(), "Tab bar Demo"),
    DrawerDl(MainScreen(), "Main Screen Demo"),
    DrawerDl(MainScreen(), "Main Screen Demo"),
  ];
  GoogleSigninScreenBloc _bloc = GoogleSigninScreenBloc();
  final _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar("Main Screen", centerTitle: true),
      drawer: Drawer(
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
                          image: NetworkImage(_user != null
                              ? _user.photoURL.toString()
                              : "https://img.freepik.com/premium-photo/happy-man-ai-generated-portrait-user-profile_1119669-1.jpg")),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.01),
                    child: Text(
                      _user != null ? _user.displayName.toString() : "Pratik Tank",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.01, horizontal: screenSizeRatio * 0.01),
                    child: Text(_user != null ? _user.email.toString() : "tankpratik112@gmail.com",
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
                        style:
                            TextStyle(color: MyColors.mainColor, fontWeight: FontWeight.bold, fontSize: screenSizeRatio * 0.025),
                      ),
                      tileColor: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.yellow,
        child: Center(
          child: TextButton(
              onPressed: () async {
                if (await _bloc.signOut()) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoogleSigninScreen(),
                      ));
                } else {
                  print("Failed to log out");
                }
              },
              child: Text("Sign Out")),
        ),
      ),
    );
  }
}
