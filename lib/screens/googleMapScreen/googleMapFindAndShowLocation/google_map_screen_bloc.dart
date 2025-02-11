import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/LocationLatLonDl.dart';

import '../location_detail_screen_dl.dart';

class GoogleMapScreenBloc {
  GoogleMapScreenBloc() {}

  var dio = Dio();
  var uuid = Uuid();
  late SharedPreferences pref;
  String apiKey = "AIzaSyBGJ8mEq1C8Kn4mWY-ds6jDfsr7O8-JNGk";

  final searchLocationInputFieldController = TextEditingController();

  final showSuggestionsController = BehaviorSubject<bool>.seeded(false);
  final suggestionsListController = BehaviorSubject<List<Predictions>>();
  final confirmLocationController = BehaviorSubject<String>();

  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  late LatLng currentLocation;

  late CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(22.22, 55.55),
    zoom: 14.4746,
  );

  Future<Position> getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
    }

    final location = await Geolocator.getCurrentPosition();
    currentLocation = LatLng(location.latitude, location.latitude);

    List<Placemark>? locationAddress =
        await GeocodingPlatform.instance?.placemarkFromCoordinates(location.latitude, location.longitude);
    print("Current Position:::::::$locationAddress");
    return await Geolocator.getCurrentPosition();
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

  Future<void> navigateToLocation(String? placeID) async {
    String url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=$apiKey";
    var response = await dio.get(url);

    if (response.statusCode == 200) {
      var data = response.data["result"]["geometry"]["location"];
      final latLon = LocationLatLonDl.fromJson(data);
      LatLng latLng = LatLng(latLon.lat ?? 0, latLon.lng ?? 0);
    } else {
      print("***********************************************");
    }
  }
}
