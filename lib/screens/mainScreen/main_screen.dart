import 'package:flutter/material.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';

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
    _bloc = MainScreenBloc(context);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          commonAppbar(StringValues.mainScreen, centerTitle: true, actions: [
        IconButton(
          onPressed: () {
            _bloc.signOut();
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
        style: TextStyle(
            fontSize: screenSizeRatio * 0.04, fontWeight: FontWeight.bold),
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
                  padding: paddingSymmetric(vertical: 0.01, horizontal: 0.01),
                  child: ClipRRect(
                    borderRadius: BorderRadiusDirectional.circular(100),
                    child: Image(
                      height: screenSizeRatio * 0.09,
                      image: NetworkImage(
                        _bloc.user != null
                            ? _bloc.user!.photoURL.toString()
                            : "https://img.freepik.com/premium-photo/happy-man-ai-generated-portrait-user-profile_1119669-1.jpg",
                      ),
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: paddingSymmetric(horizontal: 0.01),
                  child: Text(
                    _bloc.user != null
                        ? _bloc.user!.displayName.toString()
                        : "Pratik Tank",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: paddingSymmetric(vertical: 0.01, horizontal: 0.01),
                  child: Text(
                      _bloc.user != null
                          ? _bloc.user!.email.toString()
                          : "tankpratik112@gmail.com",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
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
              itemCount: _bloc.lst.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    navigatorPop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _bloc.lst[index].screenName,
                        ));
                  },
                  child: ListTile(
                    title: Text(
                      _bloc.lst[index].screenTitle,
                      style: TextStyle(
                          color: MyColors.mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: screenSizeRatio * 0.025),
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
