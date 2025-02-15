import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/location_detail_screen_dl.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/saved_address_dl.dart';

import '../../commons/common_functions.dart';
import 'googleMapFindAndShowLocation/google_map_screen.dart';
import 'location_latlng_dl.dart';

class LocationDetailScreenBloc {
  final BuildContext context;

  LocationDetailScreenBloc(this.context){
    getLastLocationPref();
  }

  var uuid = Uuid();
  var dio = Dio();
  late SharedPreferences pref;
  late SavedAddressDl savedAddressDl;
  List<String> savedAddressList = [];
  String apiKey = "AIzaSyBGJ8mEq1C8Kn4mWY-ds6jDfsr7O8-JNGk";

  final searchLocationInputFieldController = TextEditingController();

  final showSuggestionsController = BehaviorSubject<bool>.seeded(false);
  final suggestionsListController = BehaviorSubject<List<Predictions>>();
  final savedAddressListController = BehaviorSubject<List<String>>();

  Future<void> getCurrentLocation() async {
    if (!await checkPermission()) return;
    final location = await Geolocator.getCurrentPosition();
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemark.isNotEmpty) {
        Placemark place = placemark.first;
        String address =
            "${place.name},${place.thoroughfare},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}";
        if (address.isNotEmpty) {
          savedAddressDl = SavedAddressDl(
              latLng: [location.latitude, location.longitude],
              address: address);
          searchLocationInputFieldController.text = address;
          getConfirmLocation();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Predictions>> getSuggestions(String input) async {
    final sessionToken = uuid.v4();
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$apiKey&sessiontoken=$sessionToken';
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

  void saveAddressInTextFormField(SavedAddressDl data) {
    searchLocationInputFieldController.text = data.address.toString();
    savedAddressDl = data;
    showSuggestionsController.sink.add(false);
  }

  getConfirmLocation() async {
    pref = await SharedPreferences.getInstance();
    List<String> address = pref.getStringList("savedLocation") ?? [];
    savedAddressListController.sink.add(address.reversed.toList());
  }

  confirmLocation() async {
    pref = await SharedPreferences.getInstance();
    if (savedAddressDl.address != null && savedAddressDl.latLng != null) {
      List<String> address = pref.getStringList("savedLocation") ?? [];
      if (address.length >= 4) {
        address.removeAt(0);
        address.add(jsonEncode(savedAddressDl));
      } else {
        address.add(jsonEncode(savedAddressDl));
      }
      await pref.setStringList("savedLocation", address);
      await pref.setString("confirmLocation", jsonEncode(savedAddressDl));
      getConfirmLocation();
      if (context.mounted) {
        navigatorPush(
          context,
          GoogleMapScreen(
            savedAddressDl:
                savedAddressDl,
            fromSavedAddress: true,
          ),
        );
      }
      ;
      searchLocationInputFieldController.clear();
    } else {
      debugPrint("Failed to save");
    }
  }

  Future<bool> checkPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<List<double>> getLatLngFromPlaceID(String? placeID) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=$apiKey";
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

  Future<void> getLocationFromMap() async {
     navigatorPush(
      context,
      savedAddressDl.latLng != null
          ? GoogleMapScreen(
              savedAddressDl: savedAddressDl,
            )
          : GoogleMapScreen(),
    );
    searchLocationInputFieldController.text = savedAddressDl.address.toString();
  }

  getLastLocationPref() async{
    pref = await SharedPreferences.getInstance();
    searchLocationInputFieldController.text = jsonDecode(pref.getString("confirmLocation")??"")["address"]??"";
  }
}
