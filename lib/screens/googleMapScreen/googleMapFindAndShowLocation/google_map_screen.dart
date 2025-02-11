import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';

import '../../../commons/my_colors.dart';
import '../../../commons/string_values.dart';
import '../location_detail_screen_dl.dart';
import 'google_map_screen_bloc.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapScreenBloc _bloc;
  List<Predictions> suggestedAddress = [];

  @override
  void didChangeDependencies() {
    _bloc = GoogleMapScreenBloc();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(StringValues.selectLocation),
      body: _buildBody(),
      floatingActionButton: getCurrentLocationFloatingActionButton(),
    );
  }

  _buildBody() {
    return Stack(
      children: [
        // Google Map as the Background
        Positioned.fill(
          child: googleMap(),
        ),

        // Search Field Positioned Below the AppBar
        Positioned(
          top: screenSizeRatio*0.015,
          left: screenSizeRatio*0.015,
          right: screenSizeRatio*0.015,
          child: locationSearchField(),
        ),

        // Address Suggestions Positioned Below the Search Field
        Positioned(
          top: kToolbarHeight+screenSizeRatio*0.03,// Adjust based on search field height
          left: screenSizeRatio*0.01,
          right: screenSizeRatio*0.01,
          child:  showSuggestionContainer(),
        ),

        // Confirm Location Button Positioned at the Bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: confirmLocationButton(),
        ),
      ],
    )
    ;
  }

  Widget googleMap(){
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _bloc.currentLocation, zoom: 15),
      zoomControlsEnabled: false,
      onMapCreated: _bloc.onMapCreated,
    );
  }

  Widget locationSearchField() {
    return StreamBuilder<List<Predictions>>(
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
        });
  }

  Widget showSuggestionContainer() {
    return StreamBuilder<bool>(
        stream: _bloc.showSuggestionsController,
        builder: (context, showSuggestionsSnapshot) {
          if (showSuggestionsSnapshot.data == true) {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: suggestedAddress.length < 5
                  ? suggestedAddress.length
                  : 5,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () async {
                      _bloc.saveAddressInTextFormField(
                          suggestedAddress[index].description);
                      await _bloc.navigateToLocation(
                          suggestedAddress[index].placeId,suggestedAddress[index].description);
                    },
                    child: Container(
                      padding: spaceSymmetric(
                          vertical: 0.03, horizontal: 0.03),
                      margin: spaceSymmetric(horizontal: 0.01),
                      color: Colors.white,
                      child: Text(
                        "${suggestedAddress[index].description}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: screenSizeRatio * 0.025,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
              },
            );
          } else {
            return Container();
          }
        });
  }

  Widget confirmLocationButton() {
    return Container(
      width: double.maxFinite,
      margin: spaceSymmetric(vertical: 0.02, horizontal: 0.13),
      height: screenSizeRatio * 0.08,
      child: commonElevatedButton(
          title: StringValues.confirmLocation,
          borderRadius: 15,
          onPressed: () {
            _bloc.confirmLocation(context);
            FocusScope.of(context).unfocus();
            return null;
          },
          bagColor: MyColors.mainColor,
          fontColors: Colors.white),
    );
  }

  Widget getCurrentLocationFloatingActionButton(){
    return FloatingActionButton.small(
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(5)),
      backgroundColor: MyColors.lightBlue,
      onPressed: () {
        _bloc.getCurrentLocation();
      },
      child: Icon(
        Icons.my_location_outlined,
        color: MyColors.darkBlue,
      ),
    );
  }

}
