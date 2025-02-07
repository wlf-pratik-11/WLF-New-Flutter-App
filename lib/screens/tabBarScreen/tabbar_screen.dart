import 'package:flutter/material.dart';

import '../../commons/common_functions.dart';
import '../../commons/my_colors.dart';
import '../../commons/string_values.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _appBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(children: [
      Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
              backgroundColor: MyColors.mainColor,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    width: double.maxFinite,
                    height: screenSizeRatio * 0.2,
                    color: MyColors.mainColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: screenSizeRatio * 0.03),
                          child: Text(
                            StringValues.bottomSheetDemo,
                            style: TextStyle(fontSize: screenSizeRatio * 0.03, color: Colors.white),
                          ),
                        ),
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              StringValues.confirm,
                              style: TextStyle(color: MyColors.buttonFontColor, fontSize: diologeButtonFontSize),
                            ))
                      ],
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.all(screenSizeRatio * 0.02),
              child: Text(
                StringValues.showBottomSheet,
                style: TextStyle(color: MyColors.buttonFontColor, fontSize: screenSizeRatio * 0.03),
              ),
            )),
      ),
      Icon(Icons.local_fire_department_outlined),
      Icon(Icons.account_circle_outlined),
    ]);
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: MyColors.mainColor,
      title: Text(
        StringValues.tabBarDemo,
        style: TextStyle(fontSize: screenSizeRatio * 0.036, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      bottom: _tabBar(),
    );
  }

  TabBar _tabBar() {
    return TabBar(
      tabs: [
        Tab(
          icon: Icon(
            Icons.account_balance,
            color: Colors.white,
          ),
          child: Text(
            StringValues.tab1,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.local_fire_department_outlined,
            color: Colors.white,
          ),
          child: Text(
            StringValues.tab2,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.account_circle_outlined,
            color: Colors.white,
          ),
          child: Text(
            StringValues.tab3,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
