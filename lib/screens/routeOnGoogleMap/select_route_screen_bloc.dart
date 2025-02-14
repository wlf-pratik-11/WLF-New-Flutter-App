import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:wlf_new_flutter_app/screens/routeOnGoogleMap/googleMapRouteScreen/google_map_route_screen.dart';

import '../../commons/common_functions.dart';
import '../googleMapScreen/location_detail_screen_dl.dart';
import '../googleMapScreen/location_latlng_dl.dart';
import '../googleMapScreen/saved_address_dl.dart';

class SelectRouteScreenBloc {
  final BuildContext context;
  SelectRouteScreenBloc(this.context);

  var uuid = Uuid();
  var dio = Dio();
  late SavedAddressDl savedAddressDl = SavedAddressDl();
  late SavedAddressDl origin = SavedAddressDl();
  late SavedAddressDl destination = SavedAddressDl();
  String apiKey = "AIzaSyBGJ8mEq1C8Kn4mWY-ds6jDfsr7O8-JNGk";

  final showSuggestionsController = BehaviorSubject<bool>.seeded(false);
  final inputFieldOnOffStatusController = BehaviorSubject<bool>.seeded(false);
  final suggestionsListController = BehaviorSubject<List<Predictions>>();
  final savedAddressListController = BehaviorSubject<List<String>>();

  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController dropLocationController = TextEditingController();

  Future<List<Predictions>> getSuggestions(String input) async {
    final sessionToken = uuid.v4();
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$apiKey&sessiontoken=$sessionToken';
    var response = await dio.get(request);
    if (response.statusCode == 200) {
      final data = LocationDetailScreenDl.fromJson(response.data);
      List<Predictions>? addressList = data.predictions;
      suggestionsListController.sink.add(addressList ?? []);
    } else {
      debugPrint('Failed to load predictions');
    }
    return [];
  }

  void saveAddressInTextFormField(SavedAddressDl data, {required TextEditingController textField}) {
    textField.text = data.address.toString();
    savedAddressDl = data;
    inputFieldOnOffStatusController.value == false ? (origin = savedAddressDl) : (destination = savedAddressDl);
    showSuggestionsController.sink.add(false);
  }

  Future<List<double>> getLatLngFromPlaceID(String? placeID) async {
    String url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=$apiKey";
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      var data = response.data["result"]["geometry"]["location"];
      final latLon = LocationLatLonDl.fromJson(data);
      return [latLon.lat ?? 0, latLon.lng ?? 0];
    } else {
      debugPrint("Error");
      return [];
    }
  }

  Future<void> getLocationFromMap(TextEditingController textField) async {
    savedAddressDl = await navigatorPush(
      context,
      savedAddressDl.latLng != null
          ? GoogleMapRouteScreen(
              savedAddressDl: savedAddressDl,
              fromSavedAddress: true,
            )
          : GoogleMapRouteScreen(),
    );
    inputFieldOnOffStatusController.value == false ? (origin = savedAddressDl) : (destination = savedAddressDl);
    print("Location Arrived from Map::::::${savedAddressDl.latLng}:::${savedAddressDl.address}");
    textField.text = savedAddressDl.address.toString();
  }
}
