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
      floatingActionButton: FloatingActionButton.small(
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(5)),
        backgroundColor: MyColors.lightBlue,
        onPressed: () {
          _bloc.getCurrentLocation();
        },
        child: Icon(
          Icons.my_location_outlined,
          color: MyColors.darkBlue,
        ),
      ),
    );
  }

  _buildBody() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        GoogleMap(
          initialCameraPosition: _bloc.kGooglePlex,
          zoomControlsEnabled: false,
          onCameraIdle: () {},
          onMapCreated: (GoogleMapController controller) {
            _bloc.mapController.complete(controller);
          },
        ),

        //Search Input Field and Confirm Location Button
        searchFieldAndConfirmLocationButton()
      ],
    );
  }

  Widget locationSearchField() {
    return Padding(
      padding: spaceSymmetric(vertical: 0.02, horizontal: 0.01),
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

  Widget confirmLocationButton() {
    return Container(
      width: double.maxFinite,
      margin: spaceSymmetric(vertical: 0.02, horizontal: 0.13),
      height: screenSizeRatio * 0.08,
      child: commonElevatedButton(
          title: StringValues.confirmLocation,
          borderRadius: 15,
          onPressed: () {
            FocusScope.of(context).unfocus();
            return null;
          },
          bagColor: MyColors.mainColor,
          fontColors: Colors.white),
    );
  }

  Widget searchFieldAndConfirmLocationButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Location Search Field
                locationSearchField(),

                // Address Suggestions
                StreamBuilder<bool>(
                    stream: _bloc.showSuggestionsController,
                    builder: (context, showSuggestionsSnapshot) {
                      if (showSuggestionsSnapshot.data == true) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: suggestedAddress.length < 5 ? suggestedAddress.length : 5,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () async {
                                  _bloc.saveAddressInTextFormField(suggestedAddress[index].description);
                                  await _bloc.navigateToLocation(suggestedAddress[index].placeId);
                                },
                                child: ListTile(
                                  title: Text(
                                    "${suggestedAddress[index].description}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ));
                          },
                        );
                      } else {
                        return Container();
                      }
                    }),
              ],
            ),
          ),
        ),

        //Confirm Location
        confirmLocationButton(),
      ],
    );
  }
}
