import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/saved_address_dl.dart';

import '../../commons/common_functions.dart';
import '../../commons/my_colors.dart';
import '../../commons/string_values.dart';
import 'location_detail_screen_bloc.dart';
import 'location_detail_screen_dl.dart';

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
    _bloc = LocationDetailScreenBloc(context);
    _bloc.getConfirmLocation();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: commonAppbar(StringValues.googleMap),
        body: _buildBody(),
      ),
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
                //Location Search
                locationSearchField(),

                // showSuggestionsContainer(),
                StreamBuilder<bool>(
                    stream: _bloc.showSuggestionsController,
                    builder: (context, showSuggestionsSnapshot) {
                      if (showSuggestionsSnapshot.data == true) {
                        return ListView(
                          padding: paddingSymmetric(horizontal: 0.025),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () async {
                                        _bloc.saveAddressInTextFormField(
                                          SavedAddressDl(
                                              latLng: (await _bloc.getLatLngFromPlaceID(
                                                suggestedAddress[index].placeId,
                                              )),
                                              address: suggestedAddress[index].description ?? ""),
                                        );
                                      },
                                      child: ListTile(title: Text("${suggestedAddress[index].description}")));
                                },
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                                itemCount: suggestedAddress.length < 5 ? suggestedAddress.length : 5),

                            //Set Location From Map
                            ListTile(
                              onTap: () {
                                _bloc.getLocationFromMap();
                              },
                              leading: Icon(
                                Icons.map_outlined,
                                color: MyColors.mainColor,
                              ),
                              title: Text(StringValues.setLocationFromMap),
                              trailing: Icon(
                                Icons.navigate_next,
                                color: MyColors.mainColor,
                              ),
                            )
                          ],
                        );
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
                  ),
                ),

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
                  padding: paddingSymmetric(horizontal: 0.025),
                  child: Icon(Icons.search),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenSizeRatio * 0.01),
                  borderSide: BorderSide(color: MyColors.darkBlue.withOpacity(0.5), width: screenSizeRatio * 0.005),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenSizeRatio * 0.01),
                  borderSide: BorderSide(color: MyColors.darkBlue, width: screenSizeRatio * 0.005),
                ),
              ),
            );
          }),
    );
  }

  //show suggestions
  showSuggestionsContainer() {
    return StreamBuilder<bool>(
        stream: _bloc.showSuggestionsController,
        builder: (context, showSuggestionsSnapshot) {
          if (showSuggestionsSnapshot.data == true) {
            return ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () async {
                            _bloc.saveAddressInTextFormField(
                              SavedAddressDl(
                                  latLng: (await _bloc.getLatLngFromPlaceID(
                                    suggestedAddress[index].placeId,
                                  )),
                                  address: suggestedAddress[index].description ?? ""),
                            );
                          },
                          child: ListTile(title: Text("${suggestedAddress[index].description}")));
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: suggestedAddress.length < 5 ? suggestedAddress.length : 5),
                //Set Location From Map
                buttonContainer(
                  value: StringValues.setLocationFromMap,
                  onTap: () {
                    _bloc.getLocationFromMap();
                  },
                  leadingIcon: Icon(
                    Icons.map_outlined,
                    color: MyColors.mainColor,
                  ),
                  trailingIcon: Icon(
                    Icons.navigate_next,
                    color: MyColors.mainColor,
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        });
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
            borderRadius: BorderRadiusDirectional.circular(screenSizeRatio * 0.01), side: BorderSide(color: MyColors.mainColor)),
        trailing: trailingIcon,
      ),
    );
  }

  // Saved Addresses List
  Widget savedLocation() {
    return Container(
      margin: paddingSymmetric(horizontal: 0.01, vertical: 0.015),
      width: double.maxFinite,
      decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.circular(screenSizeRatio * 0.01)),
      child: Column(
        children: [
          ListTile(
            tileColor: MyColors.lightBlue.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(screenSizeRatio * 0.01),
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
          StreamBuilder<List<String>>(
              stream: _bloc.savedAddressListController,
              builder: (context, savedAddressListSnapshot) {
                return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            _bloc.saveAddressInTextFormField(
                              SavedAddressDl(
                                  address: jsonDecode(savedAddressListSnapshot.data?[index] ?? "")["address"],
                                  latLng: jsonDecode(savedAddressListSnapshot.data?[index] ?? "")["latLng"]),
                            );
                          },
                          title: Text("${jsonDecode(savedAddressListSnapshot.data?[index] ?? "")["address"]}"));
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: savedAddressListSnapshot.data?.length ?? 4);
              })
        ],
      ),
    );
  }

  // Confirm Location Button
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
          },
          bagColor: MyColors.mainColor,
          fontColors: Colors.white),
    );
  }
}
