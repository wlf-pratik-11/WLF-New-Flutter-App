import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/location_detail_screen_dl.dart';

class LocationDetailScreenBloc {
  var dio = Dio();
  late SharedPreferences pref;

  final searchLocationInputFieldController = TextEditingController();

  final showSuggestionsController = BehaviorSubject<bool>.seeded(false);
  final suggestionsListController = BehaviorSubject<List<Predictions>>();
  final confirmLocationController = BehaviorSubject<String>();

  var uuid = Uuid();
  String apiKey = "AIzaSyBGJ8mEq1C8Kn4mWY-ds6jDfsr7O8-JNGk";

  getLatLonFromAddress(String value) async {
    getSuggestions(value);
  }

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

  void saveAddressInTextFormField(String? value) {
    searchLocationInputFieldController.text = value ?? "";
    showSuggestionsController.sink.add(false);
  }

  getConfirmLocation() async {
    pref = await SharedPreferences.getInstance();
    confirmLocationController.sink.add(pref.getString("confirmLocation") ?? StringValues.locationNotAvailable);
  }

  confirmLocation() async {
    pref = await SharedPreferences.getInstance();
    if (searchLocationInputFieldController.text.isNotEmpty) {
      await pref.setString("confirmLocation", searchLocationInputFieldController.text);
    }
    getConfirmLocation();

    // searchLocationInputFieldController.clear();
  }
}
// getLatLonFromAddress(String value) async {
//   var locations = await locationFromAddress(value);
//   List<Placemark>? locationAddress =
//       await GeocodingPlatform.instance?.placemarkFromCoordinates(locations[0].latitude, locations[0].longitude);
//   print(
//       "Current Address:::::::${locationAddress?[0].locality} ${locationAddress?[0].name} ${locationAddress?[0].subLocality} ${locationAddress?[0].country}");
// }

// getLatLonFromAddress(String value) async {
//   var locations = await locationFromAddress(value);
//   List<Placemark>? newPlace =
//       await GeocodingPlatform.instance?.placemarkFromCoordinates(locations[0].latitude, locations[0].longitude);
//
//
//   // this is all you need
//   Placemark? placeMark = newPlace?[0];
//   String? name = placeMark?.name;
//   String? subLocality = placeMark?.subLocality;
//   String? locality = placeMark?.locality;
//   String? administrativeArea = placeMark?.administrativeArea;
//   String? postalCode = placeMark?.postalCode;
//   String? country = placeMark?.country;
//   String address = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
//
//   print("Current Address:::::::${address}");
// }

// getLatLonFromAddress(String value) async {
//   List<Location> location = await locationFromAddress(value);
//
//   print("Current Address:::::::${location}");
// }
