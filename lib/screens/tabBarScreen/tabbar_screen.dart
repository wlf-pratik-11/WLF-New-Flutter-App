import 'package:flutter/material.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';

import '../../commons/my_colors.dart';

class TabbarScreen extends StatefulWidget {
  const TabbarScreen({super.key});

  @override
  State<TabbarScreen> createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: MyColors.mainColor,
          title: Text(
            "Tab Bar Demo",
            style: TextStyle(fontSize: screenSizeRatio * 0.036, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.account_balance,
                  color: Colors.white,
                ),
                child: Text(
                  "Tab 1",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.local_fire_department_outlined,
                  color: Colors.white,
                ),
                child: Text(
                  "Tab 2",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                ),
                child: Text(
                  "Tab 3",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Icon(Icons.account_balance),
          Icon(Icons.local_fire_department_outlined),
          Icon(Icons.account_circle_outlined),
        ]),
      ),
    );
  }
}
