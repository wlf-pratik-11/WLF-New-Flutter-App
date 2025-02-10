import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/location_detail_screen_bloc.dart';

class LocationDetailScreen extends StatefulWidget {
  const LocationDetailScreen({super.key});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  late LocationDetailScreenBloc _bloc;
  @override
  void didChangeDependencies() {
    _bloc = LocationDetailScreenBloc();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(StringValues.googleMap),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          currentLocationContainer(),

          locationSearchField(),

          buttonContainer(value: StringValues.getCurrentLocation, onTap: () {
          },leadingIcon: Icon(
            Icons.my_location,
            color: MyColors.mainColor,
          ),trailingIcon: Icon(Icons.navigate_next,
            color: MyColors.mainColor,)),

          buttonContainer(value: StringValues.setLocationFromMap, onTap: () {
          },leadingIcon: Icon(
            Icons.map_outlined,
            color: MyColors.mainColor,
          ),trailingIcon: Icon(Icons.navigate_next,
            color: MyColors.mainColor,)),

          savedLocation()

        ],
      ),
    );
  }

  Widget currentLocationContainer() {
    return Container(
      margin: spaceSymmetric(horizontal: 0.01, vertical: 0.01),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: MyColors.lightBlue,
          borderRadius: BorderRadiusDirectional.circular(15),
          border: Border.all(color: MyColors.mainColor)),
      child: Column(
        children: [
          Padding(
            padding: spaceSymmetric(horizontal: 0.02, vertical: 0.02),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.black,
                  size: screenSizeRatio * 0.05,
                ),
                Padding(
                  padding: spaceSymmetric(horizontal: 0.018),
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
            padding: spaceSymmetric(horizontal: 0.03, vertical: 0.02),
            child: Text(
              "shital park arti sheetal park, puneet nagar, bajrang wadi, rajkot, gujarat,",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: screenSizeRatio * 0.025),
            ),
          )
        ],
      ),
    );
  }

  Widget locationSearchField(){
    return Padding(
      padding:spaceSymmetric(vertical: 0.02,horizontal: 0.01),
      child: TextFormField(
        onChanged: (value) {

        },
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
          labelText: "Search Location",
          labelStyle: TextStyle(color: MyColors.darkBlue, fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Colors.white,
          prefixIconConstraints: BoxConstraints(maxHeight: screenSizeRatio * 0.05),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.025),
            child: Icon(Icons.search),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.mainColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.darkBlue, width: 2),
          ),
        ),
      ),
    );
  }

  Widget buttonContainer({required String value,required Function() onTap,required Icon leadingIcon,required Icon trailingIcon}) {
    return Padding(
      padding: spaceSymmetric(vertical: 0.02, horizontal: 0.01),
      child: ListTile(
        titleTextStyle: GoogleFonts.nunito(textStyle:TextStyle(
            color: MyColors.mainColor,
            fontSize: screenSizeRatio * 0.028,
            fontWeight: FontWeight.w700), ),
        onTap: onTap,
        title: Text(value),
        leading: leadingIcon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10),side: BorderSide(color: MyColors.mainColor)),
        trailing: trailingIcon,

      ),

    );
  }

  Widget savedLocation(){
    return Container(
      margin: spaceSymmetric(horizontal: 0.01, vertical: 0.015),
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10),
          border: Border.all(color: MyColors.mainColor)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(10),
              color: MyColors.lightBlue,
            ),
            padding: spaceSymmetric(vertical: 0.03, horizontal: 0.025),
            child: Row(
              children: [
                Icon(
                  Icons.home_outlined,
                  color: MyColors.mainColor,
                  size: screenSizeRatio * 0.045,
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSizeRatio * 0.02),
                  child: Text(
                    StringValues.savedAddresses,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenSizeRatio * 0.03,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(title: Text("Address $index"));
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: 3)
        ],
      ),
    );
  }
}
