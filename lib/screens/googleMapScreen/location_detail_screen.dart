import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/googleMapFindAndShowLocation/google_map_screen.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/location_detail_screen_bloc.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/location_detail_screen_dl.dart';

class LocationDetailScreen extends StatefulWidget {
  const LocationDetailScreen({super.key});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  late LocationDetailScreenBloc _bloc;
  List<Predictions> suggestedAddress = [];

  @override
  void didChangeDependencies() {
    _bloc = LocationDetailScreenBloc();
    _bloc.getConfirmLocation();
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
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Current Location
                currentLocationContainer(),

                //Location Search
                locationSearchField(),

                // Address Suggestions
                StreamBuilder<bool>(
                    stream: _bloc.showSuggestionsController,
                    builder: (context, showSuggestionsSnapshot) {
                      if (showSuggestionsSnapshot.data == true) {
                        return ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    _bloc.saveAddressInTextFormField(suggestedAddress[index].description);
                                  },
                                  child: ListTile(title: Text("${suggestedAddress[index].description}")));
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            itemCount: suggestedAddress.length < 5 ? suggestedAddress.length : 5);
                      } else {
                        return Container();
                      }
                    }),

                //Get Current Location
                buttonContainer(
                    value: StringValues.getCurrentLocation,
                    onTap: () {
                      _bloc.getCurrentLocation();
                    },
                    leadingIcon: Icon(
                      Icons.my_location,
                      color: MyColors.mainColor,
                    )),

                //Set Location From Map
                buttonContainer(
                    value: StringValues.setLocationFromMap,
                    onTap: () {
                      navigatorPush(context, GoogleMapScreen());
                    },
                    leadingIcon: Icon(
                      Icons.map_outlined,
                      color: MyColors.mainColor,
                    ),
                    trailingIcon: Icon(
                      Icons.navigate_next,
                      color: MyColors.mainColor,
                    )),

                //Saved Location
                savedLocation(),
              ],
            ),
          ),
        ),

        //Confirm Location Button
        confirmLocationButton()
      ],
    );
  }

  //My Current Location Container
  Widget currentLocationContainer() {
    return Container(
      margin: paddingSymmetric(horizontal: 0.01, vertical: 0.01),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: MyColors.lightBlue.withOpacity(0.5),
          borderRadius: BorderRadiusDirectional.circular(15),
          border: Border.all(color: MyColors.mainColor)),
      child: Column(
        children: [
          Padding(
            padding: paddingSymmetric(horizontal: 0.02, vertical: 0.02),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.black,
                  size: screenSizeRatio * 0.05,
                ),
                Padding(
                  padding: paddingSymmetric(horizontal: 0.018),
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
            padding: paddingSymmetric(horizontal: 0.03, vertical: 0.02),
            child: StreamBuilder<String>(
                stream: _bloc.confirmLocationController,
                builder: (context, confirmLocationSnapshot) {
                  return Text(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    "${confirmLocationSnapshot.data}",
                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: screenSizeRatio * 0.025),
                  );
                }),
          )
        ],
      ),
    );
  }

  //Location Search Field
  Widget locationSearchField() {
    return Padding(
      padding: paddingSymmetric(vertical: 0.02, horizontal: 0.01),
      child: StreamBuilder<List<Predictions>>(
          stream: _bloc.suggestionsListController,
          builder: (context, suggestionsListSnapshot) {
            return TextFormField(
              controller: _bloc.searchLocationInputFieldController,
              onChanged: (value) async {
                await _bloc.getSuggestions(value);
                suggestedAddress = suggestionsListSnapshot.data ?? [];
                _bloc.showSuggestionsController.sink.add(suggestionsListSnapshot.data != []);
              },
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                labelText: StringValues.searchLocation,
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
            );
          }),
    );
  }

  //Get Current Location and Set location from map button
  Widget buttonContainer({required String value, required Function() onTap, required Icon leadingIcon, Icon? trailingIcon}) {
    return Padding(
      padding: paddingSymmetric(vertical: 0.02, horizontal: 0.01),
      child: ListTile(
        titleTextStyle: GoogleFonts.nunito(
          textStyle: TextStyle(color: MyColors.mainColor, fontSize: screenSizeRatio * 0.028, fontWeight: FontWeight.w700),
        ),
        onTap: onTap,
        title: Text(value),
        leading: leadingIcon,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10), side: BorderSide(color: MyColors.mainColor)),
        trailing: trailingIcon,
      ),
    );
  }

  //Saved Addresses List
  Widget savedLocation() {
    return Container(
      margin: paddingSymmetric(horizontal: 0.01, vertical: 0.015),
      width: double.maxFinite,
      decoration:
          BoxDecoration(borderRadius: BorderRadiusDirectional.circular(10), border: Border.all(color: MyColors.mainColor)),
      child: Column(
        children: [
          ListTile(
            tileColor: MyColors.lightBlue.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            leading: Icon(
              Icons.home_outlined,
              color: MyColors.mainColor,
              size: screenSizeRatio * 0.045,
            ),
            title: Text(
              StringValues.savedAddresses,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenSizeRatio * 0.03,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ListView.separated(
              physics: NeverScrollableScrollPhysics(),
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

  //Confirm Location Button
  Widget confirmLocationButton() {
    return Container(
      width: double.maxFinite,
      margin: paddingSymmetric(vertical: 0.02, horizontal: 0.03),
      height: screenSizeRatio * 0.08,
      child: commonElevatedButton(
          borderRadius: 15,
          title: StringValues.confirmLocation,
          onPressed: () {
            _bloc.confirmLocation();
            FocusScope.of(context).unfocus();
            // return null;
          },
          bagColor: MyColors.mainColor,
          fontColors: Colors.white),
    );
  }
}
