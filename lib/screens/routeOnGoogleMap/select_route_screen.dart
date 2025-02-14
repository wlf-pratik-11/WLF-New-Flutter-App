import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/routeOnGoogleMap/confimRouteScreen/confirm_route_screen.dart';
import 'package:wlf_new_flutter_app/screens/routeOnGoogleMap/googleMapRouteScreen/google_map_route_screen.dart';
import 'package:wlf_new_flutter_app/screens/routeOnGoogleMap/select_route_screen_bloc.dart';

import '../../commons/my_colors.dart';
import '../googleMapScreen/location_detail_screen_dl.dart';
import '../googleMapScreen/saved_address_dl.dart';

class SelectRouteScreen extends StatefulWidget {
  const SelectRouteScreen({super.key});

  @override
  State<SelectRouteScreen> createState() => _SelectRouteScreenState();
}

class _SelectRouteScreenState extends State<SelectRouteScreen> {
  late SelectRouteScreenBloc _bloc;
  List<Predictions> suggestedAddress = [];

  @override
  void didChangeDependencies() {
    _bloc = SelectRouteScreenBloc(context);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: commonAppbar(StringValues.selectRoute),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return StreamBuilder<List<Predictions>>(
        stream: _bloc.suggestionsListController,
        builder: (context, suggestionsListSnapshot) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: StreamBuilder<bool>(
                      stream: _bloc.inputFieldOnOffStatusController,
                      builder: (context, inputFieldOnOffStatusSnapshot) {
                        return Column(
                          children: [
                            inputField(
                              "Pickup Location",
                              _bloc.pickupLocationController,
                              onChanged: (value) async {
                                print("Value field is on");
                                await _bloc.getSuggestions(value ?? "");
                                suggestedAddress = suggestionsListSnapshot.data ?? [];
                                _bloc.showSuggestionsController.sink.add(suggestionsListSnapshot.data != []);
                                _bloc.inputFieldOnOffStatusController.sink.add(false);
                              },
                            ),
                            inputField(
                              "Drop Location",
                              _bloc.dropLocationController,
                              onChanged: (value) async {
                                await _bloc.getSuggestions(value ?? "");
                                suggestedAddress = suggestionsListSnapshot.data ?? [];
                                _bloc.inputFieldOnOffStatusController.sink.add(true);
                                _bloc.showSuggestionsController.sink.add(suggestionsListSnapshot.data != []);
                              },
                              onEditingComplete: () => _bloc.inputFieldOnOffStatusController.sink.add(false),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            showSuggestionsContainer(
                                textField: inputFieldOnOffStatusSnapshot.data == false
                                    ? _bloc.pickupLocationController
                                    : _bloc.dropLocationController),
                          ],
                        );
                      }),
                ),
              ),

              //Confirm Button
              Container(
                margin: paddingSymmetric(horizontal: 0.02, vertical: 0.03),
                width: double.maxFinite,
                height: screenSizeRatio * 0.08,
                child: commonElevatedButton(
                    title: "Confirm Address",
                    onPressed: () {
                      if (_bloc.origin.latLng == null || _bloc.destination.latLng == null) {
                        final snackBar = SnackBar(
                          content: Text(
                            "Select Location..!!!",
                            style: TextStyle(
                                color: MyColors.buttonFontColor, fontSize: snakBarFontSize, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: MyColors.mainColor,
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        navigatorPush(
                          context,
                          ConfirmRouteScreen(
                            origin: _bloc.origin,
                            destination: _bloc.destination,
                          ),
                        );
                      }
                    },
                    borderRadius: screenSizeRatio * 0.03),
              ),
            ],
          );
        });
  }

  //show suggestions
  showSuggestionsContainer({required TextEditingController textField}) {
    return StreamBuilder<bool>(
        stream: _bloc.showSuggestionsController,
        builder: (context, showSuggestionsSnapshot) {
          if (showSuggestionsSnapshot.data == true) {
            return ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListView.separated(
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
                                textField: textField);
                          },
                          child: ListTile(
                            title: Text("${suggestedAddress[index].description}"),
                            leading: Icon(
                              Icons.location_on_outlined,
                              color: Colors.black,
                            ),
                          ));
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: suggestedAddress.length < 5 ? suggestedAddress.length : 5),

                //Set Location From Map
                buttonContainer(
                  value: StringValues.setLocationFromMap,
                  onTap: () async {
                    SavedAddressDl savedAddressDl = await navigatorPush(
                      context,
                      GoogleMapRouteScreen(),
                    );
                    _bloc.inputFieldOnOffStatusController.value == false
                        ? _bloc.origin = savedAddressDl
                        : _bloc.destination = savedAddressDl;
                    _bloc.inputFieldOnOffStatusController.value == false
                        ? _bloc.pickupLocationController.text = savedAddressDl.address.toString()
                        : _bloc.dropLocationController.text = savedAddressDl.address.toString();

                    _bloc.showSuggestionsController.sink.add(false);
                    print("Location from map :::::${savedAddressDl.address}");
                  },
                  leadingIcon: Icon(
                    Icons.map_outlined,
                    color: Colors.black,
                  ),
                  trailingIcon: Icon(
                    Icons.navigate_next,
                    color: Colors.black,
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
        trailing: trailingIcon,
      ),
    );
  }
}
