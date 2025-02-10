import 'package:flutter/material.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';

class LocationDetailScreen extends StatefulWidget {
  const LocationDetailScreen({super.key});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(StringValues.googleMap),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        currentLocationContainer(),
        getCurrentLocationButton(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.01, vertical: screenSizeRatio * 0.015),
          width: double.maxFinite,
          height: screenSizeRatio * 0.5,
          decoration:
              BoxDecoration(borderRadius: BorderRadiusDirectional.circular(10), border: Border.all(color: MyColors.mainColor)),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(10),
                  color: MyColors.lightBlue,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.home_outlined,
                      color: MyColors.mainColor,
                    ),
                    Text(StringValues.savedAddresses),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget currentLocationContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.01, vertical: screenSizeRatio * 0.01),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: MyColors.lightBlue,
          borderRadius: BorderRadiusDirectional.circular(15),
          border: Border.all(color: MyColors.mainColor)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.02, vertical: screenSizeRatio * 0.02),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.black,
                  size: screenSizeRatio * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.018),
                  child: Text(
                    StringValues.myLocation,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenSizeRatio * 0.028,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ),
          Center(
              child: Divider(
            color: Colors.white,
            thickness: 2,
          )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.03, vertical: screenSizeRatio * 0.02),
            child: Text(
              "shital park arti sheetal park, puneet nagar, bajrang wadi, rajkot, gujarat,",
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: screenSizeRatio * 0.025),
            ),
          )
        ],
      ),
    );
  }

  Widget getCurrentLocationButton() {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.02, horizontal: screenSizeRatio * 0.01),
      elevation: 5,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10), side: BorderSide(color: MyColors.mainColor)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.03, vertical: screenSizeRatio * 0.02),
        child: Row(
          children: [
            Icon(
              Icons.my_location,
              color: MyColors.mainColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.02),
              child: Text(
                StringValues.getCurrentLocation,
                style: TextStyle(color: MyColors.mainColor, fontSize: screenSizeRatio * 0.028, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
